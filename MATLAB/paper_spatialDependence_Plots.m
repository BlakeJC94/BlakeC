function paper_spatialDependence_Plots

close all;
addpath(genpath('functions/'));

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





disp('pass!')





end

