#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-1:00                  # wall time (D-HH:MM)
#SBATCH -a 1-10%10
#SBATCH -s
#SBATCH -o /home/pjohri/LOGFILES/mask_ms_files_exon50_%A_rep%a.out
#SBATCH -e /home/pjohri/LOGFILES/mask_ms_files_exon50_%A_rep%a.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address

#set the environment

#Set path to working directory
cd /home/pjohri/ModelRejection/ABCScripts
folder="eqm_100kb_pos_selection"

declare -i simID=280+$SLURM_ARRAY_TASK_ID

#mask the genome:
repID=1
while [ $repID -lt 101 ];
do
        python mask_exonic_regions_v2.py /home/pjohri/ModelRejection/ABCSims/${folder}/sim${simID} ${repID}
        repID=$(( ${repID} + 1 ))
done

#Zip the folder:
cd /home/pjohri/ModelRejection/ABCSims/${folder}
tar -zcvf sim${simID}.tar.gz sim${simID}

#Remove the folder
cd /home/pjohri/ModelRejection/ABCSims/${folder}
rm -r sim${simID}


