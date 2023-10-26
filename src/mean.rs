use nifti::{NiftiObject,ReaderOptions,IntoNdArray};
use log::{info};
fn main() -> Result<(), nifti::error::NiftiError> {
    env_logger::init();
    info!("reading niftis");
    let x = ReaderOptions::new().read_file("wf-mp2rage-7t_2017087.nii.gz")?;
    // NB. w/f32 mean value is 838.4101 instead of 838.20
    let xvol = x.into_volume().into_ndarray::<f64>()?; // need 64 for large intenger sum in mean

    //info!("mean calc");
    // slow manual for loop
    /*
    let mut sum = 0.0;
    for (_, value) in xvol.indexed_iter() {
        sum += value;
    }
    let mean = sum/(xvol.len() as f64);
    */

    // fast ndarray's mean
    let mean = xvol.mean().unwrap();

    println!("{mean}");

    return Ok(());
}
