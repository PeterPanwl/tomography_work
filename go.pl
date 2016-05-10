#!/usr/bin/env perl
use strict;
use warnings;

chdir '../';

open(DIR, '< ./directories') or die "Could not open file 'directories' $!";
open(LOG, '>> ./go.txt') or die "Could not open file 'go.txt' $!";

# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach (<DIR>) {
    chomp;
    if (-e "$_/process/process.pl") {
        chdir "$_/process";
        system "perl process.pl";
        chdir '../../';
    }else{
        print LOG "$_ 没有这个目录\n";
    }
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

