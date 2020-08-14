function UT_PopulationVsTime(data_path, simple)
% UT_PopulationVsTime: Plots time series of population count (total,
% differntaited, undifferentiated, attached, ... )
%
%% Add paths and set up
if nargin < 2
    simple = 0;
end

close all;
fontopt = {'FontSize',20,'FontWeight','bold'};

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('functions/'));

D = dir([data_path '*']);
TotalJobs = length(D(:));

tic;

%% Mean no. cells vs time
% Plots time series of the population count by ProliferativeType

% PopulationDataSet = cell(1,TotalJobs);
% 
% for k = 1:TotalJobs
%     run = k-1;
%     
%     loaddata = importdata([data_path '_sim_' num2str(run) '/results_from_time_0/celltypescount.dat']);
%     PopulationDataSet{k} = loaddata.data;
% end

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

SimTime = MeanPopulationData(:,1);
DiffCells = MeanPopulationData(:,3);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

AttachedCells = MeanPopulationData(:,5);
RVCells = MeanPopulationData(:,6);

figure(1);



if simple == 1
     plot(SimTime, TotalCells, 'k',...
        SimTime, TransitCells, 'b');
else
    plot(SimTime, TotalCells, 'k',...
        SimTime, TransitCells, 'b',...
        SimTime, RVCells, 'r',...
        SimTime, AttachedCells, 'g',...
        SimTime, TotalCells + TotalCellsStd, 'k:', ...
        SimTime, TotalCells - TotalCellsStd, 'k:');
    legend('Total', 'CM cells', 'RV Cells', 'Attached cells',...
    'Location', 'Best');

%     plot(SimTime, TotalCells, 'k',...
%         SimTime, TransitCells, 'b',...
%         SimTime, RVCells, 'r',...
%         SimTime, TotalCells + TotalCellsStd, 'k--', ...
%         SimTime, TotalCells - TotalCellsStd, 'k--');
%     legend('Total', 'CM cells', 'RV Cells',...
%     'Location', 'Best');

    %totalcellsteadystate(PopulationDataSet);
    %steadystateshape(model, parameter);
end
figure(1);
title(['Average number of cells over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('Simulation time'); ylabel('No. of cells');
%SaveAsPngEpsAndFig(-1,'divparam1', 11, 7/5, 10);

%set(gcf,'PaperPositionMode','auto'); print('Fig01', '-dpng', '-r0');




toc

end







