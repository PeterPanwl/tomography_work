#!/usr/bin/env perl
use strict;
use warnings;

#打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n\n## $0";

if (-e '../configure') {
    open(INFO, '< ../configure');
    my @sacorder;
    my $i = 1;
    foreach (<INFO>) {
        chomp;
        my ($a, $b) = split ':';
        if ($a eq 'WAVE') {
            push @sacorder, $b;
            $i = 0;
        }
    }

    if ($i == 0) {
        open(SAC, "| sac") or die "Error in opening SAC\n";
        print SAC "wild echo off\n";
        print SAC "r *.SAC\n";
        foreach (@sacorder) {
            print SAC "$_\n";
            print LOG "$_\n";
        }
        print SAC "w over\n";
        print SAC "q\n";
        close(SAC);
    }
}else{
    print LOG "没有配置文件\n";
}

print LOG "\n$0正常结束"; 
close(LOG);
