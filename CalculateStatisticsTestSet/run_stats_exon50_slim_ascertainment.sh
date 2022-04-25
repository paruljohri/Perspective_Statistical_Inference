#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-5:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/LOGFILES/stats_ascertainment_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_ascertainment_%j.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set environment:
module load gcc/6.3.0

#Set path to working directory
cd /home/pjohri1/ModelRejection/programs

##For purifying + positive selection (10x) + equilibrium:
#folder="eqm_dfe_pos10x_exon50_100kb_const_rates"

##For purifying selection + positive selection (10x) + decline:
#folder="decline_dfe_pos10x_exon50_100kb_const_rates"

##For purifying selection + positive selection(10x) + growth 2x:
folder="growth2fold_dfe_pos10x_exon50_100kb_const_rates"


#get polymorphism based stats:
mkdir /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats
python statistics_slidingwindow_pylibseq_general_reps.py -masking_status ascertained -winSize 2000 -stepSize 2000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}_singletons

#get SFS:
python /home/pjohri1/SlimStats/get_SFS_from_ms_general_reps.py -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -extension _singletons.ms -output_prefix ${folder}_singletons -num_indv 100

#get Divergence:
python get_divergence_from_slim.py -mutnTypes m5 -ChrLen 99011 -maskedChrLen 49512 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}_singletons

python get_lambda_from_slim.py -mutnTypesPos m6 -mutnTypesCoding m1,m2,m3,m4 -ChrLen 99011 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder} -output_folder /scratch/pjohri1/ModelRejection/simulations/const_rates/${folder}_stats -output_prefix ${folder}_singletons_lambda 

mv /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_${SLURM_JOBID}.out /home/pjohri1/LOGFILES/${folder}_${SLURM_JOBID}.out
mv /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_${SLURM_JOBID}.err /home/pjohri1/LOGFILES/${folder}_${SLURM_JOBID}.err



