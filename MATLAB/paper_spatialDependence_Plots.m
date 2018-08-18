function paper_spatialDependence_Plots

close all;
addpath(genpath('PlotData/functions/'));

figure_dir = 'Figures/Paper/spatialDependence/';

%% Get data path for constant model 
model = 0;
parameter = 0.5;

testoutput_path = ['PlotData/data/paper/spatialDependence/'...
    'spatialDependence_model_' num2str(model) '_testoutput_dats'];

data_path = [testoutput_path '/UtericBud_model_' num2str(model) ...
    '_param_' num2str(parameter) '_pa_0_pd_0_simtime_600_'];

D = dir([data_path '*']);
TotalJobs = length(D(:));

PopulationDataSet = cell(1,TotalJobs);

for i = 1:TotalJobs
    
    loaddata = importdata([data_path 'sim_' num2str(i-1) ...
        '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{i} = loaddata.data;
    
    
    if i == 1
        
        SimTime = PopulationDataSet{i}(:,1);
        
        TotalCells = [PopulationDataSet{i}(:,3) ...
            + PopulationDataSet{i}(:,2), ...
            zeros(length(SimTime), TotalJobs-1)];
        
        ProlifCells = [PopulationDataSet{i}(:,2), ...
            zeros(length(SimTime), TotalJobs-1)];
        
    else
        
        TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
            + PopulationDataSet{i}(:,2);
        
        ProlifCells(:, i) = PopulationDataSet{i}(:,2);
        
    end
    
    
end

figure;

plot(SimTime, TotalCells);

title(['Total cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time (h)'); ylabel('No. of cells');

axis([0 500 0 350]);

SaveAsPngEpsAndFig(-1, [figure_dir, 'ConstParTimeSeries_Total'], ...
    11, 7/5, 15);

% title(['Total cells over ', num2str(TotalJobs), ' simulations (step)']);


figure;

plot(SimTime, ProlifCells);

title(['Proliferative cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time (h)'); ylabel('No. of cells');

axis([0 500 0 200]);

SaveAsPngEpsAndFig(-1, [figure_dir, 'ConstParTimeSeries_Prolif'], ...
    11, 7/5, 15);


%% Plot averaged time series for const p=0.5 model

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

% title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
title(['Average number of cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time'); ylabel('No. of cells');

SaveAsPngEpsAndFig(-1,[figure_dir 'ConstParTimeSeries_Avg'], ...
    11, 7/5, 15);


%% Get data path for step model 
model = 1;
parameter = 0.25;

testoutput_path = ['PlotData/data/paper/spatialDependence/'...
    'spatialDependence_model_' num2str(model) '_testoutput_dats'];

data_path = [testoutput_path '/UtericBud_model_' num2str(model) ...
    '_param_' num2str(parameter) '_pa_0_pd_0_simtime_600_'];

D = dir([data_path '*']);
TotalJobs = length(D(:));

PopulationDataSet = cell(1,TotalJobs);

for i = 1:TotalJobs
    
    loaddata = importdata([data_path 'sim_' num2str(i-1) ...
        '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{i} = loaddata.data;
    
    
    if i == 1
        
        SimTime = PopulationDataSet{i}(:,1);
        
        TotalCells = [PopulationDataSet{i}(:,3) ...
            + PopulationDataSet{i}(:,2), ...
            zeros(length(SimTime), TotalJobs-1)];
        
        ProlifCells = [PopulationDataSet{i}(:,2), ...
            zeros(length(SimTime), TotalJobs-1)];
        
    else
        
        TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
            + PopulationDataSet{i}(:,2);
        
        ProlifCells(:, i) = PopulationDataSet{i}(:,2);
        
    end
    
    
end

figure;

plot(SimTime, TotalCells);

title(['Total cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time (h)'); ylabel('No. of cells');

axis([0 500 0 350]);

SaveAsPngEpsAndFig(-1, [figure_dir, 'StepTimeSeries_Total'], ...
    11, 7/5, 15);

% title(['Total cells over ', num2str(TotalJobs), ' simulations (step)']);


figure;

plot(SimTime, ProlifCells);

title(['Proliferative cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time (h)'); ylabel('No. of cells');

axis([0 500 0 200]);

SaveAsPngEpsAndFig(-1, [figure_dir, 'StepTimeSeries_Prolif'], ...
    11, 7/5, 15);


%% Plot averaged time series for step model

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

% title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
title(['Average number of cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
xlabel('Simulation time'); ylabel('No. of cells');

SaveAsPngEpsAndFig(-1,[figure_dir 'StepTimeSeries_Avg'], ...
    11, 7/5, 15);




disp('pass!')





end

