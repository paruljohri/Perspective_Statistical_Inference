#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-5:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/LOGFILES/stats_posterior_msprime_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/stats_posterior_msprime_%j.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set environment:
module load gcc/6.3.0

folder="scenario"$1

#unzip folder
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral

if [ -f ""${folder}".tar.gz" ]
then
    tar -zxvf ${folder}.tar.gz
fi


#get polymorphism based stats:
cd /home/pjohri1/ModelRejection/programs
python statistics_slidingwindow_pylibseq_general_reps.py -masking_status masked -winSize 2000 -stepSize 2000 -regionLen 99012 -input_folder /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral/${folder} -output_folder /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral_stats -output_prefix ${folder}


#get Divergence:
cd /home/pjohri1/ModelRejection/programs
if [ ! -f "/scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral_stats/"${folder}".divergence" ]
then
    python get_divergence_from_msprime.py -chrLen 49512 -input_folder /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral/${folder} -output_folder /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral_stats -output_prefix ${folder}
fi

#Remove folder
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/demo_neutral
rm -r ${folder}

