#!/usr/bin/env perl
use strict;
use warnings;

chdir '../';

open(DIR, '< ./directories') or die "Could not open file 'directories' $!";
open(LOG, '> ./time.md') or die "Could not open file 'go.txt' $!";
open(OUT, '> ./time.txt') or die "Could not open file 'time.txt' $!";
# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

foreach my $id (<DIR>) {
    chomp($id);
    if (-e "$id/info") {
        chdir "$id/process";
        print OUT "#. $id\n";
        foreach (glob("*.Z")) {
            my (undef, $t1, $t2, $t4) = split /\s+/, `saclst t1 t2 t4 f $_`;
            if ($t4 eq '-12345') {
                if (($t1 eq '-12345') and ($t2 eq '-12345')) {
                    print LOG "$id $_ t1:$t1 t2:$t2 t4:$t4\n";
                }else{
                    print OUT "$_ $t1 $t2\n";
                }
            }
        }
        chdir '../../';
    }else{
        print LOG "$id 没有这个目录\n";
    }
}
close(DIR);
close(OUT);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

