using Statistics
using NIfTI
ni = niread("/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz");
print(mean(ni))
