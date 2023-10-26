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
  run niimean/niimean
  check_mean "$output"
}

test_niimean_rust() { #@test
  run target/release/niimean
  check_mean "$output"
}
