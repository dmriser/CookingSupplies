//  Program to write helicity to  EVTCLASS in bos file
//  By Wes Gohn, 3.26.08

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include <ntypes.h>
#include <bostypes.h>
#include <clas_cern.h>
#include <utility.h>
#include <pid.h>

int test(ihel,ihel2){

  clasHEAD_t *HEAD = getBank(&bcs_, "HEAD");
  //clasEVNT_t *EVNT = getBank(&bcs_, "EVNT");

  int dummy;

  if(HEAD){
   
    //dummy = HEAD->head[0].evtclass;
    
    HEAD->head[0].evtclass = ihel;
    //HEAD->head[0].version  = ihel2;
    //printf("evt no: %d,", j);
    //printf("evtclass: %d \n",dummy);
    
    //}

  }

  return(0);

}
