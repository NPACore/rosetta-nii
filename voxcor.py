#!/usr/bin/env python
import nibabel as nib
import numpy as np
import logging as log
log.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=log.INFO,
    datefmt='%Y-%m-%d %H:%M:%S')

log.info("loading files")
roi = nib.load('/tmp/all1.nii.gz').get_fdata().flat
x = nib.load('/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz').get_fdata().flat
y = nib.load('/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz').get_fdata().flat
log.info("loaded")

log.info("getting rois")
rois = np.unique(roi)

log.info("getting stats")
for ri in rois:
    roi_idx = np.where(roi == ri)
    r = np.correlate(x[roi_idx], y[roi_idx])
    mx = np.mean(x[roi_idx])
    my = np.mean(y[roi_idx])
    print(f"{ri}\t{len(roi_idx)}\t{mx}\t{my}\t{r}")
