function Constant_Plots

model = 1;
parameter = 0.5;

close all;
addpath(genpath('functions/'));

testoutput_path = ['PlotData/data/AffinityB/0' num2str(model) '_testoutput_dats'];
data_path = [testoutput_path '/UtericBudSimulation_const_' num2str(parameter) '_'];

D = dir([data_path '*']);
TotalJobs = length(D(:));
PopulationDataSet = cell(1,TotalJobs);

for k = 1:TotalJobs
    
    loaddata = importdata([data_path 'sim_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{k} = loaddata.data;
    
    if k == 1
        SimTime = PopulationDataSet{k}(:,1);
        TotalCells = [PopulationDataSet{k}(:,3) + PopulationDataSet{k}(:,2), zeros(length(SimTime), TotalJobs-1)];
        ProlifCells = [PopulationDataSet{k}(:,2), zeros(length(SimTime), TotalJobs-1)];
    else
        TotalCells(:, k) = PopulationDataSet{k}(:,3) + PopulationDataSet{k}(:,2);
        ProlifCells(:, k) = PopulationDataSet{k}(:,2);
    end
   
    
end


figure;
plot(SimTime, TotalCells);
title(['Total cells over ', num2str(TotalJobs), ' simulations (p = 0.5)']);
xlabel('Simulation time (h)'); ylabel('No. of cells');
axis([0 500 0 350]);
SaveAsPngEpsAndFig(-1,'Figures/ConstParTimeSeries_Total', 11, 7/5, 10);

figure;
plot(SimTime, ProlifCells);
title(['Proliferative cells over ', num2str(TotalJobs), ' simulations (p = 0.5)']);
xlabel('Simulation time (h)'); ylabel('No. of cells');
axis([0 500 0 100]);
SaveAsPngEpsAndFig(-1,'Figures/ConstParTimeSeries_Prolif', 11, 7/5, 10);



[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

SimTime = MeanPopulationData(:,1);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

RVCells = MeanPopulationData(:,6);

figure;
plot(SimTime, TotalCells, 'k',...
    SimTime, TransitCells, 'b',...
    SimTime, RVCells, 'r',...
    SimTime, TotalCells + TotalCellsStd, 'k--', ...
    SimTime, TotalCells - TotalCellsStd, 'k--');
legend('Total', 'CM cells', 'RV Cells','Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
xlabel('Simulation time'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/ConstParTimeSeries_Avg', 11, 7/5, 10);



testoutput_path2 = ['PlotData/data/AffinityB/MODEL_4_testoutput_dats'];
data_path2 = [testoutput_path2 '/UtericBudSimulation_concbmodel_4_parameter_0.25_'];

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path2);

SimTime = MeanPopulationData(:,1);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

RVCells = MeanPopulationData(:,6);

figure;
plot(SimTime(1:834), TotalCells(1:834), 'k',...
    SimTime(1:834), TransitCells(1:834), 'b',...
    SimTime(1:834), RVCells(1:834), 'r',...
    SimTime(1:834), TotalCells(1:834) + TotalCellsStd(1:834), 'k--', ...
    SimTime(1:834), TotalCells(1:834) - TotalCellsStd(1:834), 'k--');
legend('Total', 'CM cells', 'RV Cells','Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
xlabel('Simulation time'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/ConstParTimeSeries_Avg2', 11, 7/5, 10);



end

