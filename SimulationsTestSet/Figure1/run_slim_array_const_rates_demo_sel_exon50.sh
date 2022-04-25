#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-10:00                  # wall time (D-HH:MM)
#SBATCH -a 1-100%100
#SBATCH -o /home/pjohri1/LOGFILES/eqm_neutral_exon50_100kb_var_rates_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/eqm_neutral_exon50_100kb_var_rates_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#Set path to working directory
cd /home/pjohri1/ModelRejection/SlimScripts

#Set the environment
module load slim/3.1

declare -i repID=0+$SLURM_ARRAY_TASK_ID

#Eqm+neutral
#folder="eqm_neutral_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=5000 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Eqm+purifying selection:
#folder="eqm_dfe_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=5000 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Eqm+positive selection:
folder="eqm_pos_exon50_100kb_const_rates"
mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
if [ ! -f "/scratch/pjohri1/ModelRejection/simulations/const_rates/"${folder}"/output"${repID}".ms" ]
then
    slim -d d_seed=${repID} -d d_Ncur=5000 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d d_f_pos=2.2e-4 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim
fi

#Decline+neutral:
#folder="decline_neutral_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=100 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Decline+purifying selection:
#folder="decline_dfe_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=100 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Decline+purifying selection + positive selection:
#folder="decline_dfe_pos_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=100 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=2.2e-4 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Growth+neutral
#folder="growth_neutral_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=25000 -d d_f0=1 -d d_f1=0 -d d_f2=0 -d d_f3=0 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Growth+purifying selection
#folder="growth_dfe_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=25000 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=0.0 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim

#Growth+purifying selection + positive selection
#folder="growth_dfe_pos_exon50_100kb_const_rates"
#mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}
#slim -d d_seed=${repID} -d d_Ncur=25000 -d d_f0=0.25 -d d_f1=0.25 -d d_f2=0.25 -d d_f3=0.25 -d d_f_pos=2.2e-4 -d "d_repID='${repID}'" -d "d_folder='/scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}'" demo_sel_exon50_100kb_const_rates.slim








