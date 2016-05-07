#!/usr/bin/env perl
use strict;
use warnings;

# 删除之前可能存在的SAC文件和RESP文件
unlink glob "*.SAC";
unlink glob "RESP*";
unlink glob "??.????.*.[rtz]";
unlink "rdseed.err_log";

#打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n\n## $0";

# 解压seed文件
my @seed = glob "*.seed";
if (@seed == 1){# rdseed一次只能处理一个SEED文件
    system "rdseed -df @seed";
    }else{
    print LOG "\n#. seed文件个数不是1,脚本实际没有执行rdseed";
}
if (-e 'rdseed.err_log') {
    print LOG "\n rdseed有报错信息";
}
print LOG "\n$0正常结束";
close(LOG);