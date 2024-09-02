.PHONY: all check scripts/niimean.java

## Setup
NRUN := 15
CPU := $(shell ./cpu-info.pl)
BENCHCMD := hyperfine -i --warmup 1 -m $(NRUN) --export-csv
NIIMEAN_SCRIPTS := $(wildcard scripts/niimean*) scripts/niimean.rs scripts/niimean.go scripts/niimean.java
VOXCOR_SCRIPTS := $(wildcard scripts/voxcor*)

all:  out/rank_plot.png
check: out/$(CPU)/checks.txt

out/rank_plot.png: out/$(CPU)/versions.txt
	Rscript plot.R

## rust
scripts/niimean.rs scripts/voxcor.rs: $(wildcard src/*rs)
	cargo build --release
	cp -u target/release/niimean scripts/niimean.rs
	cp -u target/release/voxcor scripts/voxcor.rs

## go
scripts/voxcor.go: main.go util/util.go
	go build
	mv voxcor $@

scripts/niimean.go: niimean/main.go util/util.go
	cd niimean && go build
	mv niimean/niimean $@

## java
scripts/niimean.java: build/libs/rosetta-nii.jar

build/libs/rosetta-nii.jar: src/main/java/niimean/NiftiMean.java
	gradle build

## benchmarks

# define output files for each file in scripts
NIIMEAN_SCRIPT_OUT := $(patsubst scripts/%,out/$(CPU)/niimean/%.csv,$(NIIMEAN_SCRIPTS))
VOXCOR_SCRIPT_OUT := $(patsubst scripts/%,out/$(CPU)/voxcor/%.csv,$(VOXCOR_SCRIPTS))

# always include rust and go. and only fsl ants anfi and freesurfer if the system has them available
NIIMEAN_BIN_OUT := $(patsubst %,out/$(CPU)/niimean/%.csv,$(if $(shell command -v fslstats 2> /dev/null),fsl,) $(if $(shell command -v 3dBrickStat 2> /dev/null),afni,) $(if $(shell command -v MeasureMinMaxMean 2> /dev/null),ants,) $(if $(shell command -v mris_calc 2> /dev/null),freesurfer,))

# voxcor
out/$(CPU)/voxcor/%.csv: scripts/% | out/$(CPU)/voxcor/
	$(BENCHCMD) $@ "$^ -r t/syn_roi.nii.gz -x t/syn1.nii.gz -y t/syn2.nii.gz"


# generic
out/$(CPU)/niimean/%.csv: scripts/% | out/$(CPU)/niimean/
	$(BENCHCMD) $@ $^

# java specific (avoid sh for overhead; todo: compile with GraalVM?)
out/$(CPU)/niimean/java.csv: build/libs/rosetta-nii.jar | out/$(CPU)/niimean/
	$(BENCHCMD) $@ 'java -cp $^ niimean.NiftiMean'

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

# confirm functions actually work
out/$(CPU)/checks.txt: out/$(CPU)/check-niimean.txt out/$(CPU)/check-voxcor.txt
	cat $^ > $@

out/$(CPU)/check-niimean.txt: $(NIIMEAN_SCRIPTS)
	bats --verbose-run t/test_niimean.bats |tee $@

out/$(CPU)/check-voxcor.txt: $(VOXCOR_SCRIPTS)
	bats --verbose-run t/test_voxcor.bats |tee $@

# after benchmarking all separately, combine sorted on average run time
# grab the first header, and then sort without any headers
out/$(CPU)/niimean-stats.csv: $(NIIMEAN_SCRIPT_OUT) $(NIIMEAN_BIN_OUT) | out/$(CPU)/
	sed 1q $^ > $@
	grep -hv ,mean, $^ | sort -t, -k2,2n >> $@

out/$(CPU)/voxcor-stats.csv: $(VOXCOR_SCRIPT_OUT)| out/$(CPU)/
	sed 1q $^ > $@
	grep -hv ,mean, $^ | sort -t, -k2,2n >> $@

# new stats file? update versions
out/$(CPU)/versions.txt: out/$(CPU)/niimean-stats.csv out/$(CPU)/voxcor-stats.csv | out/$(CPU)/
	./versions.bash > $@

%/:
	mkdir -p $@

# mni template is too small. using larger non-skullstripped brain
## use MNI template as the image tor all tests
#tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz:
#	curl -O https://templateflow.s3.amazonaws.com/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz
