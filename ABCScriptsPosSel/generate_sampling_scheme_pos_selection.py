#This is to generate the sampling scheme for gamma=2Ns and f = proportion of beneficla mutations for equilibrium populations:
#picked with loguniform distribution between upper and lower bound

import random
import sys
import math

#defined constants:
num_gen_change = 100
startingID = 1
endingID = 5000
gamma_range_lower = 0.1
gamma_range_upper = 10000
f_range_lower = 0.00001
f_range_upper = 0.01


def get_scaling_factor(N_anc, N_cur):
    N_min = min(N_anc, N_cur)
    scaling_factor = int(float(N_min)/5000)
    if scaling_factor > 200:
        scaling_factor = 200
    return scaling_factor

def sample_loguniform(lower_bound, upper_bound):
    s_value = math.exp(random.uniform(math.log(lower_bound), math.log(upper_bound)))
    #Nc_abs = round(math.exp(random.uniform(math.log(lower_bound), math.log(upper_bound))))
    return (s_value)

def sample_uniform(lower_bound, upper_bound):
    s_value = random.uniform(lower_bound, upper_bound)
    #Nc_abs = round(random.uniform(N_range_lower, N_range_upper))
    return (s_value)


result = open("/home/pjohri1/ModelRejection/ABCScripts/eqm_pos_100kb_logunif_parameters.txt", 'w+')
result.write("simID" + '\t' + "gamma" + '\t' + "f" + '\n')
simID = int(startingID)
while simID <= int(endingID):
    s_gamma = round(sample_loguniform(gamma_range_lower, gamma_range_upper))
    s_f = sample_loguniform(f_range_lower, f_range_upper)
    result.write("sim" + str(simID) + '\t' + str(s_gamma) + '\t' + str(s_f) + '\n')
    simID = simID + 1

result.close()
print ("Finished")

