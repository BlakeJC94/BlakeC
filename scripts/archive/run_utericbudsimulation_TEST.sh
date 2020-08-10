#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp
#


num_sims=2;
sim_time=500;
model=1;
#parameter=0.6;
attachment_probability=0;
detachment_probability=0;


PARAMETER[0]="0.25"
#PARAMETER[1]="0.5"
#PARAMETER[2]="0.6"

for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	echo " Parameter " ${PARAMETER[$i]};
	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
	# ">" directs std::cout to the file.
	# "2>&1" directs std::cerr to the same place.
	# "&" on the end lets the script carry on and not wait until this has finished.
	#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	
	parameter=${PARAMETER[$i]}
	
	nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper_PaperRunner \
    -sim_time $sim_time \
    -num_sims $num_sims \
    -model $model \
    -parameter $parameter \
    -attachment_probability $attachment_probability \
    -detachment_probability $detachment_probability\
    > output/UtericBud_model_${model}_param_${parameter}_pa_${attachment_probability}_pd_${detachment_probability}_simtime_${sim_time}.txt 2>&1 &
	
done

echo "Jobs submitted"
