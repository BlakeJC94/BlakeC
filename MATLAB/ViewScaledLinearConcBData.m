function ViewScaledLinearConcBData
%VIEWSCALEDLINEARCONCBDATA Summary of this function goes here
%   Detailed explanation goes here


close all;
fontopt = {'FontSize',50,'FontWeight','bold'};
outvect = zeros(1,6); % SimTime(end), p, mean total(end), std total(end), mean prolif(end), mean level(end), std level (end),
outvect(1,2) = 0.65;


addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));


p = [1, 0.9:-0.05:0.6, 0.5, 0.4];

data = zeros(10,10); % col = p value, row = run
avdata = zeros(1,10); % col = p value

for k = 1:10 % over each value of p
    
    for j = 1:10 % over each job
        
        % Pull the individual final pop. counts at the end of each simualtion
        PopulationData = importdata(['ScaledLinearConcBData/0' num2str(k-1) '/testoutput/UtericBudSimulation_' num2str(j-1) '/results_from_time_0/celltypescount.dat']);
        
        data(k,j) = PopulationData.data(end,3) + PopulationData.data(end,2);
       
    end
   
    % Find the average total population number
    avdata(1,k) = mean(data(k,:));
    
end


plot(p,avdata);


end

