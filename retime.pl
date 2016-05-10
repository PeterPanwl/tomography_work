#!/usr/bin/env perl
use strict;
use warnings;

chdir '../';
my $dir = `pwd`;
chomp($dir);

open(TIME, '< ./time') or die "Could not open file 'time' $!";

foreach (<TIME>) {
    chomp;
    my ($index, $num) = split /\s+/;
    if ($index eq '#.') {
        chdir "$dir/$num/process" or die "$dir/$num/process";
    }else{
        my ($file) =split /\./, $index;
        open(SAC, "| sac") or die "Error in opening SAC\n";
        print SAC "wild echo off\n";
        print SAC "r *$file*\n";
        print SAC "ch t1 $num\n";
        print SAC "wh\n";
        print SAC "q\n";
        close(SAC);
    }
}
close(DIR);