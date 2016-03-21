#!/usr/bin/perl 

use strict;
use warnings;

# 1 = ON
my $debug = 0;

############################
# user specific parameters
my $outdir    = "/volatile/clas/clas12/dmriser/analysis/ef1_analysis/rec_out";
my $nt10out   = "$outdir/nt10";
my $nt22out   = "$outdir/nt22";
my $rootout   = "$outdir/root";
my $cookdir   = "/u/home/dmriser/mydoc/cooking_supplies";
my $pathtohel = "/volatile/clas/clas12/dmriser/analysis/ef1_analysis/helfiles"; 
my $datadir   = "/mss/clas/e1f/data";
############################
# end user params

############################
# farm specific parameters
my $project = "E1F";
my $jobname = "recook";
my $track   = "reconstruction";
my $opsys   = "centos65";
my $memory  = "4000 MB";
my $space   = "4000 MB";
my $tlimit  = "400";
############################
# end farm params

# check for input name of file.txt that contains data files to be run
if(not defined @ARGV) {die "> usage: $0 <list of files to be run>";}


# open up the file, and put file names into file array
my $filename = $ARGV[0];
open(my $fh,"<:encoding(UTF-8)",$filename) or die "> could not open file!";
chomp(my @files = <$fh>);

# last file for delayed reporting, all bigger will be direct
my $threshold = 38217;

foreach my $file (@files){
    my @line  = split(m[(?:clas_0|.A)+], $file);
    my $runno = $line[1];
    my $run   = "$line[1].A$line[2]";
    my $del   = 0;
    my $rep   =  "nothing";

    open(my $outfile,'>',"temp.$run.jsub");

    if($runno <= $threshold){
	$del = 1;
	$rep = "delayed"
    }
    else{
	$del = 0;
	$rep = "direct";
    }
    
    # we are going to start authoring jsub files
    print $outfile "JOBNAME: $jobname \n";
    print $outfile "TRACK: $track \n";
    print $outfile "PROJECT: $project \n";
    print $outfile "OS: $opsys \n";
    print $outfile "MEMORY: $memory \n";
    print $outfile "DISK_SPACE: $space \n";
    print $outfile "TIME: $tlimit \n";
    print $outfile "COMMAND: chmod +x cookbos.run; ./cookbos.run clas_0$run \n";
    print $outfile "OTHER_FILES: \n";
    print $outfile "$cookdir/cookbos.run \n";
    print $outfile "$cookdir/recsis_e1f_data.tcl \n";

    # for files with a delay, we need to provide the corresponding .rzn file
    if($del){
    print $outfile "$pathtohel/hel$runno.rzn \n";
    }

    print $outfile "OUTPUT_DATA:out.bos \n";
    print $outfile "OUTPUT_TEMPLATE:$outdir/helfix.*.bos \n\n";
    print $outfile "INPUT_DATA:datafile.bos \n\n";
    print $outfile "INPUT_FILES: \n";
    print $outfile "$datadir/clas_0$run \n";
    
    close $outfile;
    
    
    if($debug){system("cat temp.$run.jsub");}
    else{system("jsub temp.$run.jsub");}

}

close $fh;

# tidy up
system("rm temp.*.jsub");
