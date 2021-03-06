function paper_typicalSim_plots

% load dependencies
addpath(genpath('src/common/'));
addpath(genpath('src/typicalSims/'));

% declare variables
figureDir = 'output/typicalSims/';
dataDir = 'data/typicalSims/';

stop_time = 600;

color_CM = [53 39 204] ./ 255;
color_P = [150 102 114] ./ 255;

% check output directory existence
if ~exist(figureDir, 'dir')
   mkdir(figureDir)
end
data_path = strcat(dataDir, '/UtericBud_model_3_param_0.6_pa_0_pd_0_simtime_1000_');
stop_index = round(1666*stop_time/1000)+1;


% % get cell counts
% D = dir([data_path '*']);
% TotalJobs = length(D(:));
% PopulationDataSet = cell(1,TotalJobs);
% for i = 1:TotalJobs
%     loaddata = importdata([data_path 'sim_' num2str(i-1) ...
%         '/results_from_time_0/celltypescount.dat']);
%     PopulationDataSet{i} = loaddata.data;
%     if i == 1
%         SimTime = PopulationDataSet{i}(:,1);
%         TotalCells = zeros(length(SimTime), TotalJobs);
%         ProlifCells = zeros(length(SimTime), TotalJobs);
%     end
%     TotalCells(:, i) = PopulationDataSet{i}(:,3) ...
%         + PopulationDataSet{i}(:,2);
%     ProlifCells(:, i) = PopulationDataSet{i}(:,2);
% end
% 
% % plot cell counts
% fig = figure(1); clf;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% plot(SimTime, TotalCells);
% 
% title('Total cells across each simulation', 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% axis([0 stop_time 0 350]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'typicalSim_pop'], ...
%     11, 7/5, 15);




%% calculate population statistics 


