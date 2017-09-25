function AttRep_RadForce1_Plots

clear all;
close all;
load('PlotData/MAT/AttRep_RadForce1.mat')

figure;
plot(SimTime, TotalCells, 'k',...
    SimTime, TransitCells, 'b',...
    SimTime, RVCells, 'r',...
    SimTime, AttachedCells, 'g',...
    SimTime, TotalCells + TotalCellsStd, 'k:', ...
    SimTime, TotalCells - TotalCellsStd, 'k:');
legend('Total', 'CM cells', 'RV Cells', 'Attached cells',...
    'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
xlabel('Simulation time'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/RadForce1_PopulationTimeseries', 11, 7/5, 10);

figure;
cutoff = 300; 
plot(SimTime(1:cutoff), TotalCells(1:cutoff), 'k',...
    SimTime(1:cutoff), TransitCells(1:cutoff), 'b',...
    SimTime(1:cutoff), RVCells(1:cutoff), 'r',...
    SimTime(1:cutoff), AttachedCells(1:cutoff), 'g',...
    SimTime(1:cutoff), TotalCells(1:cutoff) + TotalCellsStd(1:cutoff), 'k:', ...
    SimTime(1:cutoff), TotalCells(1:cutoff) - TotalCellsStd(1:cutoff), 'k:');
legend('Total', 'CM cells', 'RV Cells', 'Attached cells',...
    'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
xlabel('Simulation time'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/RadForce1_PopulationTimeseries2', 11, 7/5, 10);



disp([' Time of onset : ' num2str(onsettime)]);
disp([' Total in steady state : ' num2str(totalcount)]);
disp([' Proportion of CM cells : ' num2str(proportion)]);
disp([' Slope of histogram (total cells) : ' num2str(slope_total)]);
disp([' Slope of histogram (CM cells) : ' num2str(slope_prolif)]);
disp([' Cap height : ' num2str(capheight_RF1)]);

steadystateshape(['PlotData/' data_path], 0, 1);
SaveAsPngEpsAndFig(-1,'Figures/RadForce1_HistogramTotal', 11, 7/5, 10);

steadystateshape(['PlotData/' data_path], 1, 1);
SaveAsPngEpsAndFig(-1,'Figures/RadForce1_HistogramProlif', 11, 7/5, 10);



end

