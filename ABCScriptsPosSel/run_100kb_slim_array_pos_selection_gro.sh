#!/bin/bash
#SBATCH --mail-user=pjohri1@asu.edu
#SBATCH --mail-type=ALL
#SBATCH -n 1 #number of tasks
#SBATCH --time=0-10:00
#SBATCH -a 1-100%80
#SBATCH -o /home/pjohri/LOGFILES/sim_%A_rep%a.out
#SBATCH -e /home/pjohri/LOGFILES/sim_%A_rep%a.err

module load perl/5.22.1
echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
######################################
#To be run on GROMIT!
#One simulation per submitted job!
#######################################

simID=$1
declare -i repID=$SLURM_ARRAY_TASK_ID

#make a new folder for this simulation ID
cd /home/pjohri/ModelRejection/ABCSims/eqm_100kb_pos_selection
mkdir sim$simID

#run the simulations
cd /home/pjohri/ModelRejection/ABCScripts

python make_command_file_gro.py -simNum $simID -repNum $repID -outFolder /home/pjohri/ModelRejection/ABCSims/eqm_100kb_pos_selection_bash

bash /home/pjohri/ModelRejection/ABCSims/eqm_100kb_pos_selection_bash/sim${simID}_rep${repID}.sh





