/* Reads reads in helicity information from nt13 and writes to bos file, 
 *  replacing EVNTCLASS with helicity, -1 or 1 (or 0 if helicity undetermined)
 *
 * by Wes Gohn, April 2008
 * inputs: bos file and nt13 (nt13 only needed for delayed reporting)
 * output: bos file with included helicity info
 *
 */

#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include <ntypes.h>
#include <bostypes.h>
#include <makebanks.h>
#include <map_manager.h>
#include <math.h>
#include <clas_cern.h>
#include <sc.h>
#include <utility.h>
#include <pid.h>
#include <unistd.h>
#include <bosddl.h>
#include <trip.h>

#include <test.c>
#include <hel_wrapper.c>


int reset;
// declare the bos common
BOSbank bcs_;
BOSbank wcs_;

void ctrlCHandle(int);
void PrintUsage(char *processName);
int test();
int clean_up();

void hel_init_wrapper(int *runno);
int  hel_get_wrapper(int *evno, int *ihel);
void hel_close_wrapper();

char *outfile1 = NULL;

void PrintUsage(char *processName)
{
  fprintf(stdout, "    \n");
  fprintf(stdout, "   Adds helicity info to bos file");
  fprintf(stdout, "    \n");
  fprintf(stdout, "    \n");
  fprintf(stdout, "   Options:\n");
  fprintf(stdout, "\t-n[int#]\t Process only # of events\n");
  fprintf(stdout, "\t-b\t\t Batch mode\n");
  fprintf(stdout, "\t-p<outputfile1>\t Output File\n");
  fprintf(stdout, "\t-D\t\t Use direct reporting\n");
  fprintf(stdout, "\t-h\t\t Print this message. \n\n");
}

