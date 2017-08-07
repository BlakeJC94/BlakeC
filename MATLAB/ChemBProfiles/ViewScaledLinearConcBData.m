function ViewScaledLinearConcBData(model)
%VIEWSCALEDLINEARCONCBDATA Summary of this function goes here
%   Detailed explanation goes here


close all;

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));

testoutput_path = ['/home/blake/Documents/Saved Simulation Data' ...
    '/20170801/0' num2str(model) '_testoutput_dats'];

if model == 2 % model 2: ramp
    p = [0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
elseif model == 3 % model 3: linear
    p = [0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.85 0.9 1];
elseif model == 4 % model 4: step
    p = [0.05 0.1 0.2 0.3 0.35 0.4 0.45 0.5];
end

D = dir([testoutput_path '/UtericBudSimulation_Sweep_' num2str(p(1)) 'model' num2str(model) '*']);
TotalJobs = length(D(:));

data = zeros(length(p), 20, 5); % col = p value, row = run, depth = time
avgdata = zeros(length(p), 5); % row = p value, col = time
sdvdata = zeros(length(p), 5); % row = p value, col = time
steadystateav = zeros(length(p),1);
proportions = zeros(length(p),1);

for k = 1:length(p) % over each value of p
    disp(['Paramter = ' num2str(p(k))])
    parameter = p(k);
    
    PopulationDataSet = cell(1,TotalJobs);
    
    for j = 1:TotalJobs % over each job
        disp(['    sim = ' num2str(j-1)]) %%D%%
        run = j-1;
        
        % Load data from run j-1 in folder '0k'
        data_path = [testoutput_path '/UtericBudSimulation_Sweep_' num2str(parameter) 'model' num2str(model)];
        PopulationData = importdata([data_path '_sim_' num2str(run) '/results_from_time_0/celltypescount.dat']);
        
        
        PopulationDataSet{j} = PopulationData.data;
        
        for i = 1:9 % over each sample step
            
            % Find which row of data to sample from
            sample = find(PopulationData.data(:,1)  <= 100*i, 1, 'last');
            
            % Pull total cell count at this step
            data(k,j,i) = PopulationData.data(sample,3) + PopulationData.data(sample,2);
            
        end
        data(k,j,10) = PopulationData.data(end,3) + PopulationData.data(end,2);
        
    end
    
    steadystateav(k) = totalcellsteadystate(PopulationDataSet); 
    MeanPopulationData = meanscellsvstime(PopulationDataSet);
    proportions(k) = MeanPopulationData(end,2)/(MeanPopulationData(end,3) + MeanPopulationData(end,2)); %prolif/total
   
    for i = 1:10 % over each sample step
        
        % Find the average total population number
        avgdata(k, i) = mean(data(k, :, i));
        
        % Find the stadrand deviation of the total population number
        sdvdata(k, i) = std(data(k, :, i));
        
    end
    
        
end

% % figure;
% % plot(p, avdata, 'b', p, data, 'o');

for i = 1:10 % over each sample step
    
    % make a new figure and plot results
    figure;
    plot(p,avgdata(:,i), 'b', ...
        p, avgdata(:,i) + sdvdata(:,i), 'b--', ...
        p, avgdata(:,i) - sdvdata(:,i), 'b--', ...
        p, data(:,:,i), 'o');
    title(['Total cell count for different parameter vals at t = ' num2str(100*i)]);
    xlabel('\alpha'); ylabel('total cell counts');
    axis([min(p), max(p), 0, 800]);
    
end

figure;
plot(p, steadystateav, 'ko--')
title(['Total cell count steady state onset time']);
xlabel('\alpha'); ylabel('Steady State');
axis([min(p), max(p), 0, 1000]);

figure;
plot(p, proportions, 'bo--')
title(['Prolif cells : Total Cells']);
xlabel('\alpha'); ylabel('ratio');
axis([min(p), max(p), 0, 1]);

end
