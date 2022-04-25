#!/bin/sh
#
repID=$1
echo "rep"$repID

/home/slim/SLiM/build/slim -d d_seed=${repID} -d d_Ncur=10000 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=2.2e-3 -d "d_repID='${repID}'" demo_sel_exon50_100kb_const_rates.slim



#
