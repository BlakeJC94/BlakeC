#!/bin/bash
#
# Script to illustrate running batch jobs and passing in arguments.
#
# 
# This script assumes that the following has been run successfully:
# scons co=1 b=GccOpt ts=projects/Ozzy/test/CellBasedComparison/TestMorphogenMonolayer.hpp


batch=${1:--1}; 


print_inputs () {
echo "    sim_time : " ${sim_time};
echo "    num_sims : " ${num_sims};
echo "    model : " ${model};
echo "    parameter : " ${parameter};
echo "    attachment_probability : " ${attachment_probability};
echo "    detachment_probability : " ${detachment_probability};
}


submit_job () {
if [ $1 -eq 0 ]
then
    echo "submit_job TEST"
elif [ $1 -eq 1 ]
then
    nice -20 /data/blakec/workspace/Chaste/projects/BlakeC/build/optimised/UtericBudSimulation/UtericBudSimulation_Sweeper_PaperRunner \
    -sim_time $sim_time \
    -num_sims $num_sims \
    -model $model \
    -parameter $parameter \
    -attachment_probability $attachment_probability \
    -detachment_probability $detachment_probability\
    > output/UtericBud_model_${model}_param_${parameter}_pa_${attachment_probability}_pd_${detachment_probability}_simtime_${sim_time}.txt 2>&1 &
else
    echo "wumbo"
fi
}


debug_deploy=0;


num_sims=20;
sim_time=600;
model=1;
parameter=0.25;
attachment_probability=0;
detachment_probability=0;

step_param_vec=($(seq 0.05 0.05 0.35))
linear_param_vec=($(seq 0.70 0.05 0.95))
ramp_param_vec=($(seq 0.20 0.10 0.90))

pa_vec=($(seq 0.10 0.10 1.00))
pd_vec=($(seq 0.10 0.10 1.00))

extra_param_vec=(0.4 0.45 0.5 0.6 0.65 1 0.1 1)


if [ $batch -eq 0 ]
# Batch 0 (9 threads): 
#   - Adhesion off
#   - Constant diff parameter (0.5) (1*20 runs, expect divergent and extinction, 600h)
#   - Step diff parameter (0.25) (1*20 runs, 600h)
#   - Step diff parameter 
#     - (0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35) (7*20=140 runs, 1000h)
then 

    echo "Batch : " ${batch};
    
    
    echo "  Constant diff parameter (0.5) (1*20 runs, 600h)";
    
    model=0;
    parameter=0.5;
    
    print_inputs;
    submit_job ${debug_deploy};
    
    echo "      Submitted!";
    
    
    echo "  Step diff parameter (0.25) (1*20 runs, 600h)";
    
    model=1;
    parameter=0.25;
    
    print_inputs;
    submit_job ${debug_deploy};
    
    echo "      Submitted!";
    
    
    echo "  Step diff parameter (0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35) (7*20=140 runs, 1000h)";
    
    sim_time=1000;
    model=1;
    
    for (( i=0 ; i<${#step_param_vec[*]} ; i++))
    do 
    
        parameter=${step_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
        
        echo "      Submitted!";
        
    done 
    
    
elif [ $batch -eq 1 ]
# Batch 1 (14 threads): 
#   - Adhesion off
#   - Linear diff parameter 
#     - (0.70, 0.75, 0.80, 0.85, 0.9, 0.95) (6*20=120 runs, 1000h)
#   - Ramp diff parameter 
#     -  (0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90) (8*20=160 runs, 1000h)
then 
    
    echo "Batch : " ${batch};
    
    
    
    echo "  Linear diff parameter (0.70, 0.75, 0.80, 0.85, 0.9, 0.95) (6*20=120 runs, 1000h)";
    
    sim_time=1000;
    model=2;
    
    for (( i=0 ; i<${#linear_param_vec[*]} ; i++))
    do 
    
        parameter=${linear_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done 
    
    
    echo "  Ramp diff parameter (0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90) (8*20=160 runs, 1000h)";
    
    sim_time=1000;
    model=3;
    
    for (( i=0 ; i<${#ramp_param_vec[*]} ; i++))
    do 
    
        parameter=${ramp_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done 


elif [ $batch -gt 1 ] && [ $batch -lt 12 ]
# Batch x, 2<=x<=11 (10 threads): 
#   - Ramp diff with par = 0.6
#   - Adhesion
#     - pa = 0.1*(x-1) and p_d in (0.1, …, 1) (10*20=200 runs, 600h)
then
    
    echo "Batch : " ${batch};
    
    
    echo "  Adhesion pa = 0.1*(batch-1) and p_d in (0.1, …, 1) (10*20=200 runs, 600h)";
    
    attachment_probability=${pa_vec[${batch}-2]};
    
    for (( i=0 ; i<${#pd_vec[*]} ; i++))
    do 
        detachment_probability=${pd_vec[$i]};
        
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done
    
    
elif [ $batch -eq 12 ]
# Batch 12 (8 threads): 
#   - Adhesion off
#   - Step diff parameter 
#     - (0.40, 0.45, 0.5) (3*20=140 runs, 1000h)
#   - Linear diff parameter 
#     - (0.6, 0.65, 1) (3*20=120 runs, 1000h)
#   - Ramp diff parameter 
#     - (0.1, 1) (2*20=160 runs, 1000h)
then
    
    echo "Batch : " ${batch};
    
    
    echo "  Step diff parameter (0.40, 0.45, 0.5) (3*20=140 runs, 1000h)";
    
    sim_time=1000;
    model=1;
    
    for (( i=0 ; i<3 ; i++))
    do 
    
        parameter=${extra_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done 
    
    
    echo "  Linear diff parameter (0.6, 0.65, 1) (3*20=160 runs, 1000h)";
    
    sim_time=1000;
    model=2;
    
    for (( i=3 ; i<6 ; i++))
    do 
    
        parameter=${extra_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done 
    
    
    echo "  Ramp diff parameter (0.1, 1) (2*20=160 runs, 1000h)";
    
    sim_time=1000;
    model=3;
    
    for (( i=6 ; i<8 ; i++))
    do 
    
        parameter=${extra_param_vec[$i]};
    
        print_inputs;
        submit_job ${debug_deploy};
    
        
        echo "      Submitted!";
        
    done 
    
    
else
    echo "Incorrect batch number, use int between 0 and 13.";
fi


echo "Jobs submitted";


