#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp



num_sims=20;
sim_time=500;
attachment_probability=0.5;
detachment_probability=0.5;


PARAMETER[0]="1.0"
PARAMETER[1]="1.3"
PARAMETER[2]="1.5"
PARAMETER[3]="1.7"
PARAMETER[4]="2.0"
PARAMETER[5]="2.3"
PARAMETER[6]="2.5"
PARAMETER[7]="2.7"
PARAMETER[8]="3.0"



for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	#echo " attachment_probability " ${PARAMETER[$i]};
	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
	# ">" directs std::cout to the file.
	# "2>&1" directs std::cerr to the same place.
	# "&" on the end lets the script carry on and not wait until this has finished.
	#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	
	attachment_height=${PARAMETER[$i]};
	
	echo " attachment_height " ${attachment_probability};
	
	nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper5Runner \
	-sim_time $sim_time \
	-num_sims $num_sims \
	-attachment_probability $attachment_probability \
	-detachment_probability $detachment_probability \
	-attachment_height $attachment_height \
	> output/SimulationRun_AH_${attachment_height}_Output.txt 2>&1 &
	
done

echo "Jobs submitted"



