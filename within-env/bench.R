library(microbenchmark)
library(dplyr)
library(oro.nifti) # loading early to avoid first run penetlty/stable benchmark
bench <- microbenchmark(
  "niimean" = source('scripts/niimean.R'),
  "voxcor" = source("scripts/voxcor.R"), times=10)

bsmry <- as.data.frame(summary(bench)) |>
    rename(prog=expr)|>
    mutate(across(where(is.numeric)& !matches('neval'), \(x) x/10e2))
out<-paste0('out/',system('./cpu-info.pl',intern=T),'/r-bench.csv')
write.csv(file=out, ,quote=F,row.names=F)
