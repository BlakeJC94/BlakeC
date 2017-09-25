function AttRep_RadForce2_Plots

clear all;
close all;
load('PlotData/MAT/AttRep_RadForce2.mat')

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
SaveAsPngEpsAndFig(-1,'Figures/RadForce2_PopulationTimeseries', 11, 7/5, 10);


disp([' Time of onset : ' num2str(onsettime)]);
disp([' Total in steady state : ' num2str(totalcount)]);
disp([' Proportion of CM cells : ' num2str(proportion)]);
disp([' Slope of histogram (total cells) : ' num2str(slope_total)]);
disp([' Slope of histogram (CM cells) : ' num2str(slope_prolif)]);
disp([' Cap height : ' num2str(capheight_RF2)]);


steadystateshape(['PlotData/' data_path], 0, 1);
SaveAsPngEpsAndFig(-1,'Figures/RadForce2_HistogramTotal', 11, 7/5, 10);

steadystateshape(['PlotData/' data_path], 1, 1);
SaveAsPngEpsAndFig(-1,'Figures/RadForce2_HistogramProlif', 11, 7/5, 10);



end

