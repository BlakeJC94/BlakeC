function Affinity_ShowData(model, parameter)
% model: 2 (ramp), 3 (linear), 4 (step)
% paramters: 
%    2: 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
%    3: 0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1
%    4: 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5

close all;
testoutput_path = ['data/AffinityB/MODEL_' num2str(model) '_testoutput_dats'];
data_path = [testoutput_path '/UtericBudSimulation_concbmodel_' num2str(model) '_parameter_' num2str(parameter) '_' ];

disp(['Stats for (model,paramter) : (' num2str(model) ', ' num2str(parameter) ')']);
ShowData(data_path)


end
