.PHONY: all check
NRUN := 100
CPU := $(shell perl -lne 'print $$1=~s/[-()\s]/_/gr and exit if m/model.name.*: (.*)/' < /proc/cpuinfo)-$(shell hostname)
BENCHCMD := hyperfine --warmup 1 -m $(NRUN) --export-csv
all:  out/$(CPU)/versions.txt
check:
	bats --verbose-run t/test_niimean.bats

## rust
target/release/niimean: target/release/voxcor
target/release/voxcor: $(wildcard src/*rs)
	cargo build --release

## go
voxcor: main.go util/util.go
	go build

niimean/niimean: niimean/main.go util/util.go
	cd $(@D) && go build

# define output files for each file in scripts
NIIMEAN_SCRIPT_OUT := $(patsubst scripts/%,out/$(CPU)/niimean/%.csv,$(wildcard scripts/niimean*)) 

# always include rust and go. and only fsl ants anfi and freesurfer if the system has them available
NIIMEAN_BIN_OUT := $(patsubst %,out/$(CPU)/niimean/%.csv,rust go $(if $(shell command -v fslstats 2> /dev/null),fsl,) $(if $(shell command -v 3dBrickStat 2> /dev/null),afni,) $(if $(shell command -v MeasureMinMaxMean 2> /dev/null),ants,) $(if $(shell command -v mris_calc 2> /dev/null),freesurfer,))


## benchmark for compiled -- TODO symlink so we can use from scripts? howto preserve make dep tree
out/$(CPU)/niimean/go.csv: niimean/niimean          | out/$(CPU)/niimean/
	$(BENCHCMD) $@ $^
out/$(CPU)/niimean/rust.csv: target/release/niimean | out/$(CPU)/niimean/
	$(BENCHCMD) $@ $^

# generic
out/$(CPU)/niimean/%.csv: scripts/% | out/$(CPU)/niimean/
	$(BENCHCMD) $@ $^

# these can probably go into sh scripts.
#   will that add any overhead?
#   remove from list if binary doesn't exist?
out/$(CPU)/niimean/fsl.csv:         | out/$(CPU)/niimean/
	$(BENCHCMD) $@ "fslstats wf-mp2rage-7t_2017087.nii.gz -m"
out/$(CPU)/niimean/afni.csv:        | out/$(CPU)/niimean/
	$(BENCHCMD) $@ "3dBrickStat -slow -mean wf-mp2rage-7t_2017087.nii.gz"
out/$(CPU)/niimean/freesurfer.csv:  | out/$(CPU)/niimean/
	$(BENCHCMD) $@ "mris_calc wf-mp2rage-7t_2017087.nii.gz mean"
out/$(CPU)/niimean/ants.csv:        | out/$(CPU)/niimean/
	$(BENCHCMD) $@ "MeasureMinMaxMean 3 wf-mp2rage-7t_2017087.nii.gz" \

# after benchmarking all separately, combine sorted on average run time
# grab the first header, and then sort without any headers
out/$(CPU)/niimean-stats.csv: $(NIIMEAN_SCRIPT_OUT) $(NIIMEAN_BIN_OUT) | out/$(CPU)/
	sed 1q $^ > $@
	grep -hv ,mean, $^ | sort -t, -k2,2n >> $@

# new stats file? update versions
out/$(CPU)/versions.txt: out/$(CPU)/niimean-stats.csv | out/$(CPU)/
	./versions.bash > $@

%/:
	mkdir -p $@

# mni template is too small. using larger non-skullstripped brain
## use MNI template as the image tor all tests
#tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz:
#	curl -O https://templateflow.s3.amazonaws.com/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz
