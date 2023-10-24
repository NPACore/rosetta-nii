NRUN := 100
CPU := $(shell perl -lne 'print $$1=~s/[-()\s]/_/gr and exit if m/model.name.*: (.*)/' < /proc/cpuinfo)-$(shell hostname)
all:  out/$(CPU)-versions.txt

## rust
target/release/niimean: target/release/voxcor
target/release/voxcor: $(wildcard src/*rs)
	cargo build --release

## go
voxcor: main.go util/util.go
	go build

niimean/niimean: niimean/main.go util/util.go
	cd $(@D) && go build

## benchmark
out/$(CPU)-stats.csv: niimean/niimean target/release/niimean $(wildcard scripts/*) | out/ # tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz
	hyperfine --warmup 1 -m $(NRUN)  --export-csv $@ \
		"3dBrickStat -slow wf-mp2rage-7t_2017087.nii.gz"\
		"fslstats wf-mp2rage-7t_2017087.nii.gz -m"\
		"deno run --allow-read scripts/niimean.js" \
	   scripts/niimean.m \
		niimean/niimean \
		scripts/niimean.py \
		"julia scripts/niimean.jl"\
		scripts/niimean.R \
		"target/release/niimean"

# new stats file? update versions
out/$(CPU)-versions.txt: out/$(CPU)-stats.csv | out/
	./versions.bash > $@

%/:
	mkdir $@

# mni template is too small. using larger non-skullstripped brain
## use MNI template as the image tor all tests
#tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz:
#	curl -O https://templateflow.s3.amazonaws.com/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz
