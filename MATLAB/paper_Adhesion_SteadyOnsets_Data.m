function paper_Adhesion_SteadyOnsets_Data
%NEEDS TO BE REVISED!!

close all;
addpath(genpath('functions/'));

ap_vec = [0:0.1:1];
dp_vec = [0.1:0.1:1];

DataDims = [length(ap_vec), length(dp_vec)];

% steadystateonset_cell = cell(DataDims);
% proportions_cell = cell(DataDims);
% steadystateval_cell = cell(DataDims);
% shapeslope_total_cell = cell(DataDims);
% shapeslope_prolif_cell = cell(DataDims);
% cap_height_cell = cell(DataDims);
% steadystate_flag_cell = cell(DataDims);


ssonsets = zeros(DataDims);
sscounts = zeros(DataDims);
proportions = zeros(DataDims);

for ap_index = 1:length(ap_vec)
    ap = ap_vec(ap_index);
    disp(['ap = ' num2str(ap)])
    
    testoutput_path = ['data/paper/adhesion/adhesion_pa_' num2str(ap) '_testoutput_dats'];
    
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
            
            data_path = [testoutput_path '/UtericBud_model_3_param_0.6_pa_' num2str(ap) '_pd_' num2str(dp) '_simtime_600_'];
            
            ssonsets(ap_index, dp_index) = totalcellsteadystate(data_path);
            [sscounts(ap_index, dp_index), proportions(ap_index, dp_index)] = totalcellsteadystatecount(data_path,1);
            
        end

    end
    
end

save('MAT/Adhesion_SteadyOnsets_paper.mat');
disp('Done!');

end
