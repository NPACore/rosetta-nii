#!/usr/bin/env python
import nibabel as nib
import numpy as np
roi = nib.load('t/syn_roi.nii.gz').get_fdata().flat
x = nib.load('t/syn1.nii.gz').get_fdata().flat
y = nib.load('t/syn2.nii.gz').get_fdata().flat

rois = np.unique(roi)

for ri in rois:
    if ri == 0:
        continue

    roi_idx = np.where(roi == ri)
    r = np.correlate(x[roi_idx], y[roi_idx])
    mx = np.mean(x[roi_idx])
    my = np.mean(y[roi_idx])
    print(f"{ri}\t{len(roi_idx)}\t{mx}\t{my}\t{r}")
