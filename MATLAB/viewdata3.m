function viewdata3(total_jobs)
%% Load data

close all;
fontopt = {'FontSize',50,'FontWeight','bold'};

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));


% velocitydata = LoadNonConstantLengthData('cellvelocities.dat');
% agedata = LoadNonConstantLengthData('cellages.dat');

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

% todo: Average velocity in each partition element on x in last frame
% todo: Average data over multiple batches

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

velocitydata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% udata = velocitydata{end}(6:5:end);
% meanvdata = udata;

x = velocitydata{end}(3:5:end-3);
u = velocitydata{end}(5:5:end-1);

av_udata = zeros(1, 8);

for k=1:8
    indicies = (5*(k-1) <= x < 5*k);
    tmpdata = u .* indicies;
    av_udata(k) = tmpdata;
end

bar(av_udata)
    

scatter(x, u);
hold on;
plot(x,fit,'r');
plot(linspace(0,40), zeros(1,length(linspace(0,40))),'k:');
hold off;
axis([0, 40, -30, 30]);
title('horizontal velocity vs. horizontal position at end of simulation');
xlabel('x'); ylabel('u');



%% v vs x
% x = horizontal position
% v = velocity in y direction

% todo: Average velocity in each partition element on x in last frame
% todo: Average data over multiple batches

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

x = velocitydata{end}(3:5:end-3);
v = velocitydata{end}(6:5:end);
myfit = polyfit(x, v, 1);
fit = myfit(1)*x + myfit(2);

scatter(x, v);
hold on;
plot(x, fit,'r');
hold off;
axis([0, 40, -30, 30]);
title('vertical velocity vs. horizontal position at end of simulation');
xlabel('x'); ylabel('v');


%% age vs x

% todo: Average age in each partition element on x in last frame
% todo: Average data over multiple batches

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

agedata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');

x = agedata{end}(3:4:end-3);
age = agedata{end}(5:4:end-1);
myfit = polyfit(x, age, 1);
fit = myfit(1)*x + myfit(2);

scatter(x, age);
hold on;
plot(x, fit,'r');
plot(linspace(0,40), zeros(1,length(linspace(0,40))),'k:');
hold off;
axis([0, 40, 0, 300]);
title('cell age vs. horizontal position at end of simulation');
xlabel('x'); ylabel('age');

%% age vs y

% todo: Average age in each partition element on y in last frame
% todo: Average data over multiple batches

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

y = agedata{end}(4:4:end-2);
age = agedata{end}(5:4:end-1);
myfit = polyfit(y, age, 1);
fit = myfit(1)*y + myfit(2);

scatter(y, age);
hold on;
plot(y, fit,'r');
hold off;
axis([0, 10, 0, 300]);
title('cell age vs. vertical position at end of simulation');
xlabel('y'); ylabel('age');




end