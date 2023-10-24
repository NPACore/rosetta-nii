//https://github.com/Enet4/nifti-rs
use nifti::{NiftiObject, ReaderOptions, NiftiVolume,IntoNdArray};
use log::{info, warn};

//https://doc.rust-lang.org/stable/std/collections/struct.HashMap.html
use std::collections::HashMap;
use std::collections::hash_map::Entry;
//use ndarray::{ArrayBase};

// https://docs.rs/ndarray-stats/latest/ndarray_stats/trait.CorrelationExt.html#tymethod.pearson_correlation

fn main() -> Result<(), nifti::error::NiftiError> {
    env_logger::init();
    info!(target: "time", "reading niftis");
    let roi = ReaderOptions::new().read_file("/tmp/all1.nii.gz")?;
    let x = ReaderOptions::new().read_file("/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz")?;
    //let y = ReaderOptions::new().read_file("/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz")?;
    
    //let header = obj.header();
    //let volume = obj.volume();
    //let dims = volume.dim();
    let roi_vol = roi.into_volume().into_ndarray::<f32>()?;
    let xvol = x.into_volume().into_ndarray::<f32>()?;
    let mut roi_idx = HashMap::new();

    info!(target: "time", "read; stats");
    for (i, value) in roi_vol.indexed_iter() {
        let roi = *value as i32;
        let idx = i;
        if roi == 0 { continue; }
        match roi_idx.entry(roi) {
            Entry::Vacant(e) => { e.insert(vec![idx]); },
            Entry::Occupied(mut e) => { e.get_mut().push(idx); }
        }
    }

    info!(target:"time", "done {}", xvol[[1,1,1]]);

    Ok(())
}
