#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp
#
# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
# ">" directs std::cout to the file.
# "2>&1" directs std::cerr to the same place.
# "&" on the end lets the script carry on and not wait until this has finished.
#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &


num_sims=20;
sim_time=500;
attachment_probability=0;
detachment_probability=0;

PARAMETER[0]="0.5"
#PARAMETER[1]="0.5"
#PARAMETER[2]="0.6"

for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	echo " Parameter " ${PARAMETER[$i]};

	
	
	
	nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper_constRunner \
	-sim_time $sim_time \
	-num_sims $num_sims \
	> output/SimulationRun_const_0dot5_Output.txt 2>&1 &
	
done

echo "Jobs submitted"