[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

MeanPopulationData = MeanPopulationData(1:stop_index, :);
TotalCellsStd = TotalCellsStd(1:stop_index);

SimTime = MeanPopulationData(:,1);

TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
RVCells = MeanPopulationData(:,6);

% plot population statistics
fig = figure(1); clf;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(SimTime, TransitCells, 'Color', color_CM);
hold on;
plot(SimTime, RVCells, 'Color', color_P);
plot(SimTime, TotalCells, 'k');
plot(SimTime, TotalCells + TotalCellsStd, 'k--', ...
    SimTime, TotalCells - TotalCellsStd, 'k--');
hold off;

legend('Proliferative cells', 'Primed cells', 'Location', 'Best');

xlabel('Simulation time (hours)', 'Interpreter', 'latex'); 
ylabel('CM population size', 'Interpreter', 'latex');

SaveAsPngEpsAndFig(-1, [figureDir, 'typicalSim_avg_pop'], ...
    11, 7/5, 15);


%% calculate cap height 

D = dir([data_path '*']);
TotalJobs = length(D(:));

sampleindexmax = length(SimTime);
height_data = zeros(sampleindexmax, TotalJobs); 

for i = 1:TotalJobs
    loaddata =  LoadNonConstantLengthData([data_path 'sim_' num2str(i-1) '/results_from_time_0/cellstate.dat']);
    
    for j = 1:sampleindexmax
        y = loaddata{j}(4:4:end-1);
        y = sort(y,'descend');
        height_data(j, i) = y(1 + 9*(length(y)>=10));
    end
end

plot_height = zeros(1,sampleindexmax);
for i = 1:sampleindexmax
    plot_height(i) = mean(height_data(i,:));
end

% plot cap height
fig = figure(2); clf;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(SimTime, plot_height, 'k');
xlabel('Simulation time (hours)','Interpreter', 'latex');
ylabel('Cap height (cd)','Interpreter', 'latex');

SaveAsPngEpsAndFig(-1, [figureDir, 'typicalSim_cap_height'], ...
    11, 7/5, 15);


disp('pass!')
end





% close all;
% addpath(genpath('PlotData/functions'));
% 
% testoutput_path = 'PlotData/data/paper/typicalsims3';
% data_path = [testoutput_path '/UtericBud_model_3_param_0.6_pa_0_pd_0_simtime_600_'];
% 
% figure_dir = 'Figures/Paper/typicalSim/';
% 
% stop_time = 600;
% 
% stop_index = round(1666*stop_time/1000)+1;
% 
% color_CM = [53 39 204] ./ 255;
% color_P = [150 102 114] ./ 255;
% 
% 
% %% Plot individual trajectories
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
%     PopulationDataSet{i} = PopulationDataSet{i}(1:stop_index, :);
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
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% plot(SimTime, TotalCells);
% 
% title('Total cells across each simulation', 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% 
% axis([0 stop_time 0 350]);
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'typicalSim_pop'], ...
%     11, 7/5, 15);
% 
% 
% 
% %% Plot Mean cells vs time
% [MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);
% 
% MeanPopulationData = MeanPopulationData(1:stop_index, :);
% TotalCellsStd = TotalCellsStd(1:stop_index);
% 
% SimTime = MeanPopulationData(:,1);
% 
% TransitCells = MeanPopulationData(:,2);
% TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
% 
% RVCells = MeanPopulationData(:,6);
% 
% 
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
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
% title('Average number of cells', 'Interpreter', 'latex');
% xlabel('Simulation time (h)', 'Interpreter', 'latex'); 
% ylabel('No. of cells', 'Interpreter', 'latex');
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'typicalSim_avg_pop'], ...
%     11, 7/5, 15);
% 
% 
% 
% 
% %% plot change in cap height
% sampleindexmax=0;
% prolif=0;
% height_data = cell(TotalJobs,1);
% for i = 1:TotalJobs
%     height_data{i} = zeros(20, 1);
% end
% 
% 
% plot_height_time = zeros(1,sampleindexmax);
% 
% for k = 1:TotalJobs
% 
%     loaddata = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
%     
%     if (k == 1) && (sampleindexmax == 0)
%         sampleindexmax = length(loaddata);        
%     end
%     
%     for i = 1:sampleindexmax %over each sample step
%         y = loaddata{i}(4:4:end-1);
% 
%         if k == 1
%             plot_height_time(i) = loaddata{i}(1);
%         end
% 
%         if prolif == 1
%             state = loaddata{i}(5:4:end);
%             tmp = (state ~= 0) .* y;
%             y = y(tmp>0);
%         end
%         tmp = sort(y,'descend');
%         if length(tmp) < 10
%             height_data{k}(i,1) = tmp(1);
%         else
%             height_data{k}(i,1) = tmp(10);
%         end
%     end
%     
% end
% 
% 
% 
% plot_height = zeros(1,sampleindexmax);
% for i = 1:sampleindexmax
%     plot_height(i) = height_data{1}(i,1);
%     for k = 2:TotalJobs
%         plot_height(i) = (k-1)/k * (plot_height(i) + height_data{k}(i,1));
%     end
% end
% 
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% plot(plot_height_time, plot_height, 'k');
% title('Average cap height', 'Interpreter', 'latex');
% xlabel('Simulation time (h)','Interpreter', 'latex');
% ylabel('Cap height (cd)','Interpreter', 'latex');
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'typicalSim_cap_height'], ...
%     11, 7/5, 15);
% 
% 
% 
% 
% 
% 
% 
% %% plot change in histogram slopes (both total and proliferative on same plot?)
% histogram_data = cell(TotalJobs,1);
% histogram_data_prolif = cell(TotalJobs,1);
% for i = 1:TotalJobs
%     histogram_data{i} = zeros(21, 20);
%     histogram_data_prolif{i} = zeros(21, 20);
% end
% 
% plot_slope_time = zeros(1,sampleindexmax);
% 
% for k = 1:TotalJobs
%     
%     loaddata = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
%     
%     for i = 1:length(loaddata) % over each sample step
%         x = loaddata{i}(3:4:end-2);
% 
%         if k == 1
%             plot_slope_time(i) = loaddata{i}(1);
%         end
% 
%         histogram_data{k}(i,:) = histcounts(x,0:1:20, 'Normalization', 'probability');
% 
%         state = loaddata{i}(5:4:end);
%         tmp = (state ~= 0) .* x;
% 
%         histogram_data_prolif{k}(i,:) = histcounts(x(tmp>0),0:1:20, 'Normalization', 'probability');
% 
%     end
% 
% end
% 
% 
% plot_slope = zeros(1,sampleindexmax);
% plot_slope_prolif = zeros(1,sampleindexmax);
% m = 0.5:1:19.5;
% M = [ones(length(m),1), m'];
% for i = 1:sampleindexmax
%     n = histogram_data{1}(i,:);
%     b = M\n';
%     slope = b(2);
% 
%     plot_slope(i) = slope;
%     for k = 2:TotalJobs
%         n = histogram_data{k}(i,:);
%         b = M\n';
%         slope = b(2);
% 
%         plot_slope(i) = (k-1)/k * (plot_slope(i) + slope);
%     end
% 
% 
%     n = histogram_data_prolif{1}(i,:);
%     b = M\n';
%     slope = b(2);
% 
%     plot_slope_prolif(i) = slope;
%     for k = 2:TotalJobs
%         n = histogram_data_prolif{k}(i,:);
%         b = M\n';
%         slope = b(2);
% 
%         plot_slope_prolif(i) = (k-1)/k * (plot_slope(i) + slope);
%     end
% end
% 
% 
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% 
% plot(...
%     plot_slope_time, plot_slope, 'k', ...
%     plot_slope_time, plot_slope_prolif, 'b' ...
%     );
% title('Average histogram slope', 'Interpreter', 'latex');
% xlabel('Simulation time (h)' ,'Interpreter', 'latex');
% ylabel('Histogram slope','Interpreter', 'latex');
% legend('Total', 'CM cells', 'Location', 'Best');
% 
% SaveAsPngEpsAndFig(-1, [figure_dir, 'typicalSim_hist_slope'], ...
%     11, 7/5, 15);
% 
% 
% 
% 
% end