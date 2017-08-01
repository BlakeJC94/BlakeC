function UT_PopulationVsTime(model, parameter)
% UT_PopulationVsTime: Plots time series of population count (total,
% differntaited, undifferentiated, attached, ... )
%
%% Add paths and set up

close all;
fontopt = {'FontSize',20,'FontWeight','bold'};

TotalJobs = 20;

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('functions/'));

testoutput_path = ['/home/blake/Documents/Saved Simulation Data' ...
    '/20170801/0' num2str(model) '_testoutput_dats'];

data_path = [testoutput_path '/UtericBudSimulation_Sweep_' num2str(parameter) 'model' num2str(model)];

D = dir([data_path '*']);
TotalJobs = length(D(:));

tic;

%% Mean no. cells vs time
% Plots time series of the population count by ProliferativeType

PopulationDataSet = cell(1,TotalJobs);

for k = 1:TotalJobs
    run = k-1;
    
    loaddata = importdata([data_path '_sim_' num2str(run) '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{k} = loaddata.data;
end

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(PopulationDataSet);

SimTime = MeanPopulationData(:,1);
DiffCells = MeanPopulationData(:,3);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

AttachedCells = MeanPopulationData(:,5);
RVCells = MeanPopulationData(:,6);

figure;

plot(SimTime, TotalCells, 'k',...
     SimTime, TransitCells, 'b',...
     SimTime, DiffCells, 'r',...
     SimTime, RVCells, 'm',...
     SimTime, AttachedCells, 'g',...
     SimTime, TotalCells + TotalCellsStd, 'k:', ...
     SimTime, TotalCells - TotalCellsStd, 'k:');

legend('Total', 'Proliferative', 'Non-Proliferative',...
    'RV Cells', 'Attached Cells', 'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('Simulation time'); ylabel('No. of cells');
set(gcf,'PaperPositionMode','auto'); print('Fig01', '-dpng', '-r0');



totalcellsteadystate(PopulationDataSet);


toc

end







