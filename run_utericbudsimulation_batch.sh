#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestCylindricalCrypt.hpp
#

num_sims=3;
sim_time=50;

CONC_B_PARAMETER[0]="0.9"
CONC_B_PARAMETER[1]="0.8"
CONC_B_PARAMETER[2]="0.7"

for (( i=0 ; i<${num_sims} ; i++))
do
    echo "Run " $i;
    for (( j=0 ; j<${#CONC_B_PARAMETER[*]} ; j++))
    do
    	echo "  Conc B Parameter " ${CONC_B_PARAMETER[$j]};
    	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
    	# ">" directs std::cout to the file.
    	# "2>&1" directs std::cerr to the same place.
    	# "&" on the end lets the script carry on and not wait until this has finished.
    	nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_ConcBSweeperRunner -sim_index $i -sim_time $sim_time -conc_b_parameter ${CONC_B_PARAMETER[$j]} > output/SimulationRun_${CONC_B_PARAMETER[$j]}_${i}_Output.txt 2>&1 &
    done
done

echo "Jobs submitted"
