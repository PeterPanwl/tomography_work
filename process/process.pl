#!/usr/bin/env perl
use strict;
use warnings;

open(LOG, "> ../process.md") or die "Could not open file 'process.md' $!";
# 运行时间写入日志文件
my ($date) = `date`;
print LOG "$date";
# 关闭日志文件
close(LOG);

system "perl rdseed.pl";
system "perl merge.pl";
system "perl rename.pl";
open (INFO,'../info');
foreach (<INFO>) {
    chomp;
    #yyyy-mm-ddThh:mm:ss.xxx evlo evla evdp mag
    system "perl eventinfo.pl $_";
    last;
}
close(INFO);
system "perl taup.pl";
system "perl wave.pl";
system "perl rotate.pl";

open(LOG, "< ../process.md") or die "Could not open file 'process.md' $!";
foreach (<LOG>) {
    print $_;
}
close(LOG);