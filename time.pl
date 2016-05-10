#!/usr/bin/env perl
use strict;
use warnings;

chdir '../';

open(DIR, '< ./directories') or die "Could not open file 'directories' $!";
open(LOG, '>> ./go.txt') or die "Could not open file 'go.txt' $!";
open(OUT, '> ./time') or die "Could not open file 'time.txt' $!";
# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach (<DIR>) {
    chomp;
    if (-e "$_/chichi/err.ps") {
        chdir "$_/chichi";
        print OUT "#. $_\n";
        foreach (glob("????.z")) {
            my (undef, $t1) = split /\s+/;
            if ($t1 ne '-12345') {
                print OUT "$_ $t1\n";
            }
        }
        chdir '../../';
    }else{
        print LOG "$_ 没有这个目录\n";
    }
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

