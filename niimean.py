#!/usr/bin/env python
import nibabel as nib
import numpy as np
x = nib.load('/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz').get_fdata().flat
print(np.mean(x))
