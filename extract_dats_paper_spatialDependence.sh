# This bash script will copy each result folder and remove .vtu files, leaving the .dat 
#   files. The script is to be placed in the same directory as "testoutput", stores
#   everything in testoutput_dats in the same directory alongside "testoutput"

# Remove previous output tar if present

rm -r testoutput_dats
rm spatialDependence_dats.tar




## Extract spatialDependence dats

param_vec=(0.5 0.25);

# loop over models (0 - const, 1 - step)
for (( model=0 ; model<2 ; model++ ))
do 

    # select param (0.5 for const, 0.25 for step)
    param=${param_vec[$model]};
    
    echo "model : " ${model};
    echo "param : " ${param};
    
    # make dir testoutput_dats/
    mkdir testoutput_dats
    
    
    # loop over simulations
    for (( sim=0 ; sim<20 ; sim++ ))
    do 
        echo "  sim : " ${sim};
        
        # copy whole result folder to dir testoutput_dats/
        cp -r testoutput/UtericBud_model_${model}_param_${param}_pa_0_pd_0_simtime_600_sim_${sim} testoutput_dats/
        
        # change dir to copied results in dir testoutput_dats/
        cd testoutput_dats/UtericBud_model_${model}_param_${param}_pa_0_pd_0_simtime_600_sim_${sim}/results_from_time_0
        
        # remove all vtu files and unused dat files
        rm result*
        rm attachmentsduration.dat
        rm cellages.dat
        rm divisions.dat
        
        # reduce cellages.dat # 1001 - t=600
        #sed -i.bak -e '1,1000d' cellages.dat
        #rm cellages.dat.bak
        #awk '!(NR % 20)' cellages.dat > n_cellages.dat
        #rm cellages.dat
        #mv n_cellages.dat cellages.dat
        
        # reduce cellvelocities.dat to last 20 sample points spaced 12 hrs apart
        sed -i.bak -e '1,601d' cellvelocities.dat
        rm cellvelocities.dat.bak
        awk '!(NR % 20)' cellvelocities.dat > n_cellvelocities.dat
        rm cellvelocities.dat
        mv n_cellvelocities.dat cellvelocities.dat
        
        # reduce cellstate.dat to last 20 sample points spaced 12 hrs apart
        sed -i.bak -e '1,601d' cellstate.dat
        rm cellstate.dat.bak
        awk '!(NR % 20)' cellstate.dat > n_cellstate.dat
        rm cellstate.dat
        mv n_cellstate.dat cellstate.dat
        
        cd ../../..
        
    done

    # create tar specific to model
    tar cf spatialDependence_model_${model}_testoutput_dats.tar testoutput_dats
    
    # clean folders
    rm -r testoutput_dats
    
done 

# bundle individual model tars in spatialDependence_dats.tar
tar cf spatialDependence_dats.tar spatialDependence_model_*

# clean up tars
rm spatialDependence_model_*


echo "done : spatialDependence_dats.tar";



    
