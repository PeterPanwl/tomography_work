#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(min max);

#打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n\n## $0";

# 利用hash的key的不可重复性构建集合:
#   hash的key定义为 NET.STA.LOC.CH (分量信息不是BHZ而是BH)
#   hash的value是文件名与key匹配的SAC文件数目，正常情况下是3的整数倍
my %sets;
foreach (glob "*.SAC") {
    my ($net, $sta, $loc, $chn) = split /\./;
    my $chn2 = substr $chn, 0, 2;
    $sets{"$net.$sta.$loc.$chn2"}++;
}


# 对所有的key做循环
foreach my $key (keys %sets) {

    my ($E, $N, $Z, $R, $T, $Z0);

    # 检查三个分量是否都存在,任一分量若不存在，则跳过
    $Z = "${key}Z.SAC";
    $E = "${key}E.SAC";
    $N = "${key}N.SAC";
    if (!-e $Z) {
        print LOG "\n#. $key 缺失Z分量";
    }
    if (!-e $E) {
        print LOG "\n#. $key 缺失E分量";
    }
    if (!-e $N) {
        print LOG "\n#. $key 缺失N分量";
    }
    if ((!-e $Z) or (!-e $E) or (!-e $N)){
        next;
    }

    # 假定kzdate和kztime相同
    # 检查B, E, DELTA
    my (undef, $Zb, $Ze, $Zdelta) = split " ", `saclst b e delta f $Z`;
    my (undef, $Eb, $Ee, $Edelta) = split " ", `saclst b e delta f $E`;
    my (undef, $Nb, $Ne, $Ndelta) = split " ", `saclst b e delta f $N`;
    if (($Zdelta != $Edelta) or ($Zdelta != $Ndelta)) {
        print LOG "\n#. $key: delta not equal N:$Ndelta E:$Edelta Z:$Zdelta";
        die "$key: delta not equal\n";
    }
    # 获取三分量里的最大B和最小E值作为数据窗
    my $begin = max($Zb, $Eb, $Nb) + $Zdelta;
    my $end = min($Ze, $Ee, $Ne) - $Zdelta;

    # 输出文件名为 NET.STA.LOC.[RTZ]
    my $prefix = substr $key, 0, length($key)-2;
    $R = $prefix."R";
    $T = $prefix."T";
    $Z0 = $prefix."Z";
    open(SAC, "|sac") or die "Error in opening sac\n";
    print SAC "cut $begin $end \n";
    print SAC "r $E $N \n";
    print SAC "rotate to gcp \n";
    print SAC "w $R $T \n";
    print SAC "r $Z \n";
    print SAC "w $Z0 \n";
    print SAC "q\n";
    close(SAC);
    
    unlink glob "$key?.SAC";
}

print LOG "\n$0正常结束"; 
close(LOG);