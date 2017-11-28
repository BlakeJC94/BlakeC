function AttRep_RadForce1_Plots

clear all;
close all;
load('PlotData/MAT/AttRep_RadForce1.mat')

figure;
plot(SimTime, TotalCells, 'k',...
    SimTime, TransitCells, 'b',...
    SimTime, RVCells, 'r',...
    SimTime, AttachedCells, 'm',...
    SimTime, TotalCells + TotalCellsStd, 'k--', ...
    SimTime, TotalCells - TotalCellsStd, 'k--');
legend('Total', 'CM cells', 'RV Cells', 'Attached cells',...
    'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations']);
xlabel('Simulation time'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce1_Plots/RadForce1_PopulationTimeseries', 14, 7/5, 16);

figure;
cutoff = 280; 
plot(SimTime(1:cutoff), TotalCells(1:cutoff), 'k',...
    SimTime(1:cutoff), TransitCells(1:cutoff), 'b',...
    SimTime(1:cutoff), RVCells(1:cutoff), 'r',...
    SimTime(1:cutoff), AttachedCells(1:cutoff), 'm',...
    SimTime(1:cutoff), TotalCells(1:cutoff) + TotalCellsStd(1:cutoff), 'k--', ...
    SimTime(1:cutoff), TotalCells(1:cutoff) - TotalCellsStd(1:cutoff), 'k--');
legend('Total', 'CM cells', 'RV Cells', 'Attached cells',...
    'Location', 'Best');
title(['Average number of cells']);
xlabel('Simulation time (h)'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce1_Plots/RadForce1_PopulationTimeseries2', 14, 7/5, 16);



disp([' Time of onset : ' num2str(onsettime)]);
disp([' Total in steady state : ' num2str(totalcount)]);
disp([' Proportion of CM cells : ' num2str(proportion)]);
disp([' Slope of histogram (total cells) : ' num2str(slope_total)]);
disp([' Slope of histogram (CM cells) : ' num2str(slope_prolif)]);
disp([' Cap height : ' num2str(capheight_RF1)]);

steadystateshape(['PlotData/' data_path], 0, 1);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce1_Plots/RadForce1_HistogramTotal', 14, 7/5, 16);

steadystateshape(['PlotData/' data_path], 1, 1);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce1_Plots/RadForce1_HistogramProlif', 14, 7/5, 16);



end

