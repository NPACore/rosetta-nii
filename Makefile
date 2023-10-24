all:  target/debug/voxcor voxcor

target/debug/niimean: target/debug/voxcor
target/debug/voxcor:
	cargo build

voxcor: main.go util/util.go
	go build

niimean/niimean: niimean/main.go util/util.go
	cd $(@D) && go build

stats.csv: niimean/niimean target/debug/niimean
	hyperfine --warmup 1  --export-csv $@ "3dBrickStat -slow /home/foranw/mybrain/mybrain_2017-08_7t.nii.gz" "deno run --allow-read niimean.js" "./niimean.py" "./niimean.R" "niimean/niimean" "./niimean.m" "julia niimean.jl"  #"target/debug/niimean"
#	Summary
#  3dBrickStat -slow /home/foranw/mybrain/mybrain_2017-08_7t.nii.gz ran
#    1.66 ± 0.10 times faster than deno run --allow-read niimean.js
#    2.12 ± 0.26 times faster than ./niimean.py
#    4.32 ± 0.13 times faster than ./niimean.R
