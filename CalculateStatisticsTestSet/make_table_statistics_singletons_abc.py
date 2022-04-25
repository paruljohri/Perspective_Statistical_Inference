#This is to make the final table with all statistics for conducting ABC:

import sys
import os
import numpy as np

#l_folders = ["eqm_neutral_exon50_100kb_const_rates_s0", "eqm_dfe_exon50_100kb_const_rates", "eqm_pos_exon50_100kb_const_rates", "eqm_dfe_pos_exon50_100kb_const_rates", "eqm_dfe_pos10x_exon50_100kb_const_rates", "eqm_dfe_pos100x_exon50_100kb_const_rates", "decline_neutral_exon50_100kb_const_rates", "decline_dfe_exon50_100kb_const_rates", "decline_dfe_pos_exon50_100kb_const_rates", "decline_dfe_pos10x_exon50_100kb_const_rates", "growth_neutral_exon50_100kb_const_rates", "growth_dfe_exon50_100kb_const_rates", "growth_dfe_pos_exon50_100kb_const_rates", "growth2fold_neutral_exon50_100kb_const_rates", "growth2fold_dfe_exon50_100kb_const_rates", "growth2fold_dfe_pos_exon50_100kb_const_rates", "growth2fold_dfe_pos10x_exon50_100kb_const_rates", "eqm_dfe_exon50_100kb_const_rates_psi0_05", "eqm_dfe_exon50_100kb_const_rates_psi0_1", "eqm_dfe_pos_exon50_100kb_var_rates", "eqm_dfe_pos10x_exon50_100kb_var_rates", "decline_dfe_pos_exon50_100kb_var_rates", "decline_dfe_pos10x_exon50_100kb_var_rates", "growth2fold_dfe_pos_exon50_100kb_var_rates", "growth2fold_dfe_pos10x_exon50_100kb_var_rates"]
l_folders = ["eqm_dfe_pos10x_exon50_100kb_const_rates", "decline_dfe_pos10x_exon50_100kb_const_rates", "growth2fold_dfe_pos10x_exon50_100kb_const_rates"]
win_size = 2000
l_stats = ["S", "thetapi", "thetaw", "thetah", "hprime", "tajimasd", "numSing", "hapdiv", "rsq", "D", "Dprime", "divergence", "lambda"]

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
    for stat in l_stats[0:len(l_stats)-2]:
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


#Result:
result = open("/home/pjohri1/ModelRejection/testset_100kb_singletons_" + str(win_size) + ".stats", 'w+')
result.write("scenario")
for x in l_stats:
    result.write('\t' + x + "_mean" + '\t' + x + "_sd")
result.write('\n')

#Read the stats:

for s_folder in l_folders:
    print ("folder: " + str(s_folder))
    if "const" in s_folder:
        f_stats = open("/scratch/pjohri1/ModelRejection/simulations/const_rates/" + s_folder + "_stats/" + s_folder + "_singletons_" + str(win_size) + ".stats", 'r')
    elif "var" in s_folder:
        f_stats = open("/scratch/pjohri1/ModelRejection/simulations/var_rates/" + s_folder + "_stats/" + s_folder + "_singletons_" + str(win_size) + ".stats", 'r')
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
    print ("number of replicates we have: " + str(len(d_stats["filename"])))
    d_mean_stats = get_mean_within_reps(d_stats)
    
    #read divergence file:
    if "const" in s_folder:
        f_div = open("/scratch/pjohri1/ModelRejection/simulations/const_rates/" + s_folder + "_stats/" + s_folder + "_singletons.divergence", 'r')
    elif "var" in s_folder:
        f_div = open("/scratch/pjohri1/ModelRejection/simulations/var_rates/" + s_folder + "_stats/" + s_folder + "_singletons.divergence", 'r')
    d_mean_stats["divergence"] = []
    for line in f_div:
        line1 = line.strip('\n')
        line2 = line1.split('\t')
        if "div" not in line:
            d_mean_stats["divergence"].append(float(line2[3]))
    f_div.close()

    #read lambda file:
    if "const" in s_folder:
        f_div = open("/scratch/pjohri1/ModelRejection/simulations/const_rates/" + s_folder + "_stats/" + s_folder + "_singletons_lambda.divergence", 'r')
    elif "var" in s_folder:
        f_div = open("/scratch/pjohri1/ModelRejection/simulations/var_rates/" + s_folder + "_stats/" + s_folder + "_singletons_lambda.divergence", 'r')
    d_mean_stats["lambda"] = []
    for line in f_div:
        line1 = line.strip('\n')
        line2 = line1.split('\t')
        d_col = {}
        if "num" in line:
            col = 0
            for x in line2:
                d_col[x] = col
                col += 1
        else:
            d_mean_stats["lambda"].append(line2[3])
    f_div.close()
     
    #write it
    result.write(s_folder + "_singletons")
    for stat in l_stats:
        result.write('\t' + str(meanOfList(d_mean_stats[stat])) + '\t' + str(sdOfList(d_mean_stats[stat])))
    result.write('\n')

print ("done")
