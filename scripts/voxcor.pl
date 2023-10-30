#!/usr/bin/env perl
use strict; use warnings; use feature qq/say/;
use File::Basename;
use lib dirname (__FILE__) . '/../patch';

# 20231023WF - init
#  benchmarking read speeds 

use PDL;
use Niftigz; #use PDL::IO::Nifti;
use PDL::Stats::Basic; # corr

my $r = Niftigz->new()->read_nii("t/syn_roi.nii.gz");
my $x = Niftigz->new()->read_nii("t/syn1.nii.gz");
my $y = Niftigz->new()->read_nii("t/syn2.nii.gz");
my @rois = sort grep {$_!=0} list uniq($r);
for my $roi (@rois) {
   my $i = $r==$roi;
   my $xs = $x->where($i)->sever;
   my $ys = $y->where($i)->sever;
   my $n = $xs->nelem();
   my $xm = $xs->sum()/$n;
   my $ym = $ys->sum()/$n;
   my $cor = $n>3?$xs->corr($ys):"NA";
   print join("\t",$roi,$n, $xm,$ym,$cor),"\n";
}

