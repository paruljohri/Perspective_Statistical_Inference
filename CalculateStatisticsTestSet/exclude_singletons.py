#This is to evaluate the effect of detecting fewer singletons in data than present in reality.
#This script will choose a third of singletons randomly and exclude them.
#Will use the masked file:
#python exclude_singletons.py /scratch/pjohri1/ModelRejection/simulations/const_rates/decline_dfe_pos10x_exon50_100kb_const_rates 1

import sys
from random import sample

folder = sys.argv[1]
rep_num = sys.argv[2]#1/2/3...100
num_indv = 100

def read_subset_ms(f_ms, start, end):
    l_float_posn = [] #list of positions of SNPs
    l_int_posn = []
    d_int_float = {}#[int posn]->float posn
    d_gt = {}#[float_posn]->column of alleles
    for line in f_ms:
        line1 = line.strip('\n')
        if "positions" in line1:
            line2 = line1.split()
            i = 0
            for x in line2:
                if "position" not in x:
                    if (float(x) > float(start)) and (float(x) < float(end)):
                        l_float_posn.append(x)
                        l_int_posn.append(i)
                        d_int_float[i] = x
                        d_gt[x] = ""
                    i = i + 1
        elif "//" not in line and "segsites" not in line:
            for j in l_int_posn:
                d_gt[d_int_float[j]] = d_gt[d_int_float[j]] + line1[j]
    return (d_gt, l_float_posn)

def get_singleton_positions(d_GT):
    l_singleton_posns = []
    for s_posn in d_GT.keys():
        s_sum = 0
        for x in d_GT[s_posn]:
            s_sum = s_sum + int(x)
        if s_sum == 1:
            l_singleton_posns.append(s_posn)
    return (l_singleton_posns)

def write_ms_file(d_GT, l_float_posns, f_output):
    num_snps = len(l_float_posns)
    f_output.write("//" + '\n')
    f_output.write("segsites: " + str(num_snps) + '\n')
    f_output.write("positions:")
    for x_posn in l_float_posns:
        f_output.write(" " + str(x_posn))
    f_output.write('\n')
    i = 0
    while i < num_indv:
        for x_posn in l_float_posns:
            f_output.write(d_GT[x_posn][i])
        f_output.write('\n')
        i = i + 1
    print("written")

f_ms = open(folder + "/output" + str(rep_num) + "_masked.ms", 'r')
d_ms = read_subset_ms(f_ms, 0, 1)
d_gt = d_ms[0]
l_positions = d_ms[1]
f_ms.close()
l_singletons = get_singleton_positions(d_gt)
print("total number of SNPs: " + str(len(l_positions)))
print ("total number of singletons: " + str(len(l_singletons)))

#sample a third singletons randomly:
l_exclude_singletons = sample(l_singletons,round(0.333*len(l_singletons)))
#exclude or remove the randomly chosen singletons above:
for x_posn in l_exclude_singletons:
    del d_gt[x_posn]
    l_positions.remove(x_posn)
print ("total number of singletons to be excluded: " + str(len(l_exclude_singletons)))
print ("total number of SNPs after excluding a third singletons: " + str(len(l_positions)))
result = open(folder + "/output" + str(rep_num) + "_singletons.ms", 'w+')

write_ms_file(d_gt, l_positions, result)
result.close()
print("done")


