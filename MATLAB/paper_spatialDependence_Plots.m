function paper_spatialDependence_Plots

% load dependencies
addpath(genpath('src/common/'));
addpath(genpath('src/spatialDependence/'));

% declare variables
figureDir = 'output/spatialDependence/';
dataDir = 'data/spatialDependence/';

% color_CM = [53 39 204] ./ 255;
% color_P = [150 102 114] ./ 255;
color_totals = [0, 0, 1, 0.05];

% Check output directory existence
if ~exist(figureDir, 'dir')
   mkdir(figureDir)
end



for model = [0, 1]
    
    % load data
    parameter = 0.5/(model+1);  % (0, 0.5), (1, 0.25)
    disp(['model : ', num2str(model)])
    disp(['parameter : ', num2str(parameter)])
    
    testoutput_path = [dataDir, 'spatialDependence_model_' num2str(model) '_testoutput_dats'];

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
            TotalCells = zeros(length(SimTime), TotalJobs);
            % ProlifCells = zeros(length(SimTime), TotalJobs);
        end
        TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
            + PopulationDataSet{i}(:,2);
        % ProlifCells(:, i) = PopulationDataSet{i}(:,2);
    end
    
    [MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

    SimTime = MeanPopulationData(:,1);
    TotalCellsMean = MeanPopulationData(:,3) + MeanPopulationData(:,2);
%     TransitCells = MeanPopulationData(:,2);
%     RVCells = MeanPopulationData(:,6);
    
    % plot data 
    figure(1); clf;

    plot(SimTime, TotalCells, 'Color', color_totals);
    hold on;
        plot(SimTime, TotalCellsMean, 'k');
    plot(SimTime, TotalCellsMean + TotalCellsStd, 'k--', ...
        SimTime, TotalCellsMean - TotalCellsStd, 'k--');
    hold off;

    xlabel('Simulation time (hours)', 'Interpreter', 'latex'); 
    ylabel('CM population size', 'Interpreter', 'latex');

    axis([0 500 0 350]);

    if model == 0
        fileStr = "ConstParTimeSeries_Total";
    elseif model == 1
        fileStr = "StepTimeSeries_Total";
    end
    SaveAsPngEpsAndFig(-1, strcat(figureDir, fileStr), ...
        11, 7/5, 15);
    pause(1);
end


disp('pass!')
end





% %% Get data path for constant model
% model = 0;
% parameter = 0.5;
% 
% testoutput_path = ['PlotData/data/spatialDependence/'...
%     'spatialDependence_model_' num2str(model) '_testoutput_dats'];
% 
% data_path = [testoutput_path '/UtericBud_model_' num2str(model) ...
%     '_param_' num2str(parameter) '_pa_0_pd_0_simtime_600_'];
% 
% D = dir([data_path '*']);
% TotalJobs = length(D(:));
% 
% PopulationDataSet = cell(1,TotalJobs);
% 
% for i = 1:TotalJobs
%     
%     loaddata = importdata([data_path 'sim_' num2str(i-1) ...
%         '/results_from_time_0/celltypescount.dat']);
%     PopulationDataSet{i} = loaddata.data;
%     
%     
%     if i == 1
%         
%         SimTime = PopulationDataSet{i}(:,1);
%         
%         TotalCells = [PopulationDataSet{i}(:,3) ...
%             + PopulationDataSet{i}(:,2), ...
%             zeros(length(SimTime), TotalJobs-1)];
%         
%         ProlifCells = [PopulationDataSet{i}(:,2), ...
%             zeros(length(SimTime), TotalJobs-1)];
%         
%     else
%         
%         TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
%             + PopulationDataSet{i}(:,2);
%         
%         ProlifCells(:, i) = PopulationDataSet{i}(:,2);
%         
%     end
%     
%     
% end
% 
% figure;
% 
% plot(SimTime, TotalCells);
% 
% title(['Total cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% axis([0 500 0 350]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'ConstParTimeSeries_Total'], ...
%     11, 7/5, 15);
% 
% % title(['Total cells over ', num2str(TotalJobs), ' simulations (step)']);
% 
% 
% figure;
% 
% plot(SimTime, ProlifCells);
% 
% title(['Proliferative cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells','Interpreter', 'latex');
% 
% axis([0 500 0 200]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'ConstParTimeSeries_Prolif'], ...
%     11, 7/5, 15);
% 
% 
% %% Plot averaged time series for const p=0.5 model
% 
% [MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);
% 
% SimTime = MeanPopulationData(:,1);
% TransitCells = MeanPopulationData(:,2);
% TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
% 
% RVCells = MeanPopulationData(:,6);
% 
% figure;
% 
% hold on;
% 
% plot(SimTime, TotalCells, 'k');
% 
% plot(SimTime, TransitCells, 'Color', color_CM);
% 
% plot(SimTime, RVCells, 'Color', color_P);
% 
% plot(SimTime, TotalCells + TotalCellsStd, 'k--', ...
%     SimTime, TotalCells - TotalCellsStd, 'k--');
% 
% hold off;
% 
% 
% legend('Total', 'CM cells', 'P Cells','Location', 'Best');
% 
% % title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
% title(['Average number of cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time', 'Interpreter', 'latex');
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% SaveAsPngEpsAndFig(-1,[figure_dir 'ConstParTimeSeries_Avg'], ...
%     11, 7/5, 15);
% 
% 
% %% Get data path for step model 
% model = 1;
% parameter = 0.25;
% 
% testoutput_path = ['PlotData/data/paper/spatialDependence/'...
%     'spatialDependence_model_' num2str(model) '_testoutput_dats'];
% 
% data_path = [testoutput_path '/UtericBud_model_' num2str(model) ...
%     '_param_' num2str(parameter) '_pa_0_pd_0_simtime_600_'];
% 
% D = dir([data_path '*']);
% TotalJobs = length(D(:));
% 
% PopulationDataSet = cell(1,TotalJobs);
% 
% for i = 1:TotalJobs
%     
%     loaddata = importdata([data_path 'sim_' num2str(i-1) ...
%         '/results_from_time_0/celltypescount.dat']);
%     PopulationDataSet{i} = loaddata.data;
%     
%     
%     if i == 1
%         
%         SimTime = PopulationDataSet{i}(:,1);
%         
%         TotalCells = [PopulationDataSet{i}(:,3) ...
%             + PopulationDataSet{i}(:,2), ...
%             zeros(length(SimTime), TotalJobs-1)];
%         
%         ProlifCells = [PopulationDataSet{i}(:,2), ...
%             zeros(length(SimTime), TotalJobs-1)];
%         
%     else
%         
%         TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
%             + PopulationDataSet{i}(:,2);
%         
%         ProlifCells(:, i) = PopulationDataSet{i}(:,2);
%         
%     end
%     
%     
% end
% 
% figure;
% 
% plot(SimTime, TotalCells);
% 
% title(['Total cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% axis([0 500 0 350]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'StepTimeSeries_Total'], ...
%     11, 7/5, 15);
% 
% % title(['Total cells over ', num2str(TotalJobs), ' simulations (step)']);
% 
% 
% figure;
% 
% plot(SimTime, ProlifCells);
% 
% title(['Proliferative cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time (h)'); ylabel('No. of cells');
% 
% axis([0 500 0 200]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'StepTimeSeries_Prolif'], ...
%     11, 7/5, 15);
% 
% 
% %% Plot averaged time series for step model
% 
% [MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);
% 
% SimTime = MeanPopulationData(:,1);
% TransitCells = MeanPopulationData(:,2);
% TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
% 
% RVCells = MeanPopulationData(:,6);
% 
% figure;
% 
% hold on;
% 
% plot(SimTime, TotalCells, 'k');
% 
% plot(SimTime, TransitCells, 'Color', color_CM);
% 
% plot(SimTime, RVCells, 'Color', color_P);
% 
% plot(SimTime, TotalCells + TotalCellsStd, 'k--', ...
%     SimTime, TotalCells - TotalCellsStd, 'k--');
% 
% hold off;
% 
% 
% legend('Total', 'CM cells', 'P Cells','Location', 'Best');
% 
% % title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
% title(['Average number of cells ($$p$$ = 0.5)'], 'Interpreter', 'latex');
% xlabel('Simulation time'); ylabel('No. of cells');
% 
% SaveAsPngEpsAndFig(-1,[figure_dir 'StepTimeSeries_Avg'], ...
%     11, 7/5, 15);







