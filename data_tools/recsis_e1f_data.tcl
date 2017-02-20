# original source /u/group/clas/builds/release-4-14/packages/tcl/recsis_proc.tcl;
# new one:
#source /group/clas/builds/test3/src/clas6-trunk/reconstruction/recsis/recsis_proc.tcl;
# newer one:
source /u/home/clase1-6/clas-trunk/reconstruction/recsis/recsis_proc.tcl;
# source /group/clas/builds/src/clas-trunk/reconstruction/recsis/recsis_proc.tcl;
#source /opt/programs/clas/builds/PRODUCTION/packages/tcl/recsis_proc.tcl;
#
# define packages
turnoff ALL;
global_section off;
turnon seb trk cc tof egn user pid;
#turnon user;
#

inputfile raw.bos;
setc chist_filename histfile;
setc log_file_name  logfile;
#
# Banks from Mauri 
setc outbanknames(1) "CCPBCL01DCPBEC1 ECPBECPCECPOEVNTFBPMHEADHEVTLCPBMVRTPARTSCPBSCRCTBERTBIDTBTRTGBITRPBTDPLTBLA";
#setc outbanknames(1) "CC  CCPBCL01DC0 DCPBEC  EC1 ECPBECPCECPOEVNTFBPMHBLAHEADHEVTIC  ICPBICHBLCPBMVRTPARTSC  SCPBSCRCTBIDTBLATBTRTGBITRPBTDPL"; 
#setc outbanknames(2) "CCPBCL01DCPBEC1 ECPBECPCECPOEVNTFBPMHEADHEVTICPBICHBLCPBMVRTPARTSCPBSCRCTBIDTBTRTGBITRPBTDPL"; 
#setc outbanknames(3) "CCPBCL01DCPBEC1 ECPBECPCECPOEVNTFBPMHEADHEVTICPBICHBLCPBMVRTPARTSCPBSCRCTBIDTBTRTGBITRPBTDPL"; 
outputfile cooked.bos PROC1 2047;
#outputfile outfile2 PROC2 2047;
#outputfile outfile3 PROC3 2047;
#
#
setc prlink_file_name  "prlink_e1f.bos";
setc bfield_file_name  "bgrid_T67to33.fpk";
#
setc poltarget_field_file_name "bgrid_s.fpk";
#
set trigger_particle 11
set ntswitch 1;
set touch_id 0;

set torus_current       2250;
set mini_torus_current  6000;
set TargetPos(3)       -25.0;
#
set ntswitch 1;

set dc_xvst_choice     0;

#
#set touch_id 0;
#set touch_id 1;  

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
#
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
#set lpart_nt_do     -1; # may need to be turned on
set lmvrt_nt_do     -1;
set lpid_make_trks   0;
set ltbid_nost_do   -1;
#set lmysql          -1;
#set nmysql          -1;
#set lmctk_nt_do -1; # from Harut
#
#
# tell FPACK not to stop if it thinks you are running out of time
fpack "timestop -9999999999"
#
#
# do not send events to event display
set lscat $false;
set ldisplay_all $false;
#set nevt_to_skip  44000;
#
#
setc rec_prompt "CLASCHEF_recsis> ";

#go 20000000;
go 20000;
status;
exit_pend;
