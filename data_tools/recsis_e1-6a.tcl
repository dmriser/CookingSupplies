#source /group/clas/builds/PRODUCTION/packages/tcl/recsis_proc.tcl;
#source /group/clas/builds/test3/src/clas6-trunk/reconstruction/recsis/recsis_proc.tcl
source /u/home/clase1-6/clas6-trunk/reconstruction/recsis/recsis_proc.tcl
#
# define packages
turnoff ALL;
global_section off;
turnon seb trk cc tof egn user pid;
set trigger_particle_s 2212;
#
inputfile           InputFile;
setc chist_filename histfile;
setc log_file_name  logfile;
#
#
setc outbanknames(1) "CCPBCL01DCPBEC1 ECPBECPCECPOEVNTFBPMHEADHEVTLCPBMVRTPARTSCPBSCRCTBERTBIDTBTRTGBITRPBTDPLTBLA";
outputfile outfile1 PROC1 2047;
#
setc prlink_file_name "prlink_e16_tg4.bos" ; #for target at zero (-4cm)
setc bfield_file_name "bgrid_T67to33.fpk" 
#
set ntswitch 1;
#
set touch_id 0;
#
# Franz's tcl variables
set trk_maxiter       8;
set trk_minhits(1)    2;
set trk_lrambfit_chi2 50.;
set trk_tbtfit_chi2   70.;
set trk_prfit_chi2    70.;
set trk_statistics    3 ;
#
# New tracking:
# set trk_fitRegion   7;
#
#set dc_xvst_choice 0;
#
# Some of these are commented out to filter warning messages
#
#set ltime_do       -1;
set lseb_nt_do      -1;
set lall_nt_do      -1;
set lseb_hist       -1;
set lseb_h_do       -1;
set lmon_hist       -1;
set ltrk_h_do       -1;
set legn_h_do       -1;
set ltof_h_do       -1;
set lec1_h_do       -1;                                                              
set lfec_hist       -1;
set l_nt_do         -1;
#set lscr_nt_do      -1;
#set ltbt_nt_do      -1;
#set lpart_nt_do     -1;
set lmvrt_nt_do     -1;
set lpid_make_trks   0;
set ltbid_nost_do   -1;
#set lmysql          -1;
#set nmysql          -1;
#
#
# tell FPACK not to stop if it thinks you are running out of time
fpack "timestop -9999999999"
#
# do not send events to event display
set lscat $false;
set ldisplay_all $false;
#set nevt_to_skip  44000;
#
#
setc rec_prompt "CLASCHEF_recsis> ";
