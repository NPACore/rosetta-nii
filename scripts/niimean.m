#!/usr/bin/env octave
% as of 20231023 -- readnifti is still not yet in the image forge package
% https://savannah.gnu.org/patch/?9853
%   pkg install image -forge
%   pkg load image
%   x = niftiread('...');
%instead, using spm12
% cd spm12/src && make PLATFORM=octave instal
addpath('~/Downloads/spm12')
x =  spm_vol('/home/foranw/mybrain/mybrain_2017-08_7t.nii.gz');
disp(mean(x.dat,'all'))
