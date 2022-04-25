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

#folders=("eqm_neutral_exon50_100kb_const_rates_s0" "eqm_dfe_exon50_100kb_const_rates" "eqm_pos_exon50_100kb_const_rates" "eqm_dfe_pos_exon50_100kb_const_rates" "eqm_dfe_pos10x_exon50_100kb_const_rates" "eqm_dfe_pos100x_exon50_100kb_const_rates" "decline_neutral_exon50_100kb_const_rates" "decline_dfe_exon50_100kb_const_rates" "decline_dfe_pos_exon50_100kb_const_rates" "decline_dfe_pos10x_exon50_100kb_const_rates" "growth_neutral_exon50_100kb_const_rates" "growth_dfe_exon50_100kb_const_rates" "growth_dfe_pos_exon50_100kb_const_rates" "growth2fold_neutral_exon50_100kb_const_rates" "growth2fold_dfe_exon50_100kb_const_rates" "growth2fold_dfe_pos_exon50_100kb_const_rates" "growth2fold_dfe_pos100x_exon50_100kb_const_rates" "eqm_dfe_exon50_100kb_const_rates_psi0_05" "eqm_dfe_exon50_100kb_const_rates_psi0_1")

#folders=("decline2fold_100gen_dfe_pos10x_exon50_100kb_const_rates" "decline5fold_500gen_dfe_pos10x_exon50_100kb_const_rates" "decline10fold_1000gen_dfe_pos10x_exon50_100kb_const_rates")
#folders=("decline5fold_1000gen_dfe_pos10x_exon50_100kb_const_rates" "decline5fold_2000gen_dfe_pos10x_exon50_100kb_const_rates")
#folders=("bot100gen10sev_dfe_pos10x_exon50_100kb_const_rates_1000gen" "bot100gen10sev_dfe_pos10x_exon50_100kb_const_rates_2000gen" "bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_1000gen" "bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen" "bot10gen10sev_dfe_pos10x_exon50_100kb_const_rates_1000gen" "bot10gen10sev_dfe_pos10x_exon50_100kb_const_rates_2000gen" "bot10gen1sev_dfe_pos10x_exon50_100kb_const_rates_1000gen" "bot10gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen")
folders=("eqm_dfe_exon50_100kb_const_rates" "eqm_dfe_pos10x_exon50_100kb_const_rates" "bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen" "growth2fold_dfe_pos10x_exon50_100kb_const_rates" "eqm_dfe_exon50_100kb_const_rates_psi0_05" "eqm_dfe_exon50_100kb_const_rates_psi0_1" "decline_dfe_pos10x_exon50_100kb_const_rates")

declare -i repID=0+$SLURM_ARRAY_TASK_ID

for s_folder in "${folders[@]}"
do
    echo "folder "${s_folder}
    #unzip:
    cd /scratch/pjohri1/ModelRejection/simulations/const_rates
    tar -zxvf ${s_folder}.tar.gz

    #mask the genome:
    cd /home/pjohri1/ModelRejection/programs
    if [ ! -f "/scratch/pjohri1/ModelRejection/simulations/const_rates/"${s_folder}"/output"${repID}"_masked.ms" ]
    then
        python mask_exonic_regions_v2.py /scratch/pjohri1/ModelRejection/simulations/const_rates/${s_folder} ${repID} exon50 slim
    fi
done



