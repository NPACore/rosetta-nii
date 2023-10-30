#!/usr/bin/env Rscript
r <- oro.nifti::readNIfTI('t/syn_roi.nii.gz')
x <- oro.nifti::readNIfTI('t/syn1.nii.gz')
y <- oro.nifti::readNIfTI('t/syn2.nii.gz')
rois <- setdiff(unique(as.vector(r@.Data)),0)
gen_info <- function(roi) {
   xr <- x[r@.Data==roi]
   yr <- y[r@.Data==roi]
   data.frame(roi=roi,nx=length(xr),ny=length(yr), mx=mean(xr), my=mean(yr), r=cor(xr,yr))
}
lapply(rois, gen_info) |> data.table::rbindlist()
