#!/usr/local/bin/perl
#
chdir("/group/uva/kjoo/packages/nt10maker_e1b/");
open(IN,"< e1brun.list") ||
	die "cannot open e1brun.list\n";
#
while(<IN>) {
    $infile = $_;
	if ($infile =~ /\n$/) {
       chop($infile);
	}
#
	$ENV{"IN"} = $infile;
    $mybin = $ENV{"mybin"};

#
    $runno = substr($infile,3,5);
	$suffix = substr($infile,17,5);

    $outfile = "r$runno.rzn.$suffix";
	$silodir = "/work/clas/disk1/hovanes/e1b/";
	$workdir = "/work/clas/disk1/kjoo/e1b/";
    $cmd = "$mybin/nt10maker_e1b -M1000000 -t1 -o$workdir/$outfile $silodir/$infile";
    print  "cmd: $cmd\n";
    system $cmd;
}
close(IN)  ||
	die "cannot close e1brun.list\n";

