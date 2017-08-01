function ViewUtBudData(TotalJobs, BinSize_ux, BinSize_vx, BinSize_agex, BinSize_agey)
% ViewUtBudData: Produces data plots for batch data from UtericBudSimulation
%
%   Inputs:
%       TotalJobs = total number of sims, match 'num_sims' in .sh file.
%       BinSize_ux = size of partition elements of x in 'Mean u vs x'
%       BinSize_vx = size of partition elements of x in 'Mean v vs x'
%       BinSize_agex = size of partition elements of x in 'Mean age vs x'
%       BinSize_agey = size of partition elements of x in 'Mean age vs y'
%       max_x = Right endpoint of largest partition element will be the
%           first integer multiple after this
%       max_y = Right endpoint of largest partition element will be the
%           first integer multiple after this
%
%   Outputs:
%       AvPopulationDataOut = cell containing plot data for 'Mean no.
%           cells vs time', values as specified in plot code.
%       AvHVelocityDataOut = cell containing plot data for 'Mean u vs x'.
%       AvVVelocityDataOut = cell containing plot data for 'Mean v vs x'.
%       AvHAgeDataOut = cell containing plot data for 'Mean age vs x'.
%       AvVAgeDataOut = cell containing plot data for 'Mean age vs y'.
%
% Default Args : ViewUtBudData(5, 2, 2, 1, 1, 40, 10)
%
%% Add paths and set up

close all;

max_x = 20;
max_y = 5;

if nargin == 1
    BinSize_ux = 0.5;
    BinSize_vx = 0.5;
    BinSize_agex = 0.5;
    BinSize_agey = 0.5;
end

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));
addpath(genpath('ViewUtBudDataFunctions/'));
tic;

%% Mean no. cells vs time
% Plots time series of the population count by ProliferativeType

PopulationDataSet = cell(1,TotalJobs);
for k = 1:TotalJobs
    temp = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) ...
        '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{k} = temp.data;
end

meanscellsvstime(PopulationDataSet);


%% Mean cap height vs t
% Plots line graph of the average cap height in the simulation.
% avg cap height calculated by partitioning x and averaging the max heing
% in each partition element.

VelocitiesDataSet = cell(1,TotalJobs);
for k = 1:TotalJobs
    VelocitiesDataSet{k} = LoadNonConstantLengthData(['testoutput/' ...
        'UtericBudSimulation_' num2str(k-1) ...
        '/results_from_time_0/cellvelocities.dat']);
end

meancapheightvstime(VelocitiesDataSet);


%% Mean u and v vs x
% Plots bar graph of horizonal velocities averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   u = velocity in x direction
%   v = velocity in y direction
% Size of partition elements specified by 'BinSize_ux' input.
% Maximum x specified by 'max_x' input.

meanvelocityvsx(VelocitiesDataSet, BinSize_ux, BinSize_vx, max_x, max_y);


%% Mean age vs x and y
% Plots bar graph of cell ages averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   y = vertical position
%   age = age of cell
% Size of partition elements specified by 'BinSize_agex' input.
% Maximum x specified by 'max_x' input.

AgesDataSet = cell(1,TotalJobs);
for k = 1:TotalJobs
    AgesDataSet{k} = LoadNonConstantLengthData(['testoutput/' ...
        'UtericBudSimulation_' num2str(k-1) ...
        '/results_from_time_0/cellages.dat']);
end

meanagevsxy(AgesDataSet, BinSize_agex, BinSize_agey, max_x, max_y);


%% Finish

toc

end







