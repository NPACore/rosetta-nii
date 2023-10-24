#!/usr/bin/env Rscript

# 20231023WF - init
#   benchmark test

x <- oro.nifti::readNIfTI('/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz')
mean(x@.Data)
