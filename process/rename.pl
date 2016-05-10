#!/usr/bin/env perl
use strict;
use warnings;

#打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n## $0\n";

foreach my $file (glob "*.SAC") {
    my ($year, $jday, $hour, $min, $sec, $msec,
    $net, $sta, $loc, $chn, $q, $suffix) = split /\./, $file;
    rename $file, "$net.$sta.$loc.$chn.SAC";
}

print LOG "$0正常结束\n"; 
close(LOG);
