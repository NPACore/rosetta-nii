#!/usr/bin/env bash
#
# get language dependancies
#

# wget julia, unzip, add to path
command -v julia &&
   julia --eval 'using Pkg; Pkg.add(["Statistics", "NIfTI"])'

command -v Rscript &&
   Rscript -e "if(!'oro.nifti' %in% installed.packages()) install.packages('oro.nifti')"

echo "NB. re. python depends: this would install install to system unless you've source a virtual env; do that or add '--break-system-packages' $0:$LINENO"
command -v python3 &&
   python3 -m pip install nibabel numpy

## TODO: ensure go 2.23

# TODO: ensure octave 8.3
# need spm12. might already have installed elsewhere. otherwise go to Downloads
SPMDIR=${SPMDIR:-$HOME/Downloads/SPM12}
if command -v octave && [ -z "$(octave --eval 'which spm')" ] && ! test -d $SPMDIR; then
   spmzip=$(dirname "$SPMDIR")/spm12.zip
   wget 'https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip' -O "$spmzip"
   (cd $SPMDIR/src && make PLATFORM=octave install)
fi

# install rustup for rustc and cargo?
# command -v rustup -a  && rustup update

# get deno for javascript
command -v deno || cargo install deno

# cpanm PDL or apt install perl-pdl
if ! command -v perld2; then
   if   command -v apt; then sudo apt install pdl 
   elif command -v yay; then yay -S perl-pdl
   elif command -v cpanm; then cpanm PDL
   else
      echo dont know how to install PDL for perl 
   fi
fi
