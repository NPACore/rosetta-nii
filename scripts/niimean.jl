using Statistics
using NIfTI
ni = niread("wf-mp2rage-7t_2017087.nii.gz");
print(mean(ni))
