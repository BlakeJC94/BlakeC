function Affinity_Data

close all;
addpath(genpath('functions/'));

p_cell = cell(1,3);
p_cell{1} = [0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]; % model 2: ramp
p_cell{2} = [0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]; % model 3: linear
p_cell{3} = [0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]; % model 4: step

steadystateonset_cell = cell(1,3);
proportions_cell = cell(1,3);
steadystateval_cell = cell(1,3);
shapeslope_total_cell = cell(1,3);
shapeslope_prolif_cell = cell(1,3);
cap_height_cell = cell(1,3);
steadystate_flag_cell = cell(1,3);

for model = 2:4
    disp(['Model : ' num2str(model)]);
    
    p = p_cell{model-1};
    
    testoutput_path = ['data/AffinityB/MODEL_' num2str(model) '_testoutput_dats'];
    
    steadystateonset = zeros(length(p),1);
    proportions = zeros(length(p),1);
    steadystateval = zeros(length(p),1);
    shapeslope_total = zeros(length(p),1);
    shapeslope_prolif = zeros(length(p),1);
    cap_height = zeros(length(p),1);
    steadystate_flag = zeros(length(p),1);
    
    for k = 1:length(p) % over each value of p
        disp(['Paramter = ' num2str(p(k))])
        parameter = p(k);
        
        data_path = [testoutput_path '/UtericBudSimulation_concbmodel_' num2str(model) '_parameter_' num2str(parameter) '_'];
         
        MeanPopulationData = meanscellsvstime(data_path);
        
        
        if length(MeanPopulationData(:,3)) < 1656 % If simulation stopped due to >1000 cells,
            steadystate_flag(k) = 0;
            
            steadystateonset(k) = 1000;
            [~, proportions(k)] = totalcellsteadystatecount(data_path,5);
            steadystateval(k) = 1000;
        else
            steadystate_flag(k) = 1;
            
            steadystateonset(k) = totalcellsteadystate(data_path);   
            [steadystateval(k), proportions(k)] = totalcellsteadystatecount(data_path,20);
        end
           
        
        if steadystateonset(k) > 800 % If cells <1000, but onset > 800
            steadystate_flag(k) = 0;
            
            shapeslope_total(k) = NaN;
            shapeslope_prolif(k) = NaN;
        else 
            steadystate_flag(k) = 1;
            
            shapeslope_total(k)  = steadystateshape(data_path, 0);
            shapeslope_prolif(k) = steadystateshape(data_path, 1);
            cap_height(k) = capheight(data_path, 0);
        end
    end
    
    steadystateonset_cell{model-1} = steadystateonset;
    proportions_cell{model-1} = proportions;
    steadystateval_cell{model-1} = steadystateval;
    shapeslope_total_cell{model-1} = shapeslope_total;
    shapeslope_prolif_cell{model-1} = shapeslope_prolif;
    steadystate_flag_cell{model-1} = steadystate_flag;
    cap_height_cell{model-1} = cap_height;
end

save(['MAT/Affinity.mat']);
disp('Done!');

end