#!/usr/bin/env julia
using Statistics
using NIfTI
ni = niread("wf-mp2rage-7t_2017087.nii.gz");
print(mean(ni/1000)*1000)
# sum of 'ni' too large for float64 type! scale to avoid overflow
# w/o scalling mean reports 836.149 instead of actual 838.206399
# much slower alternative: mean(BigFloat,ni)
