function ViewScaledLinearConcBData2
%VIEWSCALEDLINEARCONCBDATA2 Summary of this function goes here
%   Detailed explanation goes here


close all;
fontopt = {'FontSize',50,'FontWeight','bold'};
outvect = zeros(1,6); % SimTime(end), p, mean total(end), std total(end), mean prolif(end), mean level(end), std level (end),

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));

p = [1, 0.9:-0.05:0.6, 0.5, 0.4]; 

data = zeros(10, 10, 5); % col = p value, row = run, depth = time
avdata = zeros(1,10); % col = p value

for k = 1:10 % over each value of p
    
    for j = 1:10 % over each job
        
        % Load data from run j-1 in folder '0k'
        PopulationData = importdata(['ScaledLinearConcBData/0' num2str(k-1) '/testoutput/UtericBudSimulation_' num2str(j-1) '/results_from_time_0/celltypescount.dat']);
        
        for i = 1:5 % over each sample step
            
            % Find which row of data to sample from
            sample = find(PopulationData.data(:,1)  <= 100*i, 1, 'last');
            
            % Pull total cell count at this step
            data(k,j,i) = PopulationData.data(sample,3) + PopulationData.data(sample,2);
            
        end
    end
   
    for i = 1:5 % over each sample step
        
        % Find the average total population number
        avdata(1, k, i) = mean(data(k, :, i));
        
    end
    
        
end

% % figure;
% % plot(p, avdata, 'b', p, data, 'o');

for i = 1:5 % over each sample step
    
    % make a new figure and plot results
    figure;
    plot(p,avdata(1,:,i), 'b', p, data(:,:,i), 'o');
    title(['Total cell count for different parameter vals at t = ' num2str(100*i)]);
    xlabel('p'); ylabel('total cell counts');
    axis([0.4, 1.0, 0, 800]);
    
end

end

