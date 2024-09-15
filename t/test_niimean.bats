check_mean(){ [[ "$*" =~ 838.20 ]]; }

test_niimean_jl() { #@test
  run scripts/niimean.jl
  [ $status -eq 0 ]
  check_mean "$output"
}

test_niimean_m() { #@test
  run scripts/niimean.m
  [ $status -eq 0 ]
  check_mean "$output"
}

test_niimean_py() { #@test
  run scripts/niimean.py
  [ $status -eq 0 ]
  check_mean "$output"
}

test_niimean_R() { #@test
  run scripts/niimean.R
  [ $status -eq 0 ]
  check_mean "$output"
}

test_niimean_js() { #@test
  run deno run --allow-read scripts/niimean.js
  check_mean "$output"
}

test_niimean_go() { #@test
  run scripts/niimean.go
  check_mean "$output"
}

test_niimean_rust() { #@test
  run scripts/niimean.rs
  check_mean "$output"
}

test_niimean_pl() { #@test
  perl -MPDL -e 1 || skip
  run scripts/niimean.pl
  check_mean "$output"
}

test_niimean_java() { #@test
  test -r build/libs/rosetta-nii.jar || skip
  run java -jar build/libs/rosetta-nii.jar
  check_mean "$output"
}

test_niimean_fortran() { #@test
  test -r scripts/niimean.fortran || skip
  run scripts/niimean.fortran
  check_mean "$output"
}
