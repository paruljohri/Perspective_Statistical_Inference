#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -a 1-100%100
#SBATCH -o /home/pjohri1/LOGFILES/pos_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/pos_%A_rep%a.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
######################################
#To be run on AGAVE!
#One simulation per submitted job!
#######################################

module load slim/3.1

scenarioID=$1
declare -i repID=$SLURM_ARRAY_TASK_ID

#make a new folder for this simulation ID
mkdir /scratch/pjohri1/ModelRejection/PosteriorChecks/eqm_pos_selection/scenario$scenarioID

#run the simulations
cd /home/pjohri1/ModelRejection/PosteriorChecks

python make_command_file_pos.py -scenarioNum $scenarioID -repNum $repID -outFolder /scratch/pjohri1/ModelRejection/PosteriorChecks/eqm_pos_selection/bash_files

bash /scratch/pjohri1/ModelRejection/PosteriorChecks/eqm_pos_selection/bash_files/scenario${scenarioID}_rep${repID}.sh





