#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-10:00                  # wall time (D-HH:MM)
#SBATCH -a 1-100%100
#SBATCH -o /home/pjohri1/LOGFILES/psi_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/psi_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#Set path to working directory
cd /home/pjohri1/ModelRejection/SlimScripts

#Set the environment
module load slim/3.1

declare -i repID=0+$SLURM_ARRAY_TASK_ID

#psi=0.05
folder="eqm_dfe_exon50_100kb_const_rates_psi0_05"
if [ ! -f "/scratch/pjohri1/ModelRejection/simulations/${folder}/output${repID}.ms" ]
then
    slim -d d_seed=${repID} -d d_psi=0.05 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/${folder}'" eqm_dfe_exon50_100kb_const_rates_psi.slim
fi

#psi=0.1
folder="eqm_dfe_exon50_100kb_const_rates_psi0_1"
if [ ! -f "/scratch/pjohri1/ModelRejection/simulations/${folder}/output${repID}.ms" ]
then
    slim -d d_seed=${repID} -d d_psi=0.1 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/eqm_dfe_exon50_100kb_const_rates_psi0_1'" eqm_dfe_exon50_100kb_const_rates_psi.slim
fi



