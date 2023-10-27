
# wget julia, unzip, add to path
julia -e 'Pkg.add Statistics NIfTI'

R -e 'install.packages("oro.nifti")'

python3 -m pip install nibabel numpy

# ensure go 2.23

# ensure octave 8.3
# wget SPM12, unzip in Downloads

# install rustup
rustup update
cargo install deno


# adding new go depends
#   go get github.com/viterin/vek
# adding new rust depends
#   cargo add ndarray
