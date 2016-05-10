#!/usr/bin/env perl
use strict;
use warnings;

my $remote = `pwd`;
chomp($remote);

chdir '../';
open(DIR, '< ./directories') or die "Could not open file 'directories' $!";
open(LOG, '>> ./refresh.txt') or die "Could not open file 'refresh.txt' $!";

# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach (<DIR>) {
    chomp;
    if (-e "$_/info") {
        chdir $_;
        my $jump = `pwd`;
        chomp($jump);
        if ($remote ne $jump) {
            system "cp $remote/configure ./configure";
        }else{
            print LOG "$jump 目录是源目录，跳过\n";
        }
        chdir '../';
    }else{
        print LOG "$_ 没有这个目录\n";
    }
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

