close all;
clear all;

total_jobs = 5;

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));

% To pull data from many simulations, loop over each simulation and use a 
% running average process to calculate the mean data
%   a_(n+1) = (n*a_(n) + x_(n+1))/(n+1), a_1 = x_1;

%% no. cells vs time

% populationdata = importdata('testoutput/UtericBudSimulation_0/results_from_time_0/celltypes.dat');
% meanpopulationdata = populationdata;
% 
% for k = 2:total_jobs
%     populationdata = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/celltypes.dat']);
%     meanpopulationdata = ((k-1)*meanpopulationdata + populationdata)./k;
% end
% 
% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% simtime = 120*(meanpopulationdata(:,1)); 
% diffcells = meanpopulationdata(:,4);
% transitcells = meanpopulationdata(:,3);
% totalcells = transitcells + diffcells;
% 
% plot(simtime, totalcells, 'k', simtime, diffcells, 'r',...
%     simtime, transitcells, 'b');
% legend('Total', 'Differentiated', 'Transit', 'Location', 'Best');
% title('Number of cells in simulation');
% xlabel('simulation time'); ylabel('no. of cells');


%% udata

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% velocitydata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% 
% 
% bin_size = 2; % partition x into [0, b), [b, 2b), ..., [kb, (k+1)b), ...
% 
% x = velocitydata{end}(3:5:end-3);
% u = velocitydata{end}(5:5:end-1);
% 
% av_udata = barplotdatagen(x, u, bin_size);
% 
% bar(bin_size*(1:numel(av_udata)) - (bin_size/2), av_udata);
% title('horizontal velocity vs. horizontal position at end of simulation');
% xlabel('x'); ylabel('u');
% 
% 
% 
% % function av_udata = barplotdatagen(x, u, bin_size)
% % 
% % partitions_total = ceil(40/bin_size);
% % av_udata = zeros(1, partitions_total);
% % for k=1:partitions_total
% %     indicies = (bin_size*(k-1) <= x) .* (x < bin_size*k);
% %     tmpdata = u .* indicies;
% %     av_udata(k) = sum(tmpdata)/sum(indicies);
% % end
% % 
% % end





