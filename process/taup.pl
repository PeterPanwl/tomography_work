#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(min max);

# 打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n## $0\n";

# 获取台站列表
#利用hash的key的不可重复性构建集合:
#   hash的key定义为 $net.$sta
my %station;
foreach (glob "*.SAC") {
    my ($net, $sta) = split /\./;
    my (undef, $stla, $stlo, $evla, $evlo, $evdp) = split /\s+/, `saclst stla stlo evla evlo evdp f $_`;
    $station{"$net.$sta"} = "-sta $stla $stlo -evt $evla $evlo -h $evdp --time";
}

# 标记直达纵波到时
open(SAC, "| sac") or die "Error in opening SAC\n";
print SAC "wild echo off\n";
foreach my $key (keys %station) {
    my ($p, $s, $pn);
    my $taup;
    # 要考察的震相是P p Pn S s
    my %phase = (
            P => undef,
            p => undef,
           Pn => undef,
            S => undef,
            s => undef,
    );
    # 计算震相
    foreach (keys %phase) {
        $taup = "taup_time -mod prem -ph $_ $station{$key}";
        ($phase{$_}) = split /\s+/, `$taup`;
        if ("A$phase{$_}" eq 'A') {
            $phase{$_} = 0;
        }
    }
    # 直达纵波到时
    if (($phase{P} != 0) and ($phase{p} != 0)) {
        $p = min($phase{P}, $phase{p});
    }elsif ($phase{P} != 0) {
        $p = $phase{P};
    }elsif ($phase{p} != 0) {
        $p = $phase{p};
    }else{
        print LOG "$key 标记理论P p到时时: $taup 没有返回有效结果\n";
    }
    # 直达横波到时
    if (($phase{S} != 0) and ($phase{s} != 0)) {
        $s = min($phase{S}, $phase{s});
    }elsif ($phase{S} != 0) {
        $s = $phase{S};
    }elsif ($phase{s} != 0) {
        $s = $phase{s};
    }else{
        print LOG "$key 标记理论S s到时时: $taup 没有返回有效结果\n";
    }
    # 首波到时
    if ($phase{Pn} != 0) {
        $pn = $phase{Pn};
    }
    # 执行标记
    print SAC "r $key.*.SAC\n";
    if (defined($pn)) {
        print SAC "ch t7 $pn\n";
        print SAC "wh\n";
    }
    if (defined($p)) {
        print SAC "ch t8 $p\n";
        print SAC "wh\n";
    }
    if (defined($s)) {
        print SAC "ch t9 $s\n";
        print SAC "wh\n";
    }
    
}
print SAC "q\n";
close(SAC);

print LOG "$0正常结束\n"; 
close(LOG);
