#This is to get the divergence from the masked output of msprime.
#Will need to subtract out the polymorphic sites.
#python get_divergence_from_msprime.py -chrLen -input_folder -output_folder -output_prefix

import sys
import argparse

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
#parser.add_argument('-masking_status', dest = 'masking_status', action='store', nargs = 1, type = str, help = 'masking status')
parser.add_argument('-chrLen', dest = 'chrLen', action='store', nargs = 1, type = int, help = 'length in bp of region simulated')#Length of coding region simulated
parser.add_argument('-input_folder', dest = 'input_folder', action='store', nargs = 1, type = str, help = 'full path to folder with .ms files')
parser.add_argument('-output_folder', dest = 'output_folder', action='store', nargs = 1, type = str, help = 'full path to folder where you want to write the output')
parser.add_argument('-output_prefix', dest = 'output_prefix', action='store', nargs = 1, type = str, help = 'full path to output file')

args = parser.parse_args()
#masking_status = args.masking_status[0]
chr_len =  int(args.chrLen[0])
infolder = args.input_folder[0]
outfolder = args.output_folder[0]
prefix = args.output_prefix[0]

#read ms file:
def read_ms(f_ms):
    l_int_posn = []#0,1,2...n-1
    d_posn = {} #l_int_posn -> float position
    d_gt = {}#l_posn -> 0101 (column)
    for line in f_ms:
        line1 = line.strip('\n')
        if "//" not in line and "segsites" not in line:
            if "positions" in line1:
                line2 = line1.split()
                col = 0
                for x in line2:
                    if "position" not in x:
                        l_int_posn.append(col)
                        d_posn[col] = x
                        d_gt[x] = ""
                        col = col + 1
            else:
                for j in l_int_posn:
                    d_gt[d_posn[j]] = d_gt[d_posn[j]] + line1[j]
    return (d_gt)

def get_fixed_sites(d_gt):
    d_fixed = {}
    for s_posn in d_gt.keys():
        count0 = d_gt[s_posn].count("0")
        count1 = d_gt[s_posn].count("1")
        if count0 == 0:
            d_fixed[s_posn] = "1"
        elif count1 == 0:
            d_fixed[s_posn] = "0"
    return(d_fixed)

def get_divergence(d_fixed1, d_fixed2):
    s_subs = 0
    for s_posn in d_fixed1.keys():
        if d_fixed1[s_posn] == "1":
            if d_fixed1[s_posn] != d_fixed2.get(s_posn, "NA"):
                s_subs += 1
    return (s_subs)

result = open(outfolder + "/" + prefix + ".divergence", 'w+')
result.write("repID" + '\t' + "div_per_site" + '\n')

repID = 1
while repID <= 100:
    print (repID)
    f_ms = open(infolder + "/output" + str(repID) + "_masked.ms", 'r')
    d_ms = read_ms(f_ms)
    f_ms.close()
    f_ms_out = open(infolder + "/output" + str(repID) + "_outgroup.ms", 'r')
    d_ms_out = read_ms(f_ms_out)
    f_ms_out.close()
    print ("Number of SNPs: " + str(len(d_ms)))
    #Get fixed sites from each population:
    d_fixed_popn = get_fixed_sites(d_ms)
    d_fixed_out = get_fixed_sites(d_ms_out)
    print("Number of fixed sites: " + str(len(d_fixed_popn)))
    #Get divergence:
    s_div = get_divergence(d_fixed_popn, d_fixed_out)
    s_div_per_site = float(s_div)/float(chr_len)
    print ("Number of substitutions in the main population: " + str(s_div))
    #print ("Number of substitutions in the outgroup population: " + str(get_divergence(d_fixed_out, d_fixed_popn)))
    result.write(str(repID) + '\t' + str(s_div_per_site) + '\n')
    repID += 1
result.close()
print ("done")

