#!/usr/bin/env perl
use strict; use warnings; use feature qq/say/;
use File::Basename;
use lib dirname (__FILE__) . '/../patch';

#  benchmarking read speeds 
# 20231023WF - init
# 20231119WF - cast to double for correct sum

use PDL;
#use PDL::IO::Nifti;
use Niftigz;
my $fname = "wf-mp2rage-7t_2017087.nii.gz";
my $img = Niftigz->new()->read_nii($fname);
#say sum($img)/nelem($img); # 2.73 seconds
# native 836.149108886719
# /1000  835.949645996094
# double 838.206399337706
# want   838.20*
say sum(double $img)/nelem($img); # 3.07 seconds
