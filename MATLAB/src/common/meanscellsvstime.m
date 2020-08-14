function [MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path)
% Function that takes in population data (celltypescount.dat) and produces
% plots of average cell numbers vs time.

D = dir([data_path '*']);
TotalJobs = length(D(:));

PopulationDataSet = cell(1,TotalJobs);
for k = 1:TotalJobs
    loaddata = importdata([data_path 'sim_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{k} = loaddata.data;
end

PopulationData = PopulationDataSet{1};
[~, TotalJobs] = size(PopulationDataSet);

TotalCells_Sum1 = PopulationData(:,3) + PopulationData(:,2);
TotalCells_Sum2 = (PopulationData(:,3) + PopulationData(:,2)).^2;

Sum1 = PopulationData;
Sum2 = PopulationData.^2;

for k = 2:TotalJobs
    PopulationData = PopulationDataSet{k};
    
    if length(TotalCells_Sum1) ~= length(PopulationData)
        temp = min(length(TotalCells_Sum1),length(PopulationData));
        PopulationData = PopulationData(1:temp, :);
        TotalCells_Sum1 = TotalCells_Sum1(1:temp, :);
        TotalCells_Sum2 = TotalCells_Sum2(1:temp, :);
        Sum1 = Sum1(1:temp, :);
        Sum2 = Sum2(1:temp, :);
    end
    
%     if length(TotalCells_Sum1) < length(PopulationData)
%         PopulationData = PopulationData(1:length(TotalCells_Sum1), :);
%     elseif length(TotalCells_Sum1) > length(PopulationData)
%         TotalCells_Sum1 = TotalCells_Sum1(1:length(PopulationData), :);
%         TotalCells_Sum2 = TotalCells_Sum2(1:length(PopulationData), :);
%         Sum1 = Sum1(1:length(PopulationData), :);
%         Sum2 = Sum2(1:length(PopulationData), :);
%     end
    
    TotalCells_Sum1 = TotalCells_Sum1 + PopulationData(:,3) + PopulationData(:,2);
    TotalCells_Sum2 = TotalCells_Sum2 + (PopulationData(:,3) + PopulationData(:,2)).^2;
    
    Sum1 = Sum1 + PopulationData;
    Sum2 = Sum2 + PopulationData.^2;
    
end

MeanPopulationData = Sum1/TotalJobs;
%VarPopulationData = (TotalJobs*Sum2 - Sum1.^2)/(TotalJobs*(TotalJobs-1));
TotalCellsStd = sqrt((TotalJobs*TotalCells_Sum2 - TotalCells_Sum1.^2)/(TotalJobs*(TotalJobs-1)));





%% QD stationairty test (return time from finish when is total_pop is steady)
% This function partitions the timeseries data into windows and compares
% the sample statistics of neighbouring partitions. If the statstics agree
% with 1-eps confidence, it is accepted as a window where the distribution
% is stationary

% t = 40; % number of data points in each window
% eps = 0.075; % confidence interval
% 
% PopulationData = PopulationDataSet{1};
% Sample1 = PopulationData(end-t+1:end, :);
% Sample2 = PopulationData(end-2*t+1:end-t, :);
% 
% for k = 2:TotalJobs
%     PopulationData = PopulationDataSet{k};
%     Sample1 = [Sample1; PopulationData(end-t+1:end, :)];
%     Sample2 = [Sample2; PopulationData(end-2*t+1:end-t, :)];
%     
% end
% 
% Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
% Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
% 
% flag = 0;
% if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 2
%     flag = 1;
% end
% 
% 
% j = 2;
% while flag == 1
%     flag = 0;
%     
%     Sample1 = Sample2;
%     Stats1 = Stats2;
%     
%     Sample1 = PopulationData(end-j*t+1:end, :);
%     Sample1 = [Sample1; Sample2];
%     Stats1 = samplestats(Sample1(:,3) + Sample1(:,2))
%     
%     Sample2 = PopulationData(end-(j+1)*t+1:end-j*t, :);
%     for k = 2:TotalJobs
%         PopulationData = PopulationDataSet{k};
%         Sample2 = [Sample2; PopulationData(end-3*t+1:end-2*t, :)];
%     end
%     Stats2 = samplestats(Sample2(:,3) + Sample2(:,2))
%     
%     if sum(abs(Stats1 - Stats2) < eps*Stats1) == 2
%         flag = 1;
%         j = j+1;
%     end
%     disp(j);
%     
% end
% 
% 
% out = PopulationData(end,1) - j*0.6*t;
% display(j);
% disp(['(QD) Total cells in Equilibrium from approx t = '...
%     num2str(out)]);







%% ADF test for stationarity

% t = 200; % number of data points in each window
% eps = 0.1; % confidence interval
% 
% PopulationData = PopulationDataSet{1};
% Sample1 = PopulationData(end-t+1:end, :);
% Sample2 = PopulationData(end-2*t+1:end-t, :);
% 
% h = adftest(Sample1(:,3) + Sample1(:,2));
% disp(h)
% pause
% 
% for k = 2:TotalJobs
%     PopulationData = PopulationDataSet{k};
%     Sample1 = [Sample1; PopulationData(end-t+1:end, :)];
%     Sample2 = [Sample2; PopulationData(end-2*t+1:end-t, :)];
%     
% end
% 
% 
% 
% Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
% Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
% 
% flag = 0;
% if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 4
%     flag = 1;
% end
% 
% 
% j = 2;
% while flag == 1
%     flag = 0;
%     
%     Sample1 = Sample2;
%     Stats1 = Stats2;
%     
%     Sample2 = PopulationData(end-(j+1)*t+1:end-j*t, :);
%     for k = 2:TotalJobs
%         PopulationData = PopulationDataSet{k};
%         Sample2 = [Sample2; PopulationData(end-3*t+1:end-2*t, :)];
%     end
%     Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
%     
%     
%     if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 4
%         flag = 1;
%         j = j+1;
%     end
%     
%     disp(j)
%     
% end
% 
% 
% disp(['(ADF) Total cells in Equilibrium from approx t = '...
%     num2str(PopulationData(end,1) - j*0.6*t)]);



end






% % QD stationairty test (return time from finish when is total_pop is steady)
% This function partitions the timeseries data into windows and compares
% the sample statistics of neighbouring partitions. If the statstics agree
% with 1-eps confidence, it is accepted as a window where the distribution
% is stationary
% 
% t = 100; % number of data points in each window
% eps = 0.1; % confidence interval
% 
% PopulationData = PopulationDataSet{1};
% Sample1 = PopulationData(end-t+1:end, :);
% Sample2 = PopulationData(end-2*t+1:end-t, :);
% 
% for k = 2:TotalJobs
%     PopulationData = PopulationDataSet{k};
%     Sample1 = [Sample1; PopulationData(end-t+1:end, :)];
%     Sample2 = [Sample2; PopulationData(end-2*t+1:end-t, :)];
%     
% end
% 
% Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
% Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
% 
% flag = 0;
% if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 4
%     flag = 1;
% end
% 
% 
% j = 2;
% while flag == 1
%     flag = 0;
%     
%     Sample1 = Sample2;
%     Stats1 = Stats2;
%     
%     Sample2 = PopulationData(end-(j+1)*t+1:end-j*t, :);
%     for k = 2:TotalJobs
%         PopulationData = PopulationDataSet{k};
%         Sample2 = [Sample2; PopulationData(end-3*t+1:end-2*t, :)];
%     end
%     Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
%     
%     
%     if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 4
%         flag = 1;
%         j = j+1;
%     end
%     
% end
% 
% 
% disp(['(QD) Total cells in Equilibrium from approx t = '...
%     num2str(PopulationData(end,1) - j*0.6*t)]);



