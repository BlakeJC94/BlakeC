#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp



num_sims=20;
sim_time=500;
attachment_probability=0;
#detachment_probability=0.1;
#detachment_probability=0.2;
#detachment_probability=0.3;
#detachment_probability=0.4;
#detachment_probability=0.5;
#detachment_probability=0.6;
#detachment_probability=0.7;
#detachment_probability=0.8;
detachment_probability=0.9;
#detachment_probability=1;

# Cycle AP for fixed DP
# todo: run odd DPs.

PARAMETER[0]="0.1"
PARAMETER[1]="0.2"
PARAMETER[2]="0.3"
PARAMETER[3]="0.4"
PARAMETER[4]="0.5"
PARAMETER[5]="0.6"
PARAMETER[6]="0.7"
PARAMETER[7]="0.8"
PARAMETER[8]="0.9"
PARAMETER[9]="1.0"

echo "detachment_probability " ${detachment_probability};

for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	#echo " attachment_probability " ${PARAMETER[$i]};
	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
	# ">" directs std::cout to the file.
	# "2>&1" directs std::cerr to the same place.
	# "&" on the end lets the script carry on and not wait until this has finished.
	#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	
	attachment_probability=${PARAMETER[$i]};
	
	echo " attachment_probability " ${attachment_probability};
	
	nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper4Runner \
	-sim_time $sim_time \
	-num_sims $num_sims \
	-attachment_probability $attachment_probability \
	-detachment_probability $detachment_probability \
	> output/SimulationRun_AP_${attachment_probability}_DP_${detachment_probability}_Output.txt 2>&1 &
	
done

echo "Jobs submitted"



