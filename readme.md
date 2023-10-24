# Rosetta Nii
Various implementations of neuroimaging computation tasks for benchmarking performance and code demonstration.

Currently, only mean of nii.gz dataset.


## Results
See hyperfine [`out/*stats.csv`](out/AMD_FX_tm__9590_Eight_Core_Processor-kt-stats.csv) as run in [`Makefile`](Makefile)
out/

### Intel i7 laptop
```
3dBrickStat -slow /home/foranw/mybrain/mybrain_2017-08_7t.nii.gz ran
    1.68 ± 0.08 times faster than deno run --allow-read niimean.js
    1.70 ± 0.07 times faster than ./niimean.m
    1.87 ± 0.09 times faster than niimean/niimean
    2.24 ± 0.26 times faster than ./niimean.py
    2.43 ± 0.07 times faster than julia niimean.jl
    4.44 ± 0.12 times faster than ./niimean.R
```

### AMD desktop
```
fslstats wf-mp2rage-7t_2017087.nii.gz -m ran
    1.39 ± 0.01 times faster than 3dBrickStat -slow wf-mp2rage-7t_2017087.nii.gz
    2.93 ± 0.04 times faster than scripts/niimean.m
    2.96 ± 0.05 times faster than deno run --allow-read scripts/niimean.js
    3.75 ± 0.04 times faster than scripts/niimean.py
    4.13 ± 0.06 times faster than julia scripts/niimean.jl
    5.27 ± 0.07 times faster than target/release/niimean
    5.65 ± 0.05 times faster than niimean/niimean
    7.30 ± 0.10 times faster than scripts/niimean.R

```

### Intel Xeon server
```
```

### Notes
For a simple mean calc, javascript and octave are faster than compile go and rust!

These times are more a measure of an interpreter/VM's startup time. They also demonstrate how much effort the community/library authors have put into optimzing (likely w/ compiled `c` code) hot paths (spm12 in octave, numpy in python).

The rust implementation should be built with `--release`, debug version performance is 10x worse!

Julia's interpreter (1.9.3) startup time is reasonable! It's overall time is on par with python (numpy, not native python).
SIMD "vectorized" operations in python (via numpy) are fast!

R's slow to start.

Javascript is painful to write. Both it and the golang version organize the nifti matrix data as a 1D vector.

Processor makes a differnce in the shootout.

TODO: [julia](https://docs.juliahub.com/PackageCompiler/MMV8C/1.2.1/devdocs/binaries_part_2.html)

## Run

Run make in shell on a terminal. Optionally set `NRUN` (default 100 runs for each)

```bash
make NRUN=10
```

## Setup

Benchmarking uses [`hyperfine`](https://github.com/sharkdp/hyperfine).

* c
  - `3dBrickstat` is from AFNI
  - `fslstats` is from fsl
* octave
  1. download spm12 and extract to `~/Downoads/spm12` [`scripts/niimean.m`](scripts/niimean.m) hardcodes addpath 
  1. compile `cd src// && make PLATFORM=octave install`
* julia
  1. install package `add NIfTI` 
* R
  1. `install.packages('oro.nifti')`
* deno
  - first run will pull in npm package `nifti-reader-js`


## TODO

- [ ] implement various styles (loop vs vector)
- [ ] get expert goland and rust advice/implementation
- [ ] add nifti to repo or Makefile. use that instead of "mybrain"
- [ ] hyperfine per run and code to average. dont want to run full suit for change in single file
