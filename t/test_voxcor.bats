setup(){
 ARGS=(-r t/syn_roi.nii.gz -x t/syn1.nii.gz -y t/syn2.nii.gz)
 if ! test -r t/syn_roi.nii.gz; then
    3dcalc -a jRandomDataset:100,100,100,1 -expr 'a*2' -prefix syn1.nii.gz
    3dcalc -a syn1.nii.gz -b jRandomDataset:100,100,100,1 -expr 'a+b/2' -prefix syn2.nii.gz
    echo -e '20 20 20 1\n80 85 85 3' | 3dUndump -master syn1.nii.gz -srad 20 -prefix syn_roi.nii.gz -overwrite  -
 fi
 RES=($(scripts/voxcor.rs "${ARGS[@]}"|perl -slane 'print sprintf("$F[0]\t.*%.3f", $F[$#F])'))
}

voxcor_cmp_rust(){
  local output="$*"
  echo $output
  echo ${RES[0]}
  echo ${RES[1]}
  [[ $output =~ ${RES[0]} ]]
  [[ $output =~ ${RES[1]} ]]
}

test_voxcor.go() { #@test
  run scripts/voxcor.go "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}

test_voxcor.py() { #@test
  run scripts/voxcor.py "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}

test_voxcor.R() { #@test
  run scripts/voxcor.R "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}

test_voxcor.jl() { #@test
  run scripts/voxcor.jl "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}

test_voxcor.m() { #@test
  run scripts/voxcor.m "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}

test_voxcor.pl() { #@test
  perl -MPDL -e 1 || skip
  run scripts/voxcor.pl "${ARGS[@]}"
  voxcor_cmp_rust "${output}"
}
