#!/usr/bin/env perl
use strict;
use warnings;
use POSIX qw(strftime);
use List::Util qw(min max);

@ARGV == 5 or die "Usage: perl $0 yyyy-mm-ddThh:mm:ss.xxx evla evlo evdp mag\n";
my ($origin, $evla, $evlo, $evdp, $mag) = @ARGV;

#打开日志文件
open(LOG, '>> ../process.md') or die "Could not open file 'process.md' $!";
print LOG "\n\n## $0";

# 对发震时刻做解析
my ($date, $time) = split "T", $origin;
my ($year, $month, $day) = split "-", $date;
my ($hour, $minute, $second) = split ":", $time;
# 秒和毫秒均为整数
my ($sec, $msec) = split /\./, $second;
$msec = int(($second - $sec) * 1000 + 0.5);

# 计算发震日期是一年中的第几天
my $jday = strftime("%j", $second, $minute, $hour, $day, $month-1, $year-1900);

# 同步所有文件的参考时刻
open(SAC, "| sac") or die "Error in opening SAC\n";
print SAC "wild echo off\n";
print SAC "r *.SAC\n";
print SAC "synchronize\n";
print SAC "ch o gmt $year $jday $hour $minute $sec $msec\n";
print SAC "ch allt (0 - &1,o&) iztype IO\n";
print SAC "ch evlo $evlo evla $evla evdp $evdp mag $mag\n";
print SAC "wh\n";
print SAC "q\n";
close(SAC);
# 标记直达纵波到时
foreach (glob("*.SAC")) {
    chomp;
    my (undef, $stla, $stlo) = split /\s+/, `saclst stla stlo f $_`;
    my $taup = "taup_time -mod prem -P,p -h $evdp -sta $stla $stlo -evt $evla $evlo";
    my ($time1, $time2) = split /\s+/, `$taup`;
    my $time;
    if (defined($time1) and defined($time2)) {
        $time = min($time1, $time2);
    } elsif(defined($time1)) {
        $time = $time1;
    } elsif(defined($time2)) {
        $time = $time2;
    }
    if (defined($time)) {
        open(SAC, "| sac") or die "Error in opening SAC\n";
        print SAC "wild echo off\n";
        print SAC "r $_\n";
        print SAC "ch t8 $time\n";
        print SAC "wh\n";
        print SAC "q\n";
        close(SAC);
    }else{
        print LOG "$_ 标记理论到时时: $taup 没有返回有效结果\n";
    }
}
# 标记直达横波到时
oreach (glob("*.SAC")) {
    chomp;
    my (undef, $stla, $stlo) = split /\s+/, `saclst stla stlo f $_`;
    my $taup = "taup_time -mod prem -S,s -h $evdp -sta $stla $stlo -evt $evla $evlo";
    my ($time1, $time2) = split /\s+/, `$taup`;
    my $time;
    if (defined($time1) and defined($time2)) {
        $time = min($time1, $time2);
    } elsif(defined($time1)) {
        $time = $time1;
    } elsif(defined($time2)) {
        $time = $time2;
    }
    if (defined($time)) {
        open(SAC, "| sac") or die "Error in opening SAC\n";
        print SAC "wild echo off\n";
        print SAC "r $_\n";
        print SAC "ch t8 $time\n";
        print SAC "wh\n";
        print SAC "q\n";
        close(SAC);
    }else{
        print LOG "$_ 标记理论到时时: $taup 没有返回有效结果\n";
    }
}

print LOG "\n$0正常结束"; 
close(LOG);
