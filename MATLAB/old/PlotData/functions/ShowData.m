function ShowData( data_path )
%SHOWDATA Summary of this function goes here
%   Detailed explanation goes here

D = dir([data_path '*']);
TotalJobs = length(D(:));

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);

SimTime = MeanPopulationData(:,1);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

AttachedCells = MeanPopulationData(:,5);
RVCells = MeanPopulationData(:,6);

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
% SaveAsPngEpsAndFig(-1,'Figures/RadForce2_PopulationTimeseries', 11, 7/5, 10);

if length(MeanPopulationData(:,3)) < floor(SimTime(end)) % If simulation stopped due to >1000 cells,
    steadystate_flag = 0;
    onsettime = ceil(SimTime(end));
else
    onsettime = totalcellsteadystate(data_path);
    steadystate_flag = 1;
    if abs(onsettime - ceil(SimTime(end))) < 240
        steadystate_flag = 0;
    else
        line([onsettime,onsettime],[0, max(TotalCells + TotalCellsStd)],'LineStyle', '--', 'Color', 'black')
        steadystate_flag = 1;
    end
end

if steadystate_flag == 0
    [totalcount, proportion] = totalcellsteadystatecount(data_path,5);
    capheight_disp = capheight(data_path, 0, 5);
else
    [totalcount, proportion] = totalcellsteadystatecount(data_path);
    capheight_disp = capheight(data_path, 0);
end


if length(MeanPopulationData(:,3)) < floor(SimTime(end)) % If simulation stopped due to >1000 cells,
    totalcount = 1000;
end



figure;
slope_total = steadystateshape(data_path, 0, 1);
figure;
slope_prolif = steadystateshape(data_path, 1, 1);


if steadystate_flag == 0
    disp([' Time of onset : ' num2str(onsettime) ' (Does not reach steady state) ']);
else
    disp([' Time of onset : ' num2str(onsettime)]);
end
disp([' Total in steady state : ' num2str(totalcount)]);
disp([' Proportion of CM cells : ' num2str(proportion)]);
disp([' Slope of histogram (total cells) : ' num2str(slope_total)]);
disp([' Slope of histogram (CM cells) : ' num2str(slope_prolif)]);
disp([' Cap height : ' num2str(capheight_disp)]);

end

