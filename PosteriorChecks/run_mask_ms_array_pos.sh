#!/bin/bash
#SBATCH -n 1                        # number of cores
#SBATCH -t 0-1:00                  # wall time (D-HH:MM)
#SBATCH -o /home/pjohri1/LOGFILES/mask_ms_files_exon50_%j.out
#SBATCH -e /home/pjohri1/LOGFILES/mask_ms_files_exon50_%j.err
#SBATCH --mail-type=ALL             # Send a notification when the job starts, stops, or fails
#SBATCH --mail-user=pjohri1@asu.edu # send-to address


folder="eqm_pos_selection"

declare -i scenarioID=$1

#unzip folder:
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
tar -zxvf scenario${simID}.tar.gz

#mask the genome:
cd /home/pjohri1/ModelRejection/ABCScriptsPosSel
repID=1
while [ $repID -lt 101 ];
do
	python /home/pjohri1/ModelRejection/programs/mask_exonic_regions_v2.py /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}/scenario${scenarioID} ${repID} exon50 slim
	repID=$(( ${repID} + 1 ))
done

#Zip the folder:
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
tar -zcvf scenario${scenarioID}.tar.gz scenario${scenarioID}

#Remove the folder
cd /scratch/pjohri1/ModelRejection/PosteriorChecks/${folder}
rm -r scenario${scenarioID}

