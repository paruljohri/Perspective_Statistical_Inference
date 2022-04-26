#This is to make a bash file with the slim command line:
#python make_comman_file.py -scenarioNum -repNum -outFolder

import sys
import argparse


#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-scenarioNum', dest = 'scenarioNum', action='store', nargs = 1, type = int, help = 'simID')
parser.add_argument('-repNum', dest = 'repNum', action='store', nargs = 1, type = int, help = 'repID')
parser.add_argument('-outFolder', dest = 'outFolder', action='store', nargs = 1, type = str, help = 'output folder')
#read input parameters
args = parser.parse_args()
scenarioID =  args.scenarioNum[0]
repID =  args.repNum[0]
out_folder = args.outFolder[0]

#Read the parameter file:
f_par = open("/home/pjohri1/ModelRejection/eqm_pos_100kb_2000_mu_ben_inference_parameters.txt", 'r')
d_col = {}
for line in f_par:
    line1 = line.strip('\n')
    line2 = line1.split('\t')
    if line2[0] == "scenarioID":
        col = 0
        for x in line2:
            d_col[x] = col
            col += 1
    elif line2[0] == "scenario" + str(scenarioID):
        s_gamma = line2[d_col["gamma"]]
        s_f = line2[d_col["f2"]]
f_par.close()

#Write the bash script:
f_bash = open(out_folder + "/scenario" + str(scenarioID) + "_rep" + str(repID) + ".sh", 'w+')
f_bash.write("#!/bin/bash" + '\n')
f_bash.write("scenarioID=" + str(scenarioID) + '\n')
f_bash.write("repID=" + str(repID) + '\n')
f_bash.write("slim -d d_gamma=" + str(s_gamma) + " -d d_f=" + str(s_f) + " -d " + '"' + "d_repID='${repID}'" + '"' + " -d " + '"' + "d_folder='/scratch/pjohri1/ModelRejection/PosteriorChecks/eqm_pos_selection/scenario${scenarioID}'"+ '"' + " /home/pjohri1/ModelRejection/ABCScriptsPosSel/eqm_pos_exon50_100kb.slim" + '\n')






