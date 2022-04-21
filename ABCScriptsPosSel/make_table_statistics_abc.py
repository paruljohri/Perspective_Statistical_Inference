#This is to make the final table with all statistics for conducting ABC:

import sys
import os
import numpy as np

num_sims = 290
win_size = 2000 #2000 or 5000 or 10000
tot_coding_sites=300*5*33 #exon length * num of exons per gene * num of genes
l_stats = ["S", "thetapi", "thetaw", "thetah", "hprime", "tajimasd", "numSing", "hapdiv", "rsq", "D", "Dprime", "divergence", "lambda", "rate_ben", "rate_neu"]

def meanOfList(l_values):
    l_values_new = []
    for x in l_values:
        if x!="NA" and x!="nan" and x!="":
            l_values_new.append(float(x))
    if len(l_values_new) == 0:
        return ("NA")
    else:
        return("{:.8f}".format(np.mean(l_values_new)))

def sdOfList(l_values):
    l_values_new = []
    for x in l_values:
        if x!="NA" and x!="nan" and x!="":
            l_values_new.append(float(x))
    if len(l_values_new) == 0:
        return ("NA")
    else:
        return("{:.8f}".format(np.std(l_values_new)))

def get_mean_within_reps(d_STATS):
    d_mean_STATS = {}
    l_reps = []
    for x in d_STATS["filename"]:
        if x not in l_reps:
            l_reps.append(x)
    for stat in l_stats[0:len(l_stats)]:
        if stat!="divergence" and stat!="lambda" and stat!="rate_ben" and stat!="rate_neu":#these stats are calcualted for the whole chromosome
            d_mean_STATS[stat] = []
            for s_rep in l_reps:
                #print(d_STATS[stat][s_rep])
                d_mean_STATS[stat].append(meanOfList(d_STATS[stat][s_rep]))
    #Divide by length of window for some stats:
    for stat in l_stats:
        if stat == "thetapi" or stat == "thetaw" or stat=="thetah" or stat=="numSing":
            l_normalized = []
            for x in d_mean_STATS[stat]:
                l_normalized.append(float(x)/float(win_size))
            d_mean_STATS[stat] = l_normalized
    return (d_mean_STATS)

#read parameters:
f_par = open("/home/pjohri1/ModelRejection/ABCScriptsPosSel/eqm_pos_100kb_logunif_parameters.txt", 'r')
d_par = {}
for line in f_par:
    line1 = line.strip('\n')
    line2 = line1.split('\t')
    d_par[line2[0]] = line2[1] + '\t' + line2[2]
f_par.close()

#Result:
result = open("/home/pjohri1/ModelRejection/eqm_pos_100kb_" + str(win_size) + ".stats", 'w+')
result.write("simID" + '\t' + d_par["simID"])
for x in l_stats:
    result.write('\t' + x + "_mean" + '\t' + x + "_sd")
result.write('\n')

#Read the stats:
simID = 1
while simID <= num_sims:
    print ("simulation ID: " + str(simID))
    try:
        if os.stat("/scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats/sim" + str(simID) + "_" + str(win_size) + ".stats").st_size > 0:
            f_stats = open("/scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats/sim" + str(simID) + "_" + str(win_size) + ".stats", 'r')
            check = 1
        else:
            print ("Empty file")
            check = 0
    except:
        print ("File not found")
        check = 0
    if check == 1:#stats file has been read
        d_stats = {}
        for line in f_stats:
            line1 = line.strip('\n')
            line2 = line1.split('\t')
            if line2[0] == "filename":
                d_colname = {}
                print ("reading column names")
                col = 0
                for x in line2:
                    d_colname[col] = x
                    d_stats[x] = {}
                    col += 1
            else:
                #if line2[1] != str(last_window):#eliminating the last window
                col = 0
                for s_stat in line2:
                    #print(s_stat)
                    try:
                        d_stats[d_colname[col]][line2[0]].append(s_stat)
                    except:
                        d_stats[d_colname[col]][line2[0]] = []
                        d_stats[d_colname[col]][line2[0]].append(s_stat)
                    col += 1
        f_stats.close()
        #Check if the stats file has all the replicates:
        if len(d_stats["filename"]) == 100:#all 100 replicates are present
            d_mean_stats = get_mean_within_reps(d_stats)
            #print (len(d_stats["filename"]))
            #read divergence file:
            if simID > 0:
            #try:
                f_div = open("/scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats/sim" + str(simID) + ".divergence", 'r')
                d_mean_stats["divergence"] = []
                for line in f_div:
                    line1 = line.strip('\n')
                    line2 = line1.split('\t')
                    if "substitutions" not in line:
                        d_mean_stats["divergence"].append(line2[3])
                f_div.close()
            else: #except:
                print ("divergence file not found")
                d_mean_stats["divergence"] = []
            #read the true lambda value:
            f_div_l = open("/scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats/sim" + str(simID) + "_lambda.divergence", 'r')
            d_mean_stats["lambda"] = []
            d_mean_stats["rate_ben"] = []
            d_mean_stats["rate_neu"] = []
            for line in f_div_l:
                line1 = line.strip('\n')
                line2 = line1.split('\t')
                if "num" not in line:
                    d_mean_stats["lambda"].append(float(line2[3]))
                    d_mean_stats["rate_ben"].append(float(line2[1])/float(tot_coding_sites))
                    d_mean_stats["rate_neu"].append(float(line2[2])/float(tot_coding_sites))
            f_div_l.close()
            #write it
            result.write("sim" + str(simID) + '\t' + d_par["sim" + str(simID)])
            for stat in l_stats:
                #print(d_mean_stats["divergence"])
                result.write('\t' + str(meanOfList(d_mean_stats[stat])) + '\t' + str(sdOfList(d_mean_stats[stat])))
            result.write('\n')
        else:
            print ("Does not have sufficient replicates")
    else:
        print ("File is empty")
    simID += 1

print ("done")
