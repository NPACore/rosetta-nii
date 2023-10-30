#!/usr/bin/env julia
using Statistics
using NIfTI
r = niread("t/syn_roi.nii.gz");
x = niread("t/syn1.nii.gz");
y = niread("t/syn2.nii.gz");

rois = setdiff(unique(r),0);
for roi=rois
   # i = findall(rr->rr==roi, r); # SLOW
   i = r.==roi;
   println(roi,"\t", length(i),"\t", mean(x[i]),"\t", mean(y[i]),"\t", cor(x[i],y[i]));
end