main(int argc,char **argv) {
  FILE *fp = NULL;
  int Nevents = 0;
  int evtno = 0;
  int oldevent = 0;
  int i, firsttime;
  int nwrite = 0, nwrite2 = 0, max = 0;
  int current_run = 0, runno;
  int batch_flag = 0;
  int ihel = 2;
  int ihel2= 2;
  int etype = 0;
  int firstev = 0;
  int count = 0;
  int direct = 0;
  int helvar = 0;
  int hel_save = 0;
  int idif1 = 0;
  int idif2 = 0;
  int helnew = 2;
  int helold = 2;
  int intt = 0;
  int intt_save = 0;
  float beam_energy = 0.0;
  char *argptr;
  char out1[1000],mess[1000];
  

  signal(SIGINT, ctrlCHandle);
  signal(SIGHUP, ctrlCHandle);

  for (i=1; i<argc; i++) {
    argptr = argv[i];
    if (*argptr == '-') {
      argptr++;
      switch (*argptr) {
      case 'h':
	PrintUsage(argv[0]);
	break;
      case 'n':
	max = atoi(++argptr);
	break;
      case 'b':
	batch_flag = 1;
	break;
      case 'D':
	direct = 1;
	break;
      case 'p':
        outfile1 =  *(++argptr) ? argptr : "/dev/fd/1";
        //if(!batch_flag) fprintf(stderr,"Output file 1: %s\n",outfile1);
        unlink(outfile1);
	sprintf(out1, "OPEN BOSOUTPUT1 UNIT=7 FILE=\"%s\" WRITE STATUS=NEW RECL=3600", outfile1);
	if (!fparm_c(out1)) {
	  fprintf(stderr,"%s: Unable to open file \'%s\': %s\n\n",argv[0],out1,strerror(errno));  
          exit(1);
	}
        break; 
      default:
	fprintf(stderr, "Unrecognized argument: [-%s]\n\n",argptr);
	PrintUsage(argv[0]);
	break;
      }
    }    
  }
 
  
  initbos();
  bankList(&bcs_,"T=","CCPBCL01DCPBECPBEVNTHEADHEVTMVRTPARTSCPBTBIDTGBITDPL");
  //  bankList(&bcs_,"T=","CC  CCPBCL01DC0 DCPBEC  EC1 ECPBECPCECPOEVNTFBPMHBLAHEADHEVTIC  ICPBICHBLCPBMVRTPARTSC  SCPBSCRCTBIDTBLATBTRTGBITRPBTDPL");


  for (i=1;i<argc; ++i) {
    argptr = argv[i];
    if (*argptr != '-'){
      sprintf(mess, "OPEN BOSINPUT UNIT=1 FILE=\"%s\" READ", argptr);
      if ( !fparm_c(mess)) {
	fprintf(stdout, "%s: Unable to open file \'%s\': %s\n\n",argv[0],argptr,strerror(errno));
      }
      else {
	
	while ((max ? Nevents < max : 1) && getBOS(&bcs_,1,"E")) {
	  
	  clasHEAD_t *HEAD = getBank(&bcs_, "HEAD");
	  clasEVNT_t *EVNT = getBank(&bcs_, "EVNT");
	  clasHEVT_t *HEVT = getBank(&bcs_, "HEVT");
	  clasTGBI_t *TGBI = getBank(&bcs_, "TGBI");
	  Nevents++;
	 
	  //ihel = 2;
	  if(HEAD && EVNT && HEVT && TGBI){
	    runno = HEAD->head[0].nrun;
	    evtno = HEAD->head[0].nevent;
	    etype = HEAD->head[0].type;
	    helvar= HEVT->hevt[0].trgprs;
	    intt  = TGBI->tgbi[0].interrupt_time;
	   
	    if(Nevents == 1) {
	      if(!direct) hel_init_wrapper(&runno);
	      count = evtno;
	      hel_save = helvar;
	      intt_save = intt;	     
	      if(direct){
		helold = 2;
		//ihel = 0;
		//if(helvar > 0) ihel = 1;
		//if(helvar = 0) ihel = 2;
	     
	      }
	    }
	    
	    if((Nevents % 100 == 0) && !batch_flag){
	      fprintf(stderr, "%d\r",Nevents);
	      fflush(stderr);
	    }
	   
	    if(etype >= 1 && etype <= 9){
	      idif1=abs(helvar-hel_save);
	      idif2=abs(intt-intt_save);
	      //fprintf(stdout, "idif2 = %d \n",idif2);

	      if(!direct){
		ihel=2;
		while(evtno >= count){
		  hel_get_wrapper(&count, &ihel);
		  count++;
		}
	      }
	      
	      if(direct){
		ihel=helold;
		ihel2=helold;

		helnew = 0;
		if(helvar>0) helnew = 1;
		if(helvar==0) helnew = 2;
	    
		if(idif1>1000){
		  ihel2 = helnew;
		  
		  if(idif2>2000){ 
		    ihel=helnew;
		    intt_save=intt;
		    //fprintf(stdout,"ihel flipped for evnto %d ,",evtno);
		    //fprintf(stdout,"ihel = %d \n",ihel);
		  }
		  else{
		    ihel=helold;
		  }
		  helold=helnew;
		}
	   
	      }
	      //intt_save = intt;
	      hel_save = helvar;
	      
	      /*The helicity ntuple stores ihel as (0,1)
		Convert from (0,1)->(-1,1)
	      */
	      if(ihel==0) ihel = -1;
	      if(ihel==2) ihel = 0;
	      if(ihel2==0) ihel2 = -1;
	      if(ihel2==2) ihel2 = 0;
	      
	      //test(ihel);
	      if(ihel==0 && !batch_flag){
		fprintf(stdout, "ihel = 0 for evt %d \n",evtno);
		//fprintf(stdout, " count = %d \n", count);
	      }
	      //putBOS(&bcs_,7,"T");
	      //dropAllBanks(&bcs_,"T");
	      //cleanBanks(&bcs_);
	     
	    }
	    else{
	      if(!batch_flag){
		fprintf(stdout, "Skipped hel_get for scaler event %d \n",evtno);
	      }
	    }
	  }
	  else{
	    ihel  = 0;
	    ihel2 = 0;
	  }
	  test(ihel, ihel2);
	
	  putBOS(&bcs_,7,"T");

	  dropAllBanks(&bcs_,"T");
	
	  cleanBanks(&bcs_);
	}
	  
	
	
	if(!direct) hel_close_wrapper();
	
	clean_up();
      } 
    }
  }
  if(!batch_flag) fprintf(stdout, "Helicity Program completed for %d events.\n",Nevents);
}

void ctrlCHandle(int x){
  signal(SIGINT,ctrlCHandle);
  signal(SIGHUP,ctrlCHandle);
  //fprintf(stdout,"\n\n\t\t\t*** EXITING, CLOSING FILES ***\n\n");
  clean_up();
  exit(1);
}


int clean_up(){
  char mess[100];
  if(outfile1){
    sprintf(mess, "CLOSE BOSOUTPUT UNIT=7");
    fparm_c(mess);
    //fprintf(stderr, "%s, err = %d\n", mess, fparm_c(mess));
  }
}	  

