function viewdata2(anim)
%% Load data
if (nargin == 0)
    anim = 0;
elseif (anim ~= 1)
    anim = 0;
end

close all;
fontopt = {'FontSize',50,'FontWeight','bold'};

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('/tmp/blake/testoutput/TestUtericBudSimulation/results_from_time_0/'));
velocitydata = LoadNonConstantLengthData('cellvelocities.dat');
populationdata = LoadNonConstantLengthData('celltypes.dat');
agedata = LoadNonConstantLengthData('cellages.dat');

% for k = 1:100
%     cell_id = velocitydata{k}(2:5:end-4);
%     x = velocitydata{k}(3:5:end-3);
%     y = velocitydata{k}(4:5:end-2);
%     u = velocitydata{k}(5:5:end-1);
%     v = velocitydata{k}(6:5:end);
%     
% %     plot(x,y,'ro');
% %     hold on;
% %     quiver(x,y,u,v);
% %     axis([0,16,0,12]);
% %     hold off;
% %     pause(0.1);
% end

% To pull data from many simulations, loop over each simulation and use a 
% running average process to calculate the mean data
%   a_(n+1) = (n*a_(n) + x_(n+1))/(n+1), a_1 = x_1;

%% no. cells vs time
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

simtime = 120*(1:populationdata{end}(1)); % multiplier for simulation_output_mult
diffcells = zeros(1, populationdata{end}(1));
transitcells = zeros(1, populationdata{end}(1));

for k = 1:populationdata{end}(1)
    transitcells(k) = populationdata{k}(3);
    diffcells(k) = populationdata{k}(4);
end
totalcells = transitcells + diffcells;
plot(simtime, totalcells, 'k', simtime, diffcells, 'r',...
    simtime, transitcells, 'b');
legend('Total', 'Differentiated', 'Transit');
title('Number of cells in simulation');
xlabel('simulation time'); ylabel('no. of cells');

%% u vs x
% x = horizontal position
% u = velocity in x direction
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

if anim == 1
    for k = 1:velocitydata{end}(1)
        cell_id = velocitydata{k}(2:5:end-4);
        x = velocitydata{k}(3:5:end-3);
        y = velocitydata{k}(4:5:end-2);
        u = velocitydata{k}(5:5:end-1);
        v = velocitydata{k}(6:5:end);
        
        scatter(x, u);
        axis([0, 40, -30, 30]);
        pause(0.05);
    end
end

x = velocitydata{end}(3:5:end-3);
u = velocitydata{end}(5:5:end-1);
myfit = polyfit(x,u, 1);
fit = myfit(1)*x + myfit(2);

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
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

if anim == 1
    for k = 1:velocitydata{end}(1)
        cell_id = velocitydata{k}(2:5:end-4);
        x = velocitydata{k}(3:5:end-3);
        y = velocitydata{k}(4:5:end-2);
        u = velocitydata{k}(5:5:end-1);
        v = velocitydata{k}(6:5:end);
        
        scatter(x, v);
        axis([0, 40, -30, 30]);
        pause(0.05);
    end
end

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
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

if anim == 1
    for k = 1:agedata{end}(1)
        cell_id = agedata{k}(2:4:end-4);
        x = agedata{k}(3:4:end-3);
        age = agedata{k}(5:4:end-1);
        
        scatter(x, age);
        axis([0, 40, 0, 300]);
        pause(0.05);
    end
end

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
figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

if anim == 1
    for k = 1:agedata{end}(1)
        cell_id = agedata{k}(2:4:end-4);
        y = agedata{k}(4:4:end-2);
        age = agedata{k}(5:4:end-1);
        
        scatter(y, age);
        axis([0, 10, 0, 300]);
        pause(0.05);
    end
end

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