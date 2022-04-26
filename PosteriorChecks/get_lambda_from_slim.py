#This is to get the divergence by using the number of substitutions and also by adding the fixed sites from the sample:
#python get_divergence.py -maskedChrLen -num_gen -folder

import sys
import argparse
import os

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-mutnTypesCoding', dest = 'mutnTypesCoding', action='store', nargs = 1, type = str, help = 'm1,m2,m3')#all mutations in coding regions except for beneficial ones
parser.add_argument('-mutnTypesPos', dest = 'mutnTypesPos', action='store', nargs = 1, type = str, help = 'm1,m2,m3')
parser.add_argument('-ChrLen', dest = 'ChrLen', action='store', nargs = 1, type = int, help = 'length of full genome-1')
#parser.add_argument('-maskedChrLen', dest = 'maskedChrLen', action='store', nargs = 1, type = int, help = 'length of masked genome')
parser.add_argument('-num_gen', dest = 'num_gen', action='store', nargs = 1, type = int, help = 'number of generations after which divergence shoudl be counted')
parser.add_argument('-input_folder', dest = 'input_folder', action='store', nargs = 1, type = str, help = 'full path to folder with .ms files')
parser.add_argument('-output_folder', dest = 'output_folder', action='store', nargs = 1, type = str, help = 'full path to folder where you want to write the output')
parser.add_argument('-output_prefix', dest = 'output_prefix', action='store', nargs = 1, type = str, help = 'full path to output file')

args = parser.parse_args()
s_mutn_types_pos = args.mutnTypesPos[0]
s_mutn_types_coding = args.mutnTypesCoding[0]#includes neutral and deleterious coding mutations
chr_len =  args.ChrLen[0]
#masked_chr_len =  args.maskedChrLen[0]
num_gen_cutoff = args.num_gen[0]
infolder = args.input_folder[0]
outfolder = args.output_folder[0]
prefix = args.output_prefix[0]

num_indv = 100
#be careful about the denominator of the masked file for divergence
def read_fixed_mutations(f_fixed, s_mutn_types):
    d_subs = {}
    for line in f_fixed:
        line1 = line.strip('\n')
        line2 = line1.split()
        if line1[0]!="#" and line2[0]!="Mutations:":
            posn = float(line2[3])/float(chr_len)
            num_gen = line2[8]
            mutn_type = line2[2]
            if mutn_type in s_mutn_types:
                if int(num_gen) >= int(num_gen_cutoff):
                    d_subs[posn] = d_subs.get(posn, 0) + 1
    return d_subs #return a dictionary with base positions as keys and number of fixed substitutions as values

def avg_divergence_win(d_subs, start, end):
    s_sum = 0
    for posn in d_subs.keys():
        if float(posn) <= end and float(posn) > start:
            s_sum = s_sum + 1
    return s_sum

#def get_af_from_ms(f_ms):
#    d_af = {}
#    linecount = 0
#    for line in f_ms:
#        line1 = line.strip('\n')
#        if "//" not in line1 and "segsites" not in line1 and "positions" not in line1:
#            linecount += 1
#            if linecount <= int(num_indv):
#                col = 1
#                for x in line1:
#                    try:
#                        d_af[col] = int(d_af[col]) + int(x)
#                    except:
#                        d_af[col] = int(x)
#                    col += 1
#    return(d_af)

result = open(outfolder + "/" + prefix + ".divergence", 'w+')
result.write("filename" + '\t' + "num_of_beneficial_subs" + '\t' + "num_of_other_subs" + '\t' + "lambda" + '\n')

#Make a list of .fixed files
os.system("ls " + infolder + "/*.fixed > " + outfolder + "/" + prefix + ".list")
f_list = open(outfolder + "/" + prefix +  ".list", 'r')

#Get the number of substitutions after burn-in for each replicate:
for Aline in f_list:
    Aline1 = Aline.strip('\n')
    f_name0 = Aline1.split("/").pop()
    f_name = f_name0.split(".")[0]
    #Get the number of substitutions:
    f_subs = open(infolder + "/" + f_name + ".fixed", 'r')
    d_subs_pos = read_fixed_mutations(f_subs, s_mutn_types_pos)
    f_subs.seek(0)
    d_subs_coding = read_fixed_mutations(f_subs, s_mutn_types_coding)
    num_substitutions_pos = avg_divergence_win(d_subs_pos, 0.0, 1.0)
    num_substitutions_coding = avg_divergence_win(d_subs_coding, 0.0, 1.0)
    f_subs.close()

    #Get the number of fixed sites in the sample:
    #f_MS = open(infolder + "/" + f_name + "_masked.ms", 'r')
    #d_AF = get_af_from_ms(f_MS)
    #num_fixed_sites = 0
    #for x in d_AF.keys():
    #    if d_AF[x] == num_indv:
    #        num_fixed_sites += 1
    #f_MS.close()

    #Write both numbers:
    result.write(f_name + '\t' + str(num_substitutions_pos) + '\t' + str(num_substitutions_coding))
    if num_substitutions_pos+num_substitutions_coding == 0:
        result.write('\t' + "NA" + '\n')
    else:
        result.write('\t' + str(float(num_substitutions_pos)/float(num_substitutions_pos+num_substitutions_coding)) + '\n')

f_list.close()
print ("done")











