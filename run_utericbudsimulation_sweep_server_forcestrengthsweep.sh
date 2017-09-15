#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp



num_sims=20;
sim_time=800;
gforce_strength=0.5; # 0.5 0.67 0.83 %1% 1.17 1.33 1.5 1.67 1.83 2
#gforce_repulsion_strength=0.1; # 1.25 1.67 2.08 %2.5% 2.92 3.33 3.75 4.17 4.58 5
gforce_repulsion_distance=1.5;

PARAMETER[0]="1.25"
PARAMETER[1]="1.67"
PARAMETER[2]="2.08"
PARAMETER[3]="2.92"
PARAMETER[4]="3.33"
PARAMETER[5]="3.75"
PARAMETER[6]="4.17"
PARAMETER[7]="4.58"
PARAMETER[8]="5"

echo "gforce_strength " ${gforce_strength};

for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	#echo " attachment_probability " ${PARAMETER[$i]};
	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
	# ">" directs std::cout to the file.
	# "2>&1" directs std::cerr to the same place.
	# "&" on the end lets the script carry on and not wait until this has finished.
	#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	
	gforce_repulsion_strength=${PARAMETER[$i]};
	
	echo " gforce_repulsion_strength " ${gforce_repulsion_strength};
	
	nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper6Runner \
	-sim_time $sim_time \
	-num_sims $num_sims \
	-gforce_strength $gforce_strength \
	-gforce_repulsion_strength $gforce_repulsion_strength \
	-gforce_repulsion_distance $gforce_repulsion_distance \
	> output/SimulationRun_FA_${gforce_strength}_FR_${gforce_repulsion_strength}_HR_${gforce_repulsion_distance}_Output.txt 2>&1 &
	
done

echo "Jobs submitted"



