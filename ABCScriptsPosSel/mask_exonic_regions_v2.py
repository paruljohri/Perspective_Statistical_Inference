#This script is to mask coding regions from an ms file (mostly just remove them) and then create another ms output file.
#python mask_exonic_regions.py eqm_dfe_exon50_100kb_var_rates_masked repID

import sys
folder = sys.argv[1]
rep_num = sys.argv[2]

#Read the genome coordinates and figure out which sites to mask:
if "exon20" in folder:
    f_genome = open("/home/pjohri/ModelRejection/genome_structure_exon20.txt", 'r')
    tot_len = 97625
else:
    f_genome = open("/home/pjohri/ModelRejection/genome_structure_exon50.txt", 'r')
    if "msprime" in folder:
        tot_len = 99012
    else:
        tot_len = 99012-1
d_sites_type = {}
for line in f_genome:
    if "initializeGenomicElement(" in line:
        line1 = line.strip('\n').replace("initializeGenomicElement", "")
        line2 = line1.replace(" ", "")
        line3 = line2.replace("(", "")
        line4 = line3.replace(")", "")
        line5 = line4.replace(";", "")
        line6 = line5.split(',')
        s_region = line6[0]
        s_start = int(line6[1])
        s_end = int(line6[2])
        if s_region == "g1" or s_region=="g2":#g3 is coding region
            posn = s_start
            while posn <= s_end:
                s_site = posn
                d_sites_type[s_site] = "int"
                posn = posn + 1
f_genome.close()

#Mask the .ms file:
l_unmasked_posns = []
print ("rep_num:  " + str(rep_num))
f_ms = open(folder + "/output" + str(rep_num) + ".ms", 'r')
result = open(folder + "/output" + str(rep_num) + "_masked.ms", 'w+')
#identify unmasked positions
for line in f_ms:
    line1 = line.strip('\n')
    if "positions" in line1:
        line2 = line1.split()
        col = 0
        for posn in line2:
            if "position" not in posn:
                s_site = int(round(float(posn)*tot_len))
                if d_sites_type.get(s_site, "NA") == "int":#the site is intergenic
                    l_unmasked_posns.append(col)
                col = col + 1
print(max(l_unmasked_posns))
#re-write ms file
f_ms.seek(0)
result.write("//" + '\n')
result.write("segsites: " + str(len(l_unmasked_posns)) + '\n')
#result.write("positions:")
for line in f_ms:
    line1 = line.strip('\n')
    line2 = line1.split()
    if "positions" in line1:
        result.write("positions:")
        for col_num in l_unmasked_posns:
            result.write(" " + str(line2[col_num+1]))
        result.write('\n')
    elif "//" not in line1 and "segsites" not in line1:
        #print (line2)
        for col_num in l_unmasked_posns:
            result.write(line1[col_num])
        result.write('\n')
result.close()
f_ms.close()
        
print("done")
