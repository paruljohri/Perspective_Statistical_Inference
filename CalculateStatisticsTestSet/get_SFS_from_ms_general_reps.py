#This is to get the SFS (exlcuding the fixed and 0 class) from a .ms file:
#How to run:
##python get_SFS_from_ms_including0_general_reps.py -regionLen -input_folder -output_folder -output_prefix -num_indv 100

import sys
import argparse
import os

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
parser.add_argument('-regionLen', dest = 'regionLen', action='store', nargs = 1, type = int, help = 'length in bp of region simulated')#Length of coding region simulated
#parser.add_argument('-folder', dest = 'folder', action='store', nargs = 1, type = str, help = 'full path to folder')
parser.add_argument('-input_folder', dest = 'input_folder', action='store', nargs = 1, type = str, help = 'full path to folder with .ms files')
parser.add_argument('-output_folder', dest = 'output_folder', action='store', nargs = 1, type = str, help = 'full path to folder where you want to write the output')
parser.add_argument('-output_prefix', dest = 'output_prefix', action='store', nargs = 1, type = str, help = 'full path to output file')
parser.add_argument('-num_indv', dest = 'num_indv', action='store', nargs = 1, type = int, help = 'number  of individuals for which the SFS will be made')

#read input parameters
args = parser.parse_args()
chr_len =  args.regionLen[0]
in_folder = args.input_folder[0]
out_folder = args.output_folder[0]
prefix = args.output_prefix[0]
num_indv = args.num_indv[0]
print (out_folder)

def get_sfs(l_af):
    d_sfs = {}
    s_seg = 0 #total number of truly segregating sites
    s_not_anc = 0 #required to know the d0_0 class
    for x in l_af:
        try:
            d_sfs[x] = d_sfs[x] + 1
        except:
            d_sfs[x] = 1
        if int(x) > 0 and int(x) < int(num_indv):
            s_seg += 1
        if int(x) > 0:
            s_not_anc += 1
    return(d_sfs)

#Open output file
result = open(out_folder + "/" + prefix + "_" + str(num_indv) + ".sfs", 'w+')
i = 1
result.write("filename")
while i < int(num_indv):
    result.write('\t' + str(i))
    i = i + 1
result.write('\n')

#Make a list of all .ms files:
os.system("ls " + in_folder + "/*_masked.ms > " + out_folder + "/" + prefix + ".list")


f_list = open(out_folder + "/" + prefix + ".list", 'r')
for Aline in f_list:
    Aline1 = Aline.strip('\n')
    f_name = Aline1.split("/").pop()
    print ("Reading file:" + Aline1)
    f_ms = open(in_folder + "/" + f_name, 'r')

    #reading in genotypes from ms
    d_af = {}
    linecount = 0
    for line in f_ms:
        line1 = line.strip('\n')
        if "//" not in line1 and "segsites" not in line1 and "positions" not in line1:
            linecount += 1
            if linecount <= int(num_indv):
                col = 1
                for x in line1:
                    try:
                        d_af[col] = int(d_af[col]) + int(x)
                    except:
                        d_af[col] = int(x)
                    col += 1
    f_ms.close()
    
    #get the SFS:
    l_af = []
    for posn in d_af.keys():
        l_af.append(d_af[posn])
    d_sfs = get_sfs(l_af)
    
    #Write the full result:
    result.write(f_name)#write the d0_0 class
    i = 1
    while (i < int(num_indv)):
        result.write('\t' + str(d_sfs.get(i, 0)))
        i = i + 1
    result.write('\n')

f_list.close()
print ("done")

