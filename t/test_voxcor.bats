setup(){
 :
 # 3dcalc -a jRandomDataset:100,100,100,1 -expr 'a*2' -prefix syn1.nii.gz
 # 3dcalc -a syn1.nii.gz -b jRandomDataset:100,100,100,1 -expr 'a+b/2' -prefix syn2.nii.gz
 # echo -e '20 20 20 1\n80 85 85 3' | 3dUndump -master syn1.nii.gz -srad 20 -prefix syn_roi.nii.gz -overwrite  -
}
