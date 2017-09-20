#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp



num_sims=20;
sim_time=800;
gforce_strength=1; # 0.5 0.67 0.83 %1% 1.17 1.33 1.5 1.67 1.83 2
gforce_repulsion_strength=2.5; # 1.25 1.67 2.08 %2.5% 2.92 3.33 3.75 4.17 4.58 5
gforce_repulsion_distance=1.5;



echo "gforce_repulsion_strength " ${gforce_repulsion_strength};	
echo " gforce_strength " ${gforce_strength};
	
echo " RADFORCE1 " ${gforce_strength};
	
nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_SweeperRadForce1Runner \
-sim_time $sim_time \
-num_sims $num_sims \
-gforce_strength $gforce_strength \
-gforce_repulsion_strength $gforce_repulsion_strength \
-gforce_repulsion_distance $gforce_repulsion_distance \
> output/SimulationRun_RadForce1_Output.txt 2>&1 &


echo "Jobs submitted"



