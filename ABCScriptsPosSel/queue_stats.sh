#!/bin/bash

sim_start=11 #$1
sim_end=100 #$2 out of 290

declare -i simID=$sim_start
declare -i simEnd=$sim_end
simEnd=$(( ${simEnd} + 1 ))


while [ $simID -lt $simEnd ];
do
    echo "sim"$simID
    sbatch run_stats_exon50_100kb_slim_abc.sh $simID
    simID=$(( ${simID} + 1 ))
done
echo "Finished"

