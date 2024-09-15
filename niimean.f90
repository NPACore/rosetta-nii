program niimean
   ! use stdlib_stats, only: mean
   implicit none

integer :: io, stat
integer :: vox_offset_pos, magic_pos, dim_pos, datatype_pos
integer :: hdr_size
real*4 :: voxoffset
real :: nvoxels
integer*2 :: imgdim(8), bitpix
character*4 :: magic_string
real, allocatable :: data(:)
!! do loop is slower than casting whole array to real(16)
! integer :: i
! real*16 :: voxsum = 0

logical :: debug = .false.

! for header byte positions, see
! https://brainder.org/2012/09/23/the-nifti-file-format/
! also see AFNI's tool like
!  nifti1_tool -disp_hdr  -infile ./wf-mp2rage-7t_2017087.nii
!
!  nifti1_tool -disp_ci 100 100 100 0 0 0 0 -infiles ./wf-mp2rage-7t_2017087.nii
!    2582.0

dim_pos = 40
datatype_pos = 72
vox_offset_pos = 108
magic_pos = 344

open(newunit=io, file="wf-mp2rage-7t_2017087.nii", &
   form='unformatted',access='stream', &
   action="read", iostat=stat)

!! confirm we're reading data correctly
read(io) hdr_size
if (hdr_size /= 348) error stop "header size is not 348, wrong encoding?"

!! and that we can read into the file
call fseek(io, magic_pos, whence=0, status=stat)
read(io) magic_string
!if (trim(magic_string) /= "n+1") error stop "header is not n+1: '"// magic_string // "'"

call fseek(io, datatype_pos, whence=0, status=stat)
read(io) datatype_pos
if(debug) print *, "vox byte size: ", bitpix
!if (hdr_size /= 32) error stop "only setup to read floats"

call fseek(io, vox_offset_pos, whence=0, status=stat)
read(io) voxoffset
if(debug) print *, "start at: ", voxoffset


call fseek(io, dim_pos, whence=0, status=stat)
read(io) imgdim
! first element is number of dims > 1. ignore that
nvoxels = product(real(imgdim(2:)))
if(debug) print *, "image dim: ", imgdim(2:)
if(debug) print * ,"nvoxels: ", nvoxels

! reading as single dimenstion
! column order is different between c and fortran
! shape would probably be wrong?
allocate(data(int(nvoxels)))
call fseek(io, int(voxoffset), whence=0, status=stat)
read(io) data
if(debug) print * ,"data size: ", size(data)

! 50ms to generate close but incorrect (int64 overrun) value
!print *, sum(data)/nvoxels

! using stdlib_stats's "mean" also yields incorrect value
! in ~80ms. and makes binary 2.8M instead of 20K
!print *, mean(data)

! data cast 16 bit real to get correct mean
! but takes 400ms
print *, sum(real(data,16))/nvoxels

! 518 ms to correct answer via accumulating loop
! do  i = 1, int(nvoxels)
!  voxsum = voxsum + data(i)
! end do
! print *, voxsum/nvoxels

end program niimean
