//https://github.com/Enet4/nifti-rs
use nifti::{NiftiObject, ReaderOptions, IntoNdArray}; // NiftiVolume,
//use log::{info};
use ndarray::Zip;
//https://doc.rust-lang.org/stable/std/collections/struct.HashMap.html
use std::collections::HashMap;
use std::collections::hash_map::Entry;
use ndarray::ArrayView; //{ArrayBase};
// use fast_stats::fstats_f64; //streaming mean
use ndarray_stats::CorrelationExt;

use clap::Parser;

/// Calculate within ROI correlation of voxels between two 3D images 
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// roi 3D image. voxel value is roi index
    #[arg(short, long)]
    roi: String,
    /// first 3D image
    #[arg(short, long)]
    x: String,
    /// second 3D image
    #[arg(short, long)]
    y: String
}


// https://docs.rs/ndarray-stats/latest/ndarray_stats/trait.CorrelationExt.html#tymethod.pearson_correlation

fn main() -> Result<(), nifti::error::NiftiError> {
    let args = Args::parse();

    let roi = ReaderOptions::new().read_file(args.roi)?; // "t/syn_roi.nii.gz"
    let x = ReaderOptions::new().read_file(args.x)?; // "t/syn1.nii.gz"
    let y = ReaderOptions::new().read_file(args.y)?; // "t/syn2.nii.gz"
    
    // TODO: check headers match
    //let header = obj.header();
    //let volume = obj.volume();
    //let dims = volume.dim();
    let roi_vol = roi.into_volume().into_ndarray::<f32>()?;
    let xvol = x.into_volume().into_ndarray::<f64>()?;
    let yvol = y.into_volume().into_ndarray::<f64>()?;
    let mut roi_idx = HashMap::new();

    // for preformance and "zip" discussion:
    // https://github.com/rust-ndarray/ndarray/issues/526
 
    Zip::from(&roi_vol).and(&xvol).and(&yvol).for_each(|&r, &x, &y| {
       let roi = r as i32;
       if roi==0 { return; }
        match roi_idx.entry(roi) {
            Entry::Vacant(e) => { e.insert([vec![x], vec![y]]); },
            Entry::Occupied(mut e) => {
                e.get_mut()[0].push(x);
                e.get_mut()[1].push(y);
            }
        }
    });
    //TODO: sort keys
    for (roi, xy) in roi_idx.iter(){
        let n = xy[0].len();
        let x = ArrayView::from(&xy[0]);
        let y = ArrayView::from(&xy[1]);
        let mx = x.mean().unwrap();
        let my = y.mean().unwrap();
        let mut sxy : f64 = 0.0;
        let mut sx :f64 = 0.0;
        let mut sy :f64 = 0.0;
        Zip::from(&x).and(&y).for_each(|&xi, &yi| {
            sxy += (xi-mx)*(yi-my);
            sx += (xi-mx).powi(2);
            sy += (yi-my).powi(2);
        });
        let r = sxy/(sx*sy).sqrt();
        

        //let a = ndarray::arr2(&[&x,&y]);
        //let r = a.pearson_correlation().unwrap()[0];
        //let my = xy[1].mean();
        println!("{roi}\t{n}\t{mx}\t{my}\t{r}")
         
    }

    Ok(())
}
