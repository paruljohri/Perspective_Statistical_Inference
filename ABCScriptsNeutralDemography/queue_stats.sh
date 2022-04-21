#!/bin/bash

sim_start=901 #$1
sim_end=1000 #$2

declare -i simID=$sim_start
declare -i simEnd=$sim_end
simEnd=$(( ${simEnd} + 1 ))


while [ $simID -lt $simEnd ];
do
    echo "sim"$simID
    sbatch run_stats_exon50_100kb_msprime_abc.sh $simID
    simID=$(( ${simID} + 1 ))
done
echo "Finished"

