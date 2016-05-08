#!/usr/bin/env perl
use strict;
use warnings;
# 把本目录master分支推送到directories中的其他目录的master分支

my $order;
if (@ARGV == 1) {
    ($order) = @ARGV;
    if ($order eq '-f') {
        die "wrong option, only -f or --force\n";
    }
}elsif (@ARGV > 1) {
    die "only support one option\n";
}

#获取本目录地址以便跳过
my ($pwd) = `pwd`;
chomp($pwd);
my (@address) = split /\//, $pwd;
my $jump;
foreach (@address) {
    $jump = $_;
};
# 打开日志文件
open(DIR, '< ../directories') or die "Could not open file 'directories' $!";
open(LOG, '>> ../push.txt') or die "Could not open file 'push.txt' $!";
# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach (<DIR>) {
    chomp;
    if ($jump eq $_) {
        print LOG "$_ 目录跳过\n";
        next;
    }
    my $remote = "../$_";
    if (-e "$remote/info") {
        system "git remote add temprepo $remote";
        if (defined($order)) {
            system "git push $order $remote master:master";
        }else{
            system "git push $remote master:master";
        }
        system "git remote remove temprepo";
    }else{
        print LOG "$_ 没有这个目录\n";
    }
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

