#!/usr/bin/env Rscript

# 20231023WF - init
#   benchmark test

x <- oro.nifti::readNIfTI('wf-mp2rage-7t_2017087.nii.gz')
mean(x@.Data)
