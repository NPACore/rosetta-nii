#!/usr/bin/env python
import nibabel as nib
import numpy as np
x = nib.load('wf-mp2rage-7t_2017087.nii.gz').get_fdata().flat
print(np.mean(x))
