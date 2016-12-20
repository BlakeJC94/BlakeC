close all;
clear all;

total_jobs = 3;

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));

% To pull data from many simulations, loop over each simulation and use a 
% running average process to calculate the mean data
%   a_(n+1) = (n*a_(n) + x_(n+1))/(n+1), a_1 = x_1;

%% no. cells vs time
% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

% addpath(genpath('/home/blake/Workspace/Chaste/testoutput/TestUtericBudSimulation0/results_from_time_0/'));
% populationdata1 = LoadNonConstantLengthData('celltypes.dat');

% addpath(genpath('/home/blake/Workspace/Chaste/testoutput/TestUtericBudSimulation1/results_from_time_0/'));
% populationdata2 = LoadNonConstantLengthData('celltypes.dat');
% 
% addpath(genpath('/home/blake/Workspace/Chaste/testoutput/TestUtericBudSimulation2/results_from_time_0/'));
% populationdata3 = LoadNonConstantLengthData('celltypes2.dat');

addpath(genpath('testoutput/'));
populationdata{1} = LoadNonConstantLengthData('testoutput/UtericBudSimulation0/results_from_time_0/celltypes.dat');
populationdata{2} = LoadNonConstantLengthData('testoutput/UtericBudSimulation1/results_from_time_0/celltypes.dat');
populationdata{3} = LoadNonConstantLengthData('testoutput/UtericBudSimulation2/results_from_time_0/celltypes.dat');

populationdataAV = populationdata{1};
for k = 1:3
    for j = 1:populationdataAV{end}(1)
    populationdataAV{j+1} = (k*populationdataAV{j} + populationdata{k+1}{j})/(k+1);
    end
    
    
    
    
end


% populationdata_av = populationdata;
% for k = 1:total_jobs
%     for j = 2:populationdata{end}(1)
%         populationdata_av{j} = k*populationdata_av{j-1} ;
%         
%     end
%     
% end
