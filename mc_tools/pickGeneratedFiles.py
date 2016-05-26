#!/usr/bin/env python 

import glob

all_gen = glob.glob('/volatile/clas/clas12/dmriser/analysis/mcdata/generated/elastic/f1*')
first   = 0
last    = 2000


for gen in all_gen:
    
    stub = gen.split('.')[1].split('.')[0]
    
    if (int(stub) <= last and int(stub) >= first):
        print gen
    
