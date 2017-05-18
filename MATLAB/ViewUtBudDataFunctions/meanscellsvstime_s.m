function meanscellsvstime_s(PopulationDataSet)
% Function that takes in population data (celltypescount.dat) and produces
% plots of average cell numbers vs time.

fontopt = {'FontSize',50,'FontWeight','bold'};

PopulationData = PopulationDataSet{1};
[~, TotalJobs] = size(PopulationDataSet);

TotalCells_Sum1 = PopulationData(:,3) + PopulationData(:,2);
TotalCells_Sum2 = (PopulationData(:,3) + PopulationData(:,2)).^2;

Sum1 = PopulationData;
Sum2 = PopulationData.^2;

for k = 2:TotalJobs
    PopulationData = PopulationDataSet{k};
    
    TotalCells_Sum1 = TotalCells_Sum1 + PopulationData(:,3) + PopulationData(:,2);
    TotalCells_Sum2 = TotalCells_Sum2 + (PopulationData(:,3) + PopulationData(:,2)).^2;
    
    Sum1 = Sum1 + PopulationData;
    Sum2 = Sum2 + PopulationData.^2;
    
end

MeanPopulationData = Sum1/TotalJobs;
%VarPopulationData = (TotalJobs*Sum2 - Sum1.^2)/(TotalJobs*(TotalJobs-1));

SimTime = MeanPopulationData(:,1);
DiffCells = MeanPopulationData(:,3);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

AttachedCells = MeanPopulationData(:,5);
RVCells = MeanPopulationData(:,6);

TotalCellsStd = sqrt((TotalJobs*TotalCells_Sum2 - TotalCells_Sum1.^2)/(TotalJobs*(TotalJobs-1)));

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.24]);
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




%% QD stationairty test (return time from finish when is total_pop is steady)
% This function partitions the timeseries data into windows and compares
% the sample statistics of neighbouring partitions. If the statstics agree
% with 1-eps confidence, it is accepted as a window where the distribution
% is stationary

% totalcellsteadystate(PopulationDataSet, TotalJobs);


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



