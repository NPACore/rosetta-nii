#!/usr/bin/env perl
# adapted from Makefile
#CPU := $(shell perl -lne 'print $$1=~s/[-()\s]/_/gr and exit if m/model.name.*: (.*)/' < /proc/cpuinfo)-$(shell hostname)
use strict;
open my $fh, '<', '/proc/cpuinfo';
while(<$fh>){
    print($1=~s/[-()\s]/_/gr,"-",`hostname`) and exit if m/model.name.*: (.*)/;
}
