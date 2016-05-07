#!/usr/bin/env perl
use strict;
use warnings;

my $catlogfile = 'Table1_complete.txt';


chdir '../';
open(DIR, "> ./directories") or die "Could not open file 'directories' $!";
open(LOG, "> ./build.txt") or die "Could not open file 'build.txt' $!";
# 运行时间写入日志文件
my ($date) = `date`;
print LOG $date;

open (IN,"< $catlogfile") or die "$!\n";
foreach (<IN>) {
    # 收集信息
    my (@info) = split /\s+/;
    my ($id, $jtime, $evla, $evlo, $jevdp, $jmag) = ($info[0], $info[1], $info[2], $info[3], $info[4], $info[11]);
    #36 99/09/20/02:35:02.0 23.42 120.62 18±4 -3.85 -44.63 59.79 -13.54 -18.38 30.52 3.81±0.19 327±9 35±5 59±7 0.542 34.28 C3
    # 整理事件信息
    my ($year, $month, $day, $time) = split /\//, $jtime;
    if ($year eq '99') {
        $year = '1999';
    }elsif ($year eq '00') {
        $year = '2000';
    }
    my ($hour, $minute) = split /:/, $time;
    my ($evdp) = split /±/, $jevdp;
    my ($mag) = split /±/, $jmag;
    my $seed = "$year$month$day$hour$minute.seed";
    #199909200235.seed
    my $eventinfo = "$year-$month-${day}T$time $evla $evlo $evdp $mag";
    #yyyy-mm-ddThh:mm:ss.xxx evla evlo evdp mag
    # 复制文件、输出事件信息
    if (-e $seed) {
        system "cp -r ./JGR_work ./$id";
        system "mv $seed ./$id/process";
        open (OUT, "> ./$id/info");
        print OUT "$eventinfo\n";
        close(OUT);
        print DIR "$id\n";
    }else{
        print LOG "事件 $id 没有找到对应的seed文件： $seed\n";
    }
}
foreach (glob("*.seed")) {
    print LOG "文件 $_ 在地震目录中没有对应的事件记录\n";
}
close(DIR);

print LOG "$0 正常结束\n";
# 关闭日志文件
close(LOG);

