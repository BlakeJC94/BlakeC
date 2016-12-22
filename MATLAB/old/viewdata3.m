function viewdata3(total_jobs)
%% Add paths

close all;
fontopt = {'FontSize',50,'FontWeight','bold'};

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));

% To pull data from many simulations, loop over each simulation and use a 
% running average process to calculate the mean data
%   a_(n+1) = (n*a_(n) + x_(n+1))/(n+1), a_1 = x_1;

%% mean no. cells vs time
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

populationdata = importdata('testoutput/UtericBudSimulation_0/results_from_time_0/celltypes.dat');
meanpopulationdata = populationdata;

for k = 2:total_jobs
    populationdata = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/celltypes.dat']);
    meanpopulationdata = ((k-1)*meanpopulationdata + populationdata)./k;
end

simtime = 120*(meanpopulationdata(:,1)); 
diffcells = meanpopulationdata(:,4);
transitcells = meanpopulationdata(:,3);
totalcells = transitcells + diffcells;

plot(simtime, totalcells, 'k', simtime, diffcells, 'r',...
    simtime, transitcells, 'b');
legend('Total', 'Differentiated', 'Transit', 'Location', 'Best');
title('Number of cells in simulation');
xlabel('simulation time'); ylabel('no. of cells');


%% u vs x
% x = horizontal position
% u = velocity in x direction

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

bin_size = 2; % partition x into [0, b), [b, 2b), ..., [kb, (k+1)b), ...
max_x = 40;

velocitydata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
x = velocitydata{end}(3:5:end-3);
u = velocitydata{end}(5:5:end-1);
av_udata = barplotdatagen(x, u, bin_size, max_x);

meanvelocitydata = av_udata;

for k = 2:total_jobs
    velocitydata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
    x = velocitydata{end}(3:5:end-3);
    u = velocitydata{end}(5:5:end-1);
    av_udata = barplotdatagen(x, u, bin_size, max_x);
    
    meanvelocitydata = ((k-1)*meanvelocitydata + av_udata)./k;
end

bar(bin_size*(1:numel(meanvelocitydata)) - (bin_size/2), meanvelocitydata);
title('horizontal velocity vs. horizontal position at end of simulation');
xlabel('x'); ylabel('u');


%% v vs x
% x = horizontal position
% v = velocity in y direction

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

bin_size = 2; % partition x into [0, b), [b, 2b), ..., [kb, (k+1)b), ...
max_x = 40;

velocitydata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
x = velocitydata{end}(3:5:end-3);
v = velocitydata{end}(6:5:end);
av_udata = barplotdatagen(x, v, bin_size, max_x);

meanvelocitydata = av_udata;

for k = 2:total_jobs
    velocitydata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
    x = velocitydata{end}(3:5:end-3);
    v = velocitydata{end}(6:5:end);
    av_udata = barplotdatagen(x, v, bin_size, max_x);
    
    meanvelocitydata = ((k-1)*meanvelocitydata + av_udata)./k;
end

bar(bin_size*(1:numel(meanvelocitydata)) - (bin_size/2), meanvelocitydata);
title('vertical velocity vs. horizontal position at end of simulation');
xlabel('x'); ylabel('v');



%% age vs x

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

bin_size = 2; % partition x into [0, b), [b, 2b), ..., [kb, (k+1)b), ...
max_x = 40;

agedata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');
x = agedata{end}(3:4:end-3);
age = agedata{end}(5:4:end-1);
av_agedata = barplotdatagen(x, age, bin_size, max_x);

meanagedata = av_agedata;

for k = 2:total_jobs
    agedata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellages.dat']);
    x = agedata{end}(3:4:end-3);
    age = agedata{end}(5:4:end-1);
    av_agedata = barplotdatagen(x, age, bin_size, max_x);
    
    meanagedata = ((k-1)*meanagedata + av_agedata)./k;
end

bar(bin_size*(1:numel(meanagedata)) - (bin_size/2), meanagedata);
title('cell age vs. horizontal position at end of simulation');
xlabel('x'); ylabel('age');


%% age vs y

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

bin_size = 1; % partition x into [0, b), [b, 2b), ..., [kb, (k+1)b), ...
max_y = 10;

agedata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');
y = agedata{end}(4:4:end-2);
age = agedata{end}(5:4:end-1);
av_agedata = barplotdatagen(y, age, bin_size, max_y);

meanagedata = av_agedata;

for k = 2:total_jobs
    agedata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellages.dat']);
    y = agedata{end}(4:4:end-2);
    age = agedata{end}(5:4:end-1);
    av_agedata = barplotdatagen(y, age, bin_size, max_y);
    
    meanagedata = ((k-1)*meanagedata + av_agedata)./k;
end

bar(bin_size*(1:numel(meanagedata)) - (bin_size/2), meanagedata);
title('cell age vs. vertical position at end of simulation');
xlabel('y'); ylabel('age');


end



function av_udata = barplotdatagen(x, u, bin_size, max)

partitions_total = ceil(max/bin_size);
av_udata = zeros(1, partitions_total);
for k=1:partitions_total
    indicies = (bin_size*(k-1) <= x) .* (x < bin_size*k);
    tmpdata = u .* indicies;
    av_udata(k) = sum(tmpdata)/sum(indicies);
end

end