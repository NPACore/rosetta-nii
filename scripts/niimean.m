#!/usr/bin/env octave
% as of 20231023 -- readnifti is still not yet in the image forge package
% https://savannah.gnu.org/patch/?9853
%   pkg install image -forge
%   pkg load image
%   x = niftiread('...');
%instead, using spm12
% cd spm12/src && make PLATFORM=octave install
addpath('~/Downloads/spm12')
x =  spm_vol('wf-mp2rage-7t_2017087.nii.gz');
fprintf('%.5f\n', mean(x.dat,'all'))
