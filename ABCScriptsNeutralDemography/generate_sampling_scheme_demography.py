#This is to generate the sampling scheme for Nanc, Ncur and Time:
#N is picked with loguniform distribution between upper and lower bound

import random
import sys
import math

#defined constants:
startingID = 1
endingID = 5000
N_range_lower = 10
N_range_upper = 50000

def get_growth_factor(N_anc, N_cur):
    if N_anc > N_cur:
        N_fold = N_anc/float(N_cur)
        g = math.log(float(N_fold))/float(num_gen_change)
        growth_factor = 1.0 - g
    else:
        N_fold = N_cur/float(N_anc)
        g = math.log(float(N_fold))/float(num_gen_change)
        growth_factor = 1.0 + g
    return growth_factor

def sample_loguniform(lower_bound, upper_bound):
    N_size = round(math.exp(random.uniform(math.log(lower_bound), math.log(upper_bound))))
    return (N_size)

def sample_uniform(N_range_lower, N_range_upper):
    N_size = round(random.uniform(N_range_lower, N_range_upper))
    return (N_size)


result = open("/home/pjohri1/ModelRejection/ABCScriptsNeutral/demo_neutral_100kb_logunif_parameters.txt", 'w+')
result.write("simID" + '\t' + "Nanc" + '\t' + "Ncur" + '\t' + "Time" + '\n')
simID = int(startingID)
while simID <= int(endingID):
    N_anc = sample_loguniform(N_range_lower, N_range_upper)
    N_cur = sample_loguniform(N_range_lower, N_range_upper)
    time = sample_loguniform(10, N_cur)
    
    result.write("sim" + str(simID) + '\t' + str(N_anc) + '\t' + str(N_cur) + '\t' + str(time) + '\n')
    simID = simID + 1

result.close()
print ("Finished")

