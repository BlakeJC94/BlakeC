#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp



num_sims=20;
sim_time=1000;
conc_b_model=2; 

echo "conc_b_model " ${conc_b_model};

if [ $conc_b_model -eq 2 ]
then 

PARAMETER[0]="0.3"
PARAMETER[1]="0.4"
PARAMETER[2]="0.5"
PARAMETER[3]="0.6"
PARAMETER[4]="0.7"
PARAMETER[5]="0.8"
PARAMETER[6]="0.9"
PARAMETER[7]="1"

elif [ $conc_b_model -eq 3 ]

PARAMETER[0]="0.4"
PARAMETER[1]="0.5"
PARAMETER[2]="0.6"
PARAMETER[3]="0.65"
PARAMETER[4]="0.7"
PARAMETER[5]="0.75"
PARAMETER[6]="0.8"
PARAMETER[7]="0.85"
PARAMETER[8]="0.9"
PARAMETER[9]="0.95"
PARAMETER[10]="1"

elif [ $conc_b_model -eq 4 ]

PARAMETER[0]="0.1"
PARAMETER[1]="0.15"
PARAMETER[2]="0.2"
PARAMETER[3]="0.25"
PARAMETER[4]="0.3"
PARAMETER[5]="0.35"
PARAMETER[6]="0.4"
PARAMETER[7]="0.45"
PARAMETER[8]="0.5"

fi


for (( i=0 ; i<${#PARAMETER[*]} ; i++))
do
	#echo " attachment_probability " ${PARAMETER[$i]};
	# NB "nice -20" gives the jobs low priority (good if they are going to dominate the server and no slower if nothing else is going on)
	# ">" directs std::cout to the file.
	# "2>&1" directs std::cerr to the same place.
	# "&" on the end lets the script carry on and not wait until this has finished.
	#nice -20 /home/blake/Chaste/projects/BlakeC/build/optimised/Week4Tasks/TCellSimulationTask4Runner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	#nice -20 /home/blake/Workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulationRunner -sim_index $i > output/SimulationRun_${i}_Output.txt 2>&1 &
	
	conc_b_parameter=${PARAMETER[$i]};
	
	echo " conc_b_parameter " ${conc_b_parameter};
	
	nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper7Runner \
	-sim_time $sim_time \
	-num_sims $num_sims \
	-conc_b_model $conc_b_model \
	-conc_b_parameter $conc_b_parameter \
	> output/SimulationRun_ConcBModel_${conc_b_model}_Param_${conc_b_parameter}_Output.txt 2>&1 &
	
done

echo "Jobs submitted"



