# Rosetta Nii
Various implementations of neuroimaging computation tasks for benchmarking performance and code demonstration.

Currently, only mean of nii.gz dataset.


## Results
See hyperfine [`out/*stats.csv`](out/AMD_FX_tm__9590_Eight_Core_Processor-kt-stats.csv) as run in [`Makefile`](Makefile)
out/

### Intel Xeon server
```
'fslstats wf-mp2rage-7t_2017087.nii.gz -m' ran # fsl, c
    1.50 ± 0.07 times faster than '3dBrickStat -slow wf-mp2rage-7t_2017087.nii.gz' # afni, c
    1.53 ± 0.07 times faster than 'MeasureMinMaxMean 3 wf-mp2rage-7t_2017087.nii.gz' # ants, c++
    2.72 ± 0.12 times faster than 'deno run --allow-read scripts/niimean.js'
    4.30 ± 0.20 times faster than 'target/release/niimean' # rust
    4.32 ± 0.18 times faster than 'julia scripts/niimean.jl'
    4.84 ± 0.25 times faster than 'scripts/niimean.py'
    5.93 ± 0.24 times faster than 'mris_calc wf-mp2rage-7t_2017087.nii.gz mean' # freesurfer, c++
    6.01 ± 0.36 times faster than 'scripts/niimean.m'
    7.27 ± 0.31 times faster than 'scripts/niimean.R'
    8.52 ± 0.48 times faster than 'niimean/niimean' #go

```


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

### Notes
For a simple mean calc, javascript and octave are faster than compile go and rust!

These times are more a measure of an interpreter/VM's startup time. They also demonstrate how much effort the community/library authors have put into optimzing (likely w/ compiled `c` code) hot paths (spm12 in octave, numpy in python).

The rust implementation should be built with `--release`, debug version performance is 10x worse!

Julia's interpreter (1.9.3) startup time is reasonable! It's overall time is on par with python (numpy, not native python).
SIMD "vectorized" operations in python (via numpy) are fast!

R's slow to start.

Javascript is painful to write. Both it and the golang version organize the nifti matrix data as a 1D vector.

Processor makes a differnce in the shootout.


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
* rust
  - `[rustup](https://rustup.rs/) update`
* octave
  1. download spm12 and extract to `~/Downoads/spm12` [`scripts/niimean.m`](scripts/niimean.m) hardcodes addpath 
  1. compile `cd src/ && make PLATFORM=octave install`
* julia
  1. install package in repl like `] add NIfTI` 
* R
  1. `install.packages('oro.nifti')`
* deno
  - `cargo install deno`
  - first run will pull in npm package `nifti-reader-js`

### Debain stable (12.0 "bookworm") in 2023

go (1.19 vs 1.21) and octave (7 vs 8.3) are out of date on debian stable.
To use newer versions on rhea, update the path to include the compile-from-recent-source bin dir:

```
export PATH="/opt/ni_tools/utils/go/bin:$PATH"

# source dl and extracted to /opt/ni_tools/octave-8.3.0-src
# ./configure --prefix=/opt/ni_tools/octave-8.3/ && make install
export PATH="/opt/ni_tools/octave-8.3/bin:$PATH"
```

NB. but use debian backport https://wiki.debian.org/SimpleBackportCreation
## TODO

- [ ] get expert goland and rust advice/implementation (should be faster?)
- [ ] implement various styles (and more complex calculations)
  - [ ] loop vs vector; expect python loop to be especially slow
  - [ ] parallel processing
- [ ] preform within interpreter time benchmarking (remove startup costs)
- [ ] containerize benchmarks
- [ ] other implementations
  - [ ] julia's APL implementation
  - [ ] fix perl's `PDL::IO::Nifti` to work with compresssed images (remove extra seek)
  - [ ] common lisp or guile version (ffi w/ niftilib)
  - [ ] [compile julia](https://docs.juliahub.com/PackageCompiler/MMV8C/1.2.1/devdocs/binaries_part_2.html)
