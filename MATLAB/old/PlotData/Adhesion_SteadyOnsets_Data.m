function Adhesion_SteadyOnsets_Data

close all;

addpath(genpath('functions/'));

ap_vec = [0:0.1:1];
dp_vec = [0.1:0.1:1];

DataDims = [length(ap_vec), length(dp_vec)];

ssonsets = zeros(DataDims);
sscounts = zeros(DataDims);
proportions = zeros(DataDims);

for ap_index = 1:length(ap_vec)
    ap = ap_vec(ap_index);
    disp(['ap = ' num2str(ap)])
    
    testoutput_path = ['data/Adhesion/AP_' num2str(ap) '_testoutput_dats'];
    
    for dp_index = 1:length(dp_vec)
        
        dp = dp_vec(dp_index);
        
        if ((ap >= 0.5) && (dp <= 0.1)) || ((ap >= 0.9) && (dp <= 0.2))
            ssonsets(ap_index, dp_index) = NaN;
            sscounts(ap_index, dp_index) = NaN;
            proportions(ap_index, dp_index) = NaN;
        else
            if ap == 0
                dp = 0;
            end
            
            disp(['    dp = ' num2str(dp)])
            
            data_path = [testoutput_path '/UtericBudSimulation_ap_' num2str(ap) '_dp_' num2str(dp) '_' ];
            
            ssonsets(ap_index, dp_index) = totalcellsteadystate(data_path);
            [sscounts(ap_index, dp_index), proportions(ap_index, dp_index)] = totalcellsteadystatecount(data_path,1);
            
        end

    end
    
end

save('MAT/Adhesion_SteadyOnsets.mat');
disp('Done!');

end




