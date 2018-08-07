# This bash script will copy each result folder and remove .vtu files, leaving the .dat 
#   files. The script is to be placed in the same directory as "testoutput", stores
#   everything in testoutput_dats in the same directory alongside "testoutput"

# Remove previous output tar if present

rm -r testoutput_dats
rm adhesionRate.tar




## Extract adhesionRate dats

pa_vec=($(seq 0.10 0.10 1.00));
pd_vec=($(seq 0.10 0.10 1.00));

# loop over attachment probabilities 
for (( i=1 ; i<${#pa_vec[*]} ; i++))
do
    pa=${pa_vec[$i]};
    echo "attach prob : " ${pa};
    
    # make dir testoutput_dats/
    mkdir testoutput_dats
    
    # loop over detachment probabilities 
    for (( j=0 ; j<${#pd_vec[*]} ; j++ ))
    do
        pd=${pd_vec[$j]};
        echo "  attach prob : " ${pa};
        
        # loop over simulations
        for (( sim=0 ; sim<20 ; sim++ ))
        do 
            echo "  sim : " ${sim};
        
            # copy whole result folder to dir testoutput_dats/
            cp -r testoutput/UtericBud_model_3_param_0.6_pa_${pa}_pd_${pd}_simtime_600_sim_${sim} testoutput_dats/
        
            # change dir to copied results in dir testoutput_dats/
            cd testoutput_dats/UtericBud_model_3_param_0.6_pa_${pa}_pd_${pd}_simtime_600_sim_${sim}results_from_time_0
        
            # remove all vtu files
            rm result*
        
            # reduce cellages.dat # 1000 - t=599.4
            sed -i.bak -e '1,1000d' cellages.dat
            rm cellages.dat.bak
            awk '!(NR % 20)' cellages.dat > n_cellages.dat
            rm cellages.dat
            mv n_cellages.dat cellages.dat
        
            # reduce cellvelocities.dat
            sed -i.bak -e '1,1000d' cellvelocities.dat
            rm cellvelocities.dat.bak
            awk '!(NR % 20)' cellvelocities.dat > n_cellvelocities.dat
            rm cellvelocities.dat
            mv n_cellvelocities.dat cellvelocities.dat
        
            # reduce cellstate.dat
            sed -i.bak -e '1,1000d' cellstate.dat
            rm cellstate.dat.bak
            awk '!(NR % 20)' cellstate.dat > n_cellstate.dat
            rm cellstate.dat
            mv n_cellstate.dat cellstate.dat
        
            cd ../../..
            
        done 
    
    done
    
    # create tar specific to pa value
    tar cf adhesionRate_pa_${pa}_testoutput_dats.tar testoutput_dats
    
    # clean folders
    rm -r testoutput_dats    
        
done

# bundle individual pa value tars in adhesionRate_dats.tar
tar cf adhesionRate_dats.tar adhesionRate_pa_*

# clean up tars
rm adhesionRate_pa_*


echo "done : adhesionRate_dats.tar";
        
        
        
        
