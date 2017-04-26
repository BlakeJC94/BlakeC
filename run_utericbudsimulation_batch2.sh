#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestCylindricalCrypt.hpp
#

num_sims=20;
sim_time=500;

PARAMETER[0]="0.2"
PARAMETER[1]="0.25"
PARAMETER[2]="0.3"

for (( i=0 ; i<${num_sims} ; i++))
do
    echo "Run " $i;
    for (( j=0 ; j<${#PARAMETER[*]} ; j++))
    do
    	echo "  Parameter " ${PARAMETER[$j]};
    	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
    	# ">" directs std::cout to the file.
    	# "2>&1" directs std::cerr to the same place.
    	# "&" on the end lets the script carry on and not wait until this has finished.
    	nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_SweeperRunner2 -sim_index $i -sim_time $sim_time -parameter ${PARAMETER[$j]} > output/SimulationRun_${PARAMETER[$j]}_${i}_Output.txt 2>&1 &
    done
done

echo "Jobs submitted"
