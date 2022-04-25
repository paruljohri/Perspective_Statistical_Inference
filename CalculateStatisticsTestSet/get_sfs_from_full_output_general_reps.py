#This script lists all *.txt files in the folder that you choose (assuming that they are the Slim output files).
#The script creates 2 output files- one for counts and one for frequency.
#How to run:
#python get_sfs_from_full_output_general_reps.py -input_folder /path/to/intput/folder -output_folder /path/to/output -output_prefix /name/of/output/file -mutn_types m1,m2,m3
import sys
import argparse
import os

#parsing user given constants
parser = argparse.ArgumentParser(description='Information about number of sliding windows and step size')
#parser.add_argument('-regionLen', dest = 'regionLen', action='store', nargs = 1, type = int, help = 'length in bp of region simulated')#Length of coding region simulated
parser.add_argument('-input_folder', dest = 'input_folder', action='store', nargs = 1, type = str, help = 'full path to folder with .ms files')
parser.add_argument('-output_folder', dest = 'output_folder', action='store', nargs = 1, type = str, help = 'full path to folder where you want to write the output')
parser.add_argument('-output_prefix', dest = 'output_prefix', action='store', nargs = 1, type = str, help = 'full path to output file')
parser.add_argument('-mutn_types', dest = 'mutn_types', action='store', nargs = 1, default="m5", type = str, help = 'list of mutation types separated by only a comma')

#read input parameters
args = parser.parse_args()
#chr_len =  args.regionLen[0]
in_folder = args.input_folder[0]
out_folder = args.output_folder[0]
prefix = args.output_prefix[0]
mutn_types = args.mutn_types[0]
print (out_folder)
num_indv = 100

def get_sfs_count(l_af):
    d_sfs = {}
    s_seg = 0 #total number of truly segregating sites
    for x in l_af:
        try:
            d_sfs[x] = d_sfs[x] + 1
        except:
            d_sfs[x] = 1
        if int(x) > 0 and int(x) < int(num_indv):
            s_seg += 1
    print("total number of mutations of type selected:" + str(s_seg))
    return(d_sfs)

def get_sfs_freq(d_sfs_count):
    d_sfs_freq = {}
    s_tot = 0
    for x in d_sfs_count.keys():
        s_tot = s_tot + int(d_sfs_count[x])
    for x in d_sfs_count.keys():
        d_sfs_freq[x] = float(d_sfs_count[x])/float(s_tot)
    return (d_sfs_freq)

def get_af(f_txt, mutn_types):
    l_af = []
    for line in f_txt:
        line1 = line.strip('\n')
        if "#" not in line1:
            if "Mutations" not in line1:
                if "m" in line1:
                    line2 = line1.split()
                    if len(line2) == 9:
                        if line2[2] in mutn_types:
                            l_af.append(line2[8])
    return(l_af)

#Open output file for counts
result_count = open(out_folder + "/" + prefix + "_" + str(num_indv) + "_" + mutn_types + "_count.sfs", 'w+')
i = 1
result_count.write("filename")
while i < int(num_indv):
    result_count.write('\t' + str(i))
    i = i + 1
result_count.write('\n')
#Open output file for frequency
result_freq = open(out_folder + "/" + prefix + "_" + str(num_indv) + "_" + mutn_types + "_freq.sfs", 'w+')
i = 1
result_freq.write("filename")
while i < int(num_indv):
    result_freq.write('\t' + str(i))
    i = i + 1
result_freq.write('\n')

#Make a list of all .txt files:
os.system("ls " + in_folder + "/*.txt > " + out_folder + "/" + prefix + ".list")


f_list = open(out_folder + "/" + prefix + ".list", 'r')
for Aline in f_list:
    Aline1 = Aline.strip('\n')
    f_name = Aline1.split("/").pop()
    print ("Reading file:" + Aline1)
    f_txt = open(in_folder + "/" + f_name, 'r')
    l_AF = get_af(f_txt, mutn_types)
    d_SFS_count = get_sfs_count(l_AF)
    d_SFS_freq = get_sfs_freq(d_SFS_count)
    f_txt.close()   
    
    #Write the full result in counts:
    result_count.write(f_name)#write the d0_0 class
    i = 1
    while (i < int(num_indv)):
        result_count.write('\t' + str(d_SFS_count.get(str(i), 0)))
        i = i + 1
    result_count.write('\n')
    
    #Write the full result in freq:
    result_freq.write(f_name)#write the d0_0 class
    i = 1
    while (i < int(num_indv)):
        result_freq.write('\t' + str(d_SFS_freq.get(str(i), 0)))
        i = i + 1
    result_freq.write('\n')

f_list.close()
print ("done")




