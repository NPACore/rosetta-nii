#!/usr/bin/env perl
use strict; use warnings; use feature qq/say/;
use File::Basename;
use lib dirname (__FILE__) . '/../patch';

# 20231023WF - init
#  benchmarking read speeds 

use PDL;
use Niftigz; #use PDL::IO::Nifti;
my $r = Niftigz->new()->read_nii("t/syn_roi.nii.gz");
my $x = Niftigz->new()->read_nii("t/syn1.nii.gz");
my $y = Niftigz->new()->read_nii("t/syn2.nii.gz");
my @rois = sort grep {$_!=0} uniq($r);
for my $roi (@rois) {
   my $i = $r==$roi;
   my $xs = $x[$i];
   my $ys = $y[$i];
   my $xm = mean($xs);
   my $ym = mean($ys);
   my $r = cor($xs,$ys);
}

