#!/usr/bin/env octave
addpath('~/Downloads/spm12')
r =  spm_vol('t/syn_roi.nii.gz').dat;
x =  spm_vol('t/syn1.nii.gz').dat;
y =  spm_vol('t/syn2.nii.gz').dat;

rois = setdiff(unique(r)',0);
for roi=rois
   i = r==roi;
   xs = x(i); ys=y(i);
   fprintf("%d\t%d\t%f\t%f\t%f\n", roi, length(i),mean(xs),mean(ys),corr(xs,ys))
end
