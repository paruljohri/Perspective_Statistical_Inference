#This is to generate the sampling scheme for Nanc, Ncur and Time:
#N is picked with loguniform distribution between upper and lower bound
#Scaling factor is calculated separately for each set of parameter combinations, where minimum popn size is 1000
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

def get_scaling_factor(N_anc, N_cur):
    N_min = min(N_anc, N_cur)
    scaling_factor = int(float(N_min)/5000)
    if scaling_factor > 200:
        scaling_factor = 200
    return scaling_factor

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
    #scaling_factor = get_scaling_factor(t_N[0], t_N[1])
    #Na = round(t_N[0]/float(scaling_factor))
    #Nc = round(t_N[1]/float(scaling_factor))
    
    result.write("sim" + str(simID) + '\t' + str(N_anc) + '\t' + str(N_cur) + '\t' + str(time) + '\n')
    simID = simID + 1

result.close()
print ("Finished")

