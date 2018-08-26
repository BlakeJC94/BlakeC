function paper_Adhesion_SteadyShapes_Data

close all;

addpath(genpath('functions/'));

ap_vec = 0:0.1:1;
dp_vec = 0.1:0.1:1;

DataDims = [length(ap_vec), length(dp_vec)];

shapetotal = zeros(DataDims);
shapeprolif = zeros(DataDims);
capheights = zeros(DataDims);

for ap_index = 1:length(ap_vec)
    ap = ap_vec(ap_index);
    disp(['ap = ' num2str(ap)])
    
    testoutput_path = ['data/paper/adhesion/adhesion_pa_' num2str(ap) '_testoutput_dats'];
    
    for dp_index = 1:length(dp_vec)
        
        dp = dp_vec(dp_index);
        
        if ((ap >= 0.5) && (dp <= 0.1)) || ((ap >= 0.9) && (dp <= 0.2))
            shapetotal(ap_index, dp_index) = NaN;
            shapeprolif(ap_index, dp_index) = NaN;
            capheights(ap_index, dp_index) = NaN;
        elseif ap == 0
            dp = 0;
            disp(['    dp = ' num2str(dp)])
            
            data_path = [testoutput_path '/UtericBud_model_3_param_0.6_pa_' num2str(ap) '_pd_' num2str(dp) '_simtime_600_'];
            
            if dp_index == 1
                shapetotal(ap_index, :) = steadystateshape(data_path, 0);
                shapeprolif(ap_index, :) = steadystateshape(data_path, 1);
                capheights(ap_index, :) = capheight(data_path);
            end

        else            
            disp(['    dp = ' num2str(dp)])
            
            data_path = [testoutput_path '/UtericBud_model_3_param_0.6_pa_' num2str(ap) '_pd_' num2str(dp) '_simtime_600_'];
            
            shapetotal(ap_index, dp_index) = steadystateshape(data_path, 0);
            shapeprolif(ap_index, dp_index) = steadystateshape(data_path, 1);
            capheights(ap_index, dp_index) = capheight(data_path);
            
        end

    end
    
    

end

save('MAT/Adhesion_SteadyShapes_paper.mat');
disp('Done!');

end

