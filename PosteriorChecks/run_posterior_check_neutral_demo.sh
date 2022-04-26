#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -o /home/pjohri1/LOGFILES/scenario%j.out
#SBATCH -e /home/pjohri1/LOGFILES/scenario%j.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
######################################
#To be run on AGAVE!
#100 simulations per submitted job!
#######################################

declare -i scenarioID=$1

folder="demo_neutral"

#make a new folder for this simulation ID
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
mkdir scenario$scenarioID

#run the simulations
cd /home/pjohri1/ModelRejection/PosteriorChecks
echo "Running msprime"
repID=1
while [ $repID -lt 101 ];
do
    python simulate_msprime_inst_change_divergence_abc.py -outFolder /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}/scenario${scenarioID} -simNum ${scenarioID} -repNum ${repID}
    repID=$(( ${repID} + 1 ))
done


#mask the genome:
echo "masking the sims"
repID=1
while [ $repID -lt 101 ];
do
        python /home/pjohri1/ModelRejection/programs/mask_exonic_regions_v2.py /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}/scenario${scenarioID} ${repID} exon50 msprime
        repID=$(( ${repID} + 1 ))
done

#Zip the folder:
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
echo "zipping folder"
tar -zcvf scenario${scenarioID}.tar.gz scenario${scenarioID}

#Remove the folder
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
rm -r scenario${scenarioID}


