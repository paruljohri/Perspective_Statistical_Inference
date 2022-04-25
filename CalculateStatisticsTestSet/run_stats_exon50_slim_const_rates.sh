#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-5:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_%j.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set environment:
module load gcc/6.3.0

#Set path to working directory
cd /home/pjohri1/ModelRejection/programs

##For Neutral equilibrium with constant rates with s=0:
#folder="eqm_neutral_exon50_100kb_const_rates_s0"

##For purifying selection + equilibrium:
#folder="eqm_dfe_exon50_100kb_const_rates"

##For purifying + positive selection (10x) + equilibrium:
#folder="eqm_dfe_pos10x_exon50_100kb_const_rates"

##For neutrality + decline
#folder="decline_neutral_exon50_100kb_const_rates"

##For purifying selection + decline
#folder="decline_dfe_exon50_100kb_const_rates"

##For purifying selection + positive selection (10x) + decline:
#folder="decline_dfe_pos10x_exon50_100kb_const_rates"

##For neutral + growth 2x
#folder="growth2fold_neutral_exon50_100kb_const_rates"

##For purifying selection + growth 2x
#folder="growth2fold_dfe_exon50_100kb_const_rates"

##For purifying selection + positive selection(10x) + growth 2x:
#folder="growth2fold_dfe_pos10x_exon50_100kb_const_rates"

##For neutral + eqm + psi (0.05):
#folder="eqm_dfe_exon50_100kb_const_rates_psi0_05"

##For neutral + eqm + psi (0.1):
#folder="eqm_dfe_exon50_100kb_const_rates_psi0_1"

##Bottleneck models:
#folder="bot100gen10sev_dfe_pos10x_exon50_100kb_const_rates_1000gen"
#folder="bot100gen10sev_dfe_pos10x_exon50_100kb_const_rates_2000gen"
#folder="bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_1000gen"
#folder="bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen"
#folder="bot10gen10sev_dfe_pos10x_exon50_100kb_const_rates_1000gen"
#folder="bot10gen10sev_dfe_pos10x_exon50_100kb_const_rates_2000gen"
#folder="bot10gen1sev_dfe_pos10x_exon50_100kb_const_rates_1000gen" 
folder="bot10gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen"

#get polymorphism based stats:
mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats
python statistics_slidingwindow_pylibseq_general_reps.py -masking_status masked -winSize 2000 -stepSize 2000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}

#get SFS:
python /home/pjohri1/SlimStats/get_sfs_from_full_output_general_reps.py -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder} -mutn_types m5

#get Divergence:
python get_divergence_from_slim.py -mutnTypes m5 -ChrLen 99011 -maskedChrLen 49512 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}

python get_lambda_from_slim.py -mutnTypesPos m6 -mutnTypesCoding m1,m2,m3,m4 -ChrLen 99011 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}_lambda 

mv /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_${SLURM_JOBID}.out /home/pjohri1/LOGFILES/${folder}_${SLURM_JOBID}.out
mv /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_${SLURM_JOBID}.err /home/pjohri1/LOGFILES/${folder}_${SLURM_JOBID}.err



