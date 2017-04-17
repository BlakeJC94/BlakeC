function meanscellsvstime(PopulationDataSet)
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
     SimTime, TotalCells + TotalCellsStd, 'k:', ...
     SimTime, TotalCells - TotalCellsStd, 'k:', ...
     SimTime, TransitCells, 'b',...
     SimTime, DiffCells, 'r',...
     SimTime, RVCells, 'm',...
     SimTime, AttachedCells, 'g');

legend('Total', 'Proliferative', 'Non-Proliferative',...
    'RV Cells', 'Attached Cells', 'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('Simulation time'); ylabel('No. of cells');
set(gcf,'PaperPositionMode','auto'); print('Fig01', '-dpng', '-r0');


end