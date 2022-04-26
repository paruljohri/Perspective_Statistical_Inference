#This is to simulate a chromosome of size 100kb using msprime and output data in ms format:
#python simulate_msprime_inst_change_divergence.py -outFolder /home/pjohri1/ModelRejection/ABCSims/demo_neutral_ -simNum simID -repNum repID
import sys
import os
import msprime
import math
import argparse

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-outFolder', dest = 'outFolder', action='store', nargs = 1, type = str, help = 'full path to output folder')#output foldername
parser.add_argument('-simNum', dest = 'simNum', action='store', nargs = 1, type = int, help = 'simulation number')
parser.add_argument('-repNum', dest = 'repNum', action='store', nargs = 1, type = int, help = 'replicate number')
#parser.add_argument('-Nanc', dest = 'Nanc', action='store', nargs = 1, type = int, help = 'Nancestral')
#parser.add_argument('-Ncur', dest = 'Ncur', action='store', nargs = 1, type = int, help = 'Ncurrent')
#parser.add_argument('-Time', dest = 'Time', action='store', nargs = 1, type = int, help = 'Time of change in generations')
args = parser.parse_args()
out_folder = args.outFolder[0]
simID = args.simNum[0]
repID = args.repNum[0]
#N_anc = args.Nanc[0]
#N_cur = args.Ncur[0]
#t_gen = args.Time[0]

#define some constants:
mutn_rate = 1e-6
rec_rate = 2e-6
chrom_len = 99012
s_seed = int(repID)

def get_parameters_from_file(simID):
    t_parameters = ()
    f_par = open("/home/pjohri1/ModelRejection/demo_100kb_neutral_2000_inference_parameters.txt", 'r')
    d_col = {}
    for line in f_par:
        line1 = line.strip('\n')
        line2 = line1.split('\t')
        if line2[0] == "scenarioID":
            col = 0
            for x in line2:
                d_col[x] = col
                col += 1
        else:
            if line2[d_col["scenarioID"]] == "scenario" + str(simID):
                t_parameters = (line2[d_col["Nanc"]], line2[d_col["Ncur"]], line2[d_col["Time"]])
    f_par.close()
    return(t_parameters)

def instantaneous_change(N_anc, N_cur, t_gen, num_indv):
    r = 0
    population_configurations = [
        msprime.PopulationConfiguration(sample_size=num_indv, initial_size=N_cur, growth_rate=0), 
        msprime.PopulationConfiguration(sample_size=num_indv, initial_size=N_cur, growth_rate=0)]
    demographic_events = [
        msprime.PopulationParametersChange(time=t_gen, initial_size=N_anc, growth_rate=0, population_id=0),
        msprime.PopulationParametersChange(time=t_gen, initial_size=N_anc, growth_rate=0, population_id=1),
        msprime.MassMigration(time=10*N_anc, source=1, destination=0, proportion=1.0)]
    return (population_configurations, demographic_events)

#repID = 1
#while repID <= num_reps:
#    print (repID)
try:
    f_check = open(out_folder + "/output" + str(repID) + ".ms", 'r')
    f_check.close()
except:
    #get parameters from file:
    t_par = get_parameters_from_file(simID)
    N_anc = int(t_par[0])
    N_cur = int(t_par[1])
    t_gen = int(t_par[2])
    print("parameters are - Nancestor: " + str(N_anc) + " Ncurrent: " + str(N_cur) + " Time: " + str(t_gen))
    t_tmp = instantaneous_change(N_anc, N_cur, t_gen, 100)#function defined above
    population_configurations = t_tmp[0]
    demographic_events = t_tmp[1]
    #check demographiic history:
    dd = msprime.DemographyDebugger(population_configurations=population_configurations, demographic_events=demographic_events)
    dd.print_history()
    #simulate
    tree = msprime.simulate(population_configurations=population_configurations, demographic_events=demographic_events, length=chrom_len, recombination_rate=rec_rate, mutation_rate=mutn_rate, random_seed=s_seed)
    result = open(out_folder + "/output" + str(repID) + ".ms", 'w+')
    result_outgroup = open(out_folder + "/output" + str(repID) + "_outgroup.ms", 'w+')
    result.write("//" + '\n')
    result_outgroup.write("//" + '\n')
    d_posn, d_geno = {}, {}
    l_sites = []
    for variant in tree.variants():
        l_sites.append(variant.site.id)
        d_posn[variant.site.id] = round(float(variant.site.position)/chrom_len, 7)
        d_geno[variant.site.id] = variant.genotypes
        #print ('\t' + variant.site.position)
    print("number of SNPs:" + str(len(d_geno)))
    result.write("segsites: " + str(len(l_sites)) + '\n')
    result_outgroup.write("segsites: " + str(len(l_sites)) + '\n')
    result.write("positions:")
    result_outgroup.write("positions:")
    for site in l_sites:
        result.write(" " + str(d_posn[site]))
        result_outgroup.write(" " + str(d_posn[site]))
    print("number of genomes:" + str(len(d_geno[l_sites[0]])))
    result.write('\n')
    result_outgroup.write('\n')
    #write out genotpyes for the main population
    i = 0
    while i < 100:
        for site in l_sites:
            result.write(str(d_geno[site][i]))
        result.write('\n')
        i = i + 1
    result.close()
    #write out genotypes for the outgroup population
    i = 100
    while i < 200:
        for site in l_sites:
            result_outgroup.write(str(d_geno[site][i]))
        result_outgroup.write('\n')
        i = i + 1
    result_outgroup.close()
    #repID = repID + 1

print ("done")

