#This is to make a bash file with the slim command line:
#python make_comman_file_gro.py -simNum -repNum -outFolder

import sys
import argparse


#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-simNum', dest = 'simNum', action='store', nargs = 1, type = int, help = 'simID')
parser.add_argument('-repNum', dest = 'repNum', action='store', nargs = 1, type = int, help = 'repID')
parser.add_argument('-outFolder', dest = 'outFolder', action='store', nargs = 1, type = str, help = 'output folder')
#read input parameters
args = parser.parse_args()
simID =  args.simNum[0]
repID =  args.repNum[0]
out_folder = args.outFolder[0]

#Read the parameter file:
f_par = open("/home/pjohri/ModelRejection/ABCScripts/generate_sampling_scheme_pos_selection.py", 'r')
d_col = {}
for line in f_par:
    line1 = line.strip('\n')
    line2 = line1.split('\t')
    if line2[0] == "simID":
        col = 0
        for x in line2:
            d_col[x] = col
            col += 1
    elif line2[0] == "sim" + str(simID):
        s_gamma = line2[d_col["gamma"]]
        s_f = line2[d_col["f"]]
f_par.close()

#Write the bash script:
f_bash = open(out_folder + "/sim" + str(simID) + "rep" + str(repID) + ".sh", 'w+')
f_bash.write("#!/bin/bash" + '\n')
f_bash.write("simID=" + str(simID) + '\n')
f_bash.write("repID=" + str(repID) + '\n')
f_bash.write("/mnt/storage/software/slim.3.1/build/slim -d d_gamma=" + str(s_gamma) + " -d d_f=" + str(s_f) + " -d " + '"' + "d_repID='${repID}'" + '"' + " -d " + '"' + "d_folder='/home/pjohri/ModelRejection/ABCSims/eqm_100kb_pos_selection/sim${simID}'"+ '"' + " /home/pjohri/ModelRejection/ABCScripts/eqm_pos_exon50_100kb.slim" + '\n')






