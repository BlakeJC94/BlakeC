function AttRep_RadForce2_Plots

clear all;
close all;
load('PlotData/MAT/AttRep_RadForce2.mat')

plot(SimTime, TotalCells, 'k',...
    SimTime, TransitCells, 'b',...
    SimTime, RVCells, 'r',...
    SimTime, AttachedCells, 'm',...
    SimTime, TotalCells + TotalCellsStd, 'k--', ...
    SimTime, TotalCells - TotalCellsStd, 'k--');
p = legend('Total', 'CM cells', 'RV Cells', 'Attached cells','Location','Best');
p.Position(1:2) = [0.5755 0.5715];
title(['Average number of cells']);
xlabel('Simulation time (h)'); ylabel('No. of cells');
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce2_Plots/RadForce2_PopulationTimeseries',14, 7/5, 16);


disp([' Time of onset : ' num2str(onsettime)]);
disp([' Total in steady state : ' num2str(totalcount)]);
disp([' Proportion of CM cells : ' num2str(proportion)]);
disp([' Slope of histogram (total cells) : ' num2str(slope_total)]);
disp([' Slope of histogram (CM cells) : ' num2str(slope_prolif)]);
disp([' Cap height : ' num2str(capheight_RF2)]);


steadystateshape(['PlotData/' data_path], 0, 1);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce2_Plots/RadForce2_HistogramTotal', 14, 7/5, 16);

steadystateshape(['PlotData/' data_path], 1, 1);
axis([0 20 0 0.08]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_RadForce2_Plots/RadForce2_HistogramProlif', 14, 7/5, 16);



end

