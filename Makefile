NRUN := 100
CPU := $(shell perl -lne 'print $$1=~s/[-()\s]/_/gr and exit if m/model.name.*: (.*)/' < /proc/cpuinfo)-$(shell hostname)
all:  out/$(CPU)-versions.txt

## rust
target/release/niimean: target/release/voxcor
target/release/voxcor:
	cargo build --release

## go
voxcor: main.go util/util.go
	go build

niimean/niimean: niimean/main.go util/util.go
	cd $(@D) && go build

##
out/$(CPU)-stats.csv: niimean/niimean target/release/niimean $(wildcard scripts/*) | out/
	hyperfine --warmup 1 -m $(NRUN)  --export-csv $@ \
		"3dBrickStat -slow /home/foranw/mybrain/mybrain_2017-08_7t.nii.gz"\
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
