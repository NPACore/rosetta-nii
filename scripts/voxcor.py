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
    xs = x[roi_idx] #.flatten()
    ys = y[roi_idx] #.flatten()
    n = len(xs)
    mx = np.mean(xs)
    my = np.mean(ys)
    cor = np.corrcoef(xs, ys)[0,1]
    print(f"{ri}\t{n}\t{mx}\t{my}\t{cor}")
