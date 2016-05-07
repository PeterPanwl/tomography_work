#!/usr/bin/env perl
use strict;
use warnings;

@ARGV == 1 or die "Usage: perl $0 branch name\n";

my ($branch) = @ARGV;
my $remote = `pwd`;
chomp($remote);

chdir '../';
open(DIR, '< ./directories') or die "Could not open file 'directories' $!";
open(LOG, '>> ./push.txt') or die "Could not open file 'push.txt' $!";

# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach (<DIR>) {
    chomp;
    if (-e "$_/info") {
        chdir $_;
        system "git remote add temprepo $remote";
        system "git pull $remote $branch";
        system "git remote remove temprepo";
        chdir '../';
    }else{
        print LOG "$_ 没有这个目录\n";
    }
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

