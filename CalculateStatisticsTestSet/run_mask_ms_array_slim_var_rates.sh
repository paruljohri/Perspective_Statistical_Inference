#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-2:00                  # wall time (D-HH:MM)
#SBATCH -a 1-100%100
#SBATCH -o /home/pjohri1/LOGFILES/mask_ms_files_exon50_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/mask_ms_files_exon50_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set environment:
module load gcc/6.3.0

#Set path to working directory
cd /home/pjohri1/ModelRejection/programs


folders=("eqm_dfe_pos10x_exon50_100kb_var_rates" "decline_dfe_pos10x_exon50_100kb_var_rates" "growth2fold_dfe_pos10x_exon50_100kb_var_rates")

declare -i repID=0+$SLURM_ARRAY_TASK_ID

for s_folder in "${folders[@]}"
do
    echo "folder "${s_folder}
    #unzip:
    #cd /scratch/pjohri1/ModelRejection/simulations/var_rates
    #tar -zxvf ${s_folder}.tar.gz

    #mask the genome:
    cd /home/pjohri1/ModelRejection/programs
    if [ ! -f "/scratch/pjohri1/ModelRejection/simulations/var_rates/"${s_folder}"/output"${repID}"_masked.ms" ]
    then
        python mask_exonic_regions_v2.py /scratch/pjohri1/ModelRejection/simulations/var_rates/${s_folder} ${repID} exon50 slim
    fi
done



