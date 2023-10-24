use nifti::{NiftiObject,ReaderOptions,IntoNdArray};
use log::{info};
fn main() -> Result<(), nifti::error::NiftiError> {
    env_logger::init();
    info!("reading niftis");
    let x = ReaderOptions::new().read_file("/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz")?;
    let xvol = x.into_volume().into_ndarray::<f32>()?;

    info!("mean calc");
    let mut sum = 0.0;
    for (_, value) in xvol.indexed_iter() {
        sum += value;
    }
    
    let mean = sum/(xvol.len() as f32);
    println!("mean: {mean}");

    return Ok(());
}
