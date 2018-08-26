function paper_typicalSim_plots

close all;
addpath(genpath('PlotData/functions'));

testoutput_path = 'PlotData/data/paper/typicalsims3';
data_path = [testoutput_path '/UtericBud_model_3_param_0.6_pa_0_pd_0_simtime_600_'];


stop_time = 600;

stop_index = round(1666*stop_time/1000)+1;




%% Plot individual trajectories
D = dir([data_path '*']);
TotalJobs = length(D(:));

PopulationDataSet = cell(1,TotalJobs);

for i = 1:TotalJobs
    
    loaddata = importdata([data_path 'sim_' num2str(i-1) ...
        '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{i} = loaddata.data;
    PopulationDataSet{i} = PopulationDataSet{i}(1:stop_index, :);
    
    
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

title('Total cells across each simulation', 'Interpreter', 'latex');
xlabel('Simulation time (h)'); ylabel('No. of cells');

axis([0 stop_time 0 350]);





%% Plot Mean cells vs time
[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

MeanPopulationData = MeanPopulationData(1:stop_index, :);
TotalCellsStd = TotalCellsStd(1:stop_index);

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
title('Average number of cells', 'Interpreter', 'latex');
xlabel('Simulation time'); ylabel('No. of cells');




%% plot change in cap height
sampleindexmax=0;
prolif=0;
height_data = cell(TotalJobs,1);
for i = 1:TotalJobs
    height_data{i} = zeros(20, 1);
end


plot_height_time = zeros(1,sampleindexmax);

for k = 1:TotalJobs
    disp(k)
    loaddata = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
    
    if (k == 1) && (sampleindexmax == 0)
        sampleindexmax = length(loaddata);        
    end
    
    for i = 1:sampleindexmax %over each sample step
        y = loaddata{i}(4:4:end-1);

        if k == 1
            plot_height_time(i) = loaddata{i}(1);
        end

        if prolif == 1
            state = loaddata{i}(5:4:end);
            tmp = (state ~= 0) .* y;
            y = y(tmp>0);
        end
        tmp = sort(y,'descend');
        if length(tmp) < 10
            height_data{k}(i,1) = tmp(1);
        else
            height_data{k}(i,1) = tmp(10);
        end
    end
    
end



plot_height = zeros(1,sampleindexmax);
for i = 1:sampleindexmax
    plot_height(i) = height_data{1}(i,1);
    for k = 2:TotalJobs
        plot_height(i) = (k-1)/k * (plot_height(i) + height_data{k}(i,1));
    end
end

figure;
plot(plot_height_time, plot_height)

keyboard;






%% plot change in histogram slopes (both total and proliferative on same plot?)



end