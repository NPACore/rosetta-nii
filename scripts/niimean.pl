#!/usr/bin/env perl
use strict; use warnings; use feature qq/say/;
use File::Basename;
use lib dirname (__FILE__) . '/../patch';

# 20231023WF - init
#  benchmarking read speeds 

use PDL;
#use PDL::IO::Nifti;
use Niftigz;
my $fname = "wf-mp2rage-7t_2017087.nii.gz";
my $img = Niftigz->new()->read_nii($fname);
say(sum($img)/nelem($img));
# cannot seek backwards

#my $fname2 = "tmp.nii";
#my $img2 = Niftigz->new()->read_nii($fname2);
#say(sum($img2)/nelem($img2));
