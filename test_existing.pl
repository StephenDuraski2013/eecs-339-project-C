#!/usr/bin/perl -w

$#ARGV==1 or die "usage: test.pl maxerrs test_input_file \n";

$diskstem="__test";
$numblocks=1024;
$blocksize=1024;
$heads=1;
$blockspertrack=1024;
$tracks=1;
$avgseek=10;
$trackseek=1;
$rotlat=10;
$cachesize=64;
($maxerrs,$input_file)=@ARGV;

($t, $pid) = (split /\./, $input_file)[1,2];

$ENV{PATH}.=":.";

$refcmd = "ref_impl.pl nodebug 0";
$testcmd = "sim $diskstem $cachesize";

system "deletedisk $diskstem";
system "makedisk $diskstem $numblocks $blocksize $heads $blockspertrack $tracks $avgseek $trackseek $rotlat";
system "$refcmd < TEST.$t.$pid.input > TEST.$t.$pid.refout";

system "$testcmd < TEST.$t.$pid.input > TEST.$t.$pid.yourout";

system "compare.pl TEST.$t.$pid.input TEST.$t.$pid.refout TEST.$t.$pid.yourout $maxerrs";


