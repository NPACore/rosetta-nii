See hyperfine [`stats.csv`](stats.csv) as run in [`Makefile`](Makefile)

```
  3dBrickStat -slow /home/foranw/mybrain/mybrain_2017-08_7t.nii.gz ran
    1.68 ± 0.08 times faster than deno run --allow-read niimean.js
    1.70 ± 0.07 times faster than ./niimean.m
    1.87 ± 0.09 times faster than niimean/niimean
    2.24 ± 0.26 times faster than ./niimean.py
    2.43 ± 0.07 times faster than julia niimean.jl
    4.44 ± 0.12 times faster than ./niimean.R
```

For a simple mean calc, javascript and octave are faster than go!

These times are more a measure of an interpreter/VM's startup time. They also demonstrate how much effort has been put into optimzing (w/c code) hot paths (spm12 in octave, numpy in python).

The rust implementation is so bad (20s!?) that it's not included.

Julia's (1.9.3) startup time is now reasonable! It's overall time is on par with python (numpy, not native python).

R's slow to start.

Javascript is painful to write. Both it and go are organizing the nifti as a 1D vector.


TODO: [julia](https://docs.juliahub.com/PackageCompiler/MMV8C/1.2.1/devdocs/binaries_part_2.html)
