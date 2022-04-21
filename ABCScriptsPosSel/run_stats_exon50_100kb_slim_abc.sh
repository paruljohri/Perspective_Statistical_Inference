#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-10:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_%A_rep%a.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_exon50_100kb_slim_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set environment:
module load gcc/6.3.0

folder="sim"$1

#unzip folder
cd /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection
tar -zxvf ${folder}.tar.gz


#get polymorphism based stats:
cd /home/pjohri1/ModelRejection/programs
#python statistics_slidingwindow_pylibseq_general_reps.py -masking_status masked -winSize 2000 -stepSize 2000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection/${folder} -output_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats -output_prefix ${folder}

##python statistics_slidingwindow_pylibseq_general_reps.py -masking_status masked -winSize 5000 -stepSize 5000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection/${folder} -output_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats -output_prefix ${folder}

##python statistics_slidingwindow_pylibseq_general_reps.py -masking_status masked -winSize 10000 -stepSize 10000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection/${folder} -output_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats -output_prefix ${folder}


#get Divergence:
cd /home/pjohri1/ModelRejection/programs
#python get_divergence_from_slim.py -mutnTypes m2 -ChrLen 99011 -maskedChrLen 49512 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection/${folder} -output_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats -output_prefix ${folder}

python get_lambda_from_slim.py -mutnTypesPos m3 -mutnTypesCoding m1 -ChrLen 99011 -num_gen 50000 -input_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection/${folder} -output_folder /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection_stats -output_prefix ${folder}_lambda

#Remove folder
cd /scratch/pjohri1/ModelRejection/ABCSims/eqm_100kb_pos_selection
rm -r ${folder}


