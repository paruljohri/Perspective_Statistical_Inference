#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-10:00                  # wall time (D-HH:MM)
#SBATCH -a 1-100%100
#SBATCH -s
#SBATCH -o /home/pjohri/LOGFILES/bot_sel_const_rates_%A_rep%a.out
#SBATCH -e /home/pjohri/LOGFILES/bot_sel_const_rates_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#Set path to working directory
cd /home/pjohri/ModelRejection/SlimScripts_gro

declare -i repID=0+$SLURM_ARRAY_TASK_ID


##Bottleneck 1%, lasting for 100 gen
folder="bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates"
mkdir /home/pjohri/ModelRejection/simulations/const_rates/${folder}_1000gen
mkdir /home/pjohri/ModelRejection/simulations/const_rates/${folder}_2000gen
/mnt/storage/software/slim.3.1/build/slim -d d_seed=${repID} -d d_bot_sev=0.01 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=2.2e-3 -d "d_repID='${repID}'" -d "d_folder='/home/pjohri/ModelRejection/simulations/const_rates/${folder}'" bot100gen_sel_exon50_100kb_const_rates.slim








