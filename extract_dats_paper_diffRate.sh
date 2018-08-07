# This bash script will copy each result folder and remove .vtu files, leaving the .dat 
#   files. The script is to be placed in the same directory as "testoutput", stores
#   everything in testoutput_dats in the same directory alongside "testoutput"

# Remove previous output tar if present

rm -r testoutput_dats
rm diffRate.tar




## Extract diffRate dats

step_param_vec=($(seq 0.05 0.05 0.35));
linear_param_vec=($(seq 0.70 0.05 0.95));
ramp_param_vec=($(seq 0.20 0.10 0.90));

# loop over models (1 - step, 2 - linear, 3 - ramp)
for (( model=1 ; model<4 ; model++))
do
    echo "model : " ${model};
    
    # load param vec for specific model
    if [ $model -eq 1 ]
    then
        param_vec=${step_param_vec};
    elif [ $model -eq 2 ]
    then
        param_vec=${linear_param_vec};
    elif [ $model -eq 3 ]
        param_vec=${ramp_param_vec};
    else 
        echo "Invalid model number"
    fi 
    
    # make dir testoutput_dats/
    mkdir testoutput_dats
    
    # loop over parameter values 
    for (( index=0 ; index<${#param_vec[*]} ; index++ ))
    do
        echo "  parameter" ${param_vec[index]};
        
        # loop over simulations
        for (( sim=0 ; sim<20 ; sim++ ))
        do 
            echo "  sim : " ${sim};
        
            # copy whole result folder to dir testoutput_dats/
            cp -r testoutput/UtericBud_model_${model}_param_${param}_pa_0_pd_0_simtime_1000_sim_${sim} testoutput_dats/
        
            # change dir to copied results in dir testoutput_dats/
            cd testoutput_dats/UtericBud_model_${model}_param_${param}_pa_0_pd_0_simtime_1000_sim_${sim}/results_from_time_0
        
            # remove all vtu files
            rm result*
        
            # reduce cellages.dat # 1666 - t=999
            sed -i.bak -e '1,1666d' cellages.dat
            rm cellages.dat.bak
            awk '!(NR % 20)' cellages.dat > n_cellages.dat
            rm cellages.dat
            mv n_cellages.dat cellages.dat
        
            # reduce cellvelocities.dat
            sed -i.bak -e '1,1666d' cellvelocities.dat
            rm cellvelocities.dat.bak
            awk '!(NR % 20)' cellvelocities.dat > n_cellvelocities.dat
            rm cellvelocities.dat
            mv n_cellvelocities.dat cellvelocities.dat
        
            # reduce cellstate.dat
            sed -i.bak -e '1,1666d' cellstate.dat
            rm cellstate.dat.bak
            awk '!(NR % 20)' cellstate.dat > n_cellstate.dat
            rm cellstate.dat
            mv n_cellstate.dat cellstate.dat
        
            cd ../../..
            
        done 
    
    done
    
    # create tar specific to model
    tar cf diffRate_model_${model}_testoutput_dats.tar testoutput_dats
    
    # clean folders
    rm -r testoutput_dats    
        
done

# bundle individual model tars in diffRate_dats.tar
tar cf diffRate_dats.tar diffRate_model_*

# clean up tars
rm diffRate_model_*


echo "done : diffRate_dats.tar";
        
        
        
        
