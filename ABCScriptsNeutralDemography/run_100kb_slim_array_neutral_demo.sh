#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -a 1-100%100
#SBATCH -o /home/pjohri1/LOGFILES/sim_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/sim_%A_rep%a.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
######################################
#To be run on AGAVE!
#100 simulations per submitted job!
#######################################

#simID=$1
declare -i simID=900+$SLURM_ARRAY_TASK_ID

folder="demo_100kb_neutral"

#make a new folder for this simulation ID
cd /scratch/pjohri1/ModelRejection/ABCSims/${folder}
mkdir sim$simID

#run the simulations
cd /home/pjohri1/ModelRejection/ABCScriptsNeutral
echo "Running msprime"
repID=1
while [ $repID -lt 101 ];
do
    python simulate_msprime_inst_change_divergence_abc.py -outFolder /scratch/pjohri1/ModelRejection/ABCSims/${folder}/sim${simID} -simNum ${simID} -repNum ${repID}
    repID=$(( ${repID} + 1 ))
done


#mask the genome:
echo "masking the sims"
repID=1
while [ $repID -lt 101 ];
do
        python /home/pjohri1/ModelRejection/programs/mask_exonic_regions_v2.py /scratch/pjohri1/ModelRejection/ABCSims/${folder}/sim${simID} ${repID} exon50 msprime
        repID=$(( ${repID} + 1 ))
done

#Zip the folder:
cd /scratch/pjohri1/ModelRejection/ABCSims/${folder}
echo "zipping folder"
tar -zcvf sim${simID}.tar.gz sim${simID}

#Remove the folder
cd /scratch/pjohri1/ModelRejection/ABCSims/${folder}
rm -r sim${simID}


