function ViewUtBudData(TotalJobs, BinSize_ux, BinSize_vx, BinSize_agex, BinSize_agey)
% ViewUtBudData: Produces data plots for batch data from UtericBudSimulation
%
%   Inputs: 
%       TotalJobs = total number of sims, match 'num_sims' in .sh file.
%       BinSize_ux = size of partition elements of x in 'Mean u vs x'
%       BinSize_vx = size of partition elements of x in 'Mean v vs x'
%       BinSize_agex = size of partition elements of x in 'Mean age vs x'
%       BinSize_agey = size of partition elements of x in 'Mean age vs y'
%       max_x = Right endpoint of largest partition element will be the
%           first integer multiple after this
%       max_y = Right endpoint of largest partition element will be the
%           first integer multiple after this
% 
%   Outputs:
%       AvPopulationDataOut = cell containing plot data for 'Mean no. 
%           cells vs time', values as specified in plot code.
%       AvHVelocityDataOut = cell containing plot data for 'Mean u vs x'.
%       AvVVelocityDataOut = cell containing plot data for 'Mean v vs x'.
%       AvHAgeDataOut = cell containing plot data for 'Mean age vs x'.
%       AvVAgeDataOut = cell containing plot data for 'Mean age vs y'.
%
% Default Args : ViewUtBudData(5, 2, 2, 1, 1, 40, 10)
% 
%% Add paths and set up

close all;
fontopt = {'FontSize',50,'FontWeight','bold'};

max_x = 20;
max_y = 5;

if nargin == 1
    BinSize_ux = 0.5;
    BinSize_vx = 0.5;
    BinSize_agex = 0.5;
    BinSize_agey = 0.5;
end

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));
addpath(genpath('testoutput/'));
tic;

%% Mean no. cells vs time
% Plots time series of the population count by ProliferativeType

PopulationData = importdata('testoutput/UtericBudSimulation_0/results_from_time_0/celltypescount.dat');
MeanPopulationData = PopulationData.data;

TotalCells_Sum1 = MeanPopulationData(:,3) + MeanPopulationData(:,2);
TotalCells_Sum2 = (MeanPopulationData(:,3) + MeanPopulationData(:,2)).^2;

Sum1 = MeanPopulationData;
Sum2 = MeanPopulationData.^2;

for k = 2:TotalJobs
    PopulationData = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
    
    TotalCells_Sum1 = TotalCells_Sum1 + PopulationData.data(:,3) + PopulationData.data(:,2);
    TotalCells_Sum2 = TotalCells_Sum2 + (PopulationData.data(:,3) + PopulationData.data(:,2)).^2;
    
    Sum1 = Sum1 + PopulationData.data;
    Sum2 = Sum2 + PopulationData.data.^2;
    
end

MeanPopulationData = Sum1/TotalJobs;
VarPopulationData = (TotalJobs*Sum2 - Sum1.^2)/(TotalJobs*(TotalJobs-1));

SimTime = MeanPopulationData(:,1);
DiffCells = MeanPopulationData(:,3);
TransitCells = MeanPopulationData(:,2);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);

AttachedCells = MeanPopulationData(:,5);
RVCells = MeanPopulationData(:,6);





figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);

plot(SimTime, TotalCells, 'k', SimTime, TransitCells, 'b',...
    SimTime, DiffCells, 'r', SimTime, RVCells, 'm', SimTime,  AttachedCells, 'g');

hold on;

TotalCellsStd = sqrt((TotalJobs*TotalCells_Sum2 - TotalCells_Sum1.^2)/(TotalJobs*(TotalJobs-1)));
% TotalCellsStd = sqrt(VarPopulationData();

plot(SimTime, TotalCells + TotalCellsStd, 'k:', ...
    SimTime, TotalCells - TotalCellsStd, 'k:');

hold off;

legend('Total', 'Proliferative', 'Non-Proliferative', 'RV Cells', 'Attached Cells', 'Location', 'Best');
title(['Average number of cells over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('Simulation time'); ylabel('No. of cells');
set(gcf,'PaperPositionMode','auto'); print('Fig01 Mean no. cells vs time', '-dpng', '-r0');



%% Mean u and v vs x
% Plots bar graph of horizonal velocities averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   u = velocity in x direction
%   v = velocity in y direction
% Size of partition elements specified by 'BinSize_ux' input.
% Maximum x specified by 'max_x' input.

VelocityData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
x = VelocityData{1}(3:5:end-3);
u = VelocityData{1}(5:5:end-1);
av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
v = VelocityData{1}(6:5:end);
av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
for j = 2:length(VelocityData)
    x = VelocityData{j}(3:5:end-3);
    u = VelocityData{j}(5:5:end-1);
    av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
    v = VelocityData{j}(6:5:end);
    av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
end
MeanHVelocityData = av_udata;
MeanVVelocityData = av_vdata;

for k = 2:TotalJobs
    VelocityData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
    x = VelocityData{1}(3:5:end-3);
    u = VelocityData{1}(5:5:end-1);
    av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
    v = VelocityData{1}(6:5:end);
    av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
    for j = 2:length(VelocityData)
        x = VelocityData{j}(3:5:end-3);
        u = VelocityData{j}(5:5:end-1);
        av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
        v = VelocityData{j}(6:5:end);
        av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
    end
    
    MeanHVelocityData = ((k-1)*MeanHVelocityData + av_udata)./k;
    MeanVVelocityData = ((k-1)*MeanVVelocityData + av_vdata)./k;
end

AvVelocityDataOut{1} = BinSize_ux*(0:numel(MeanHVelocityData));
AvVelocityDataOut{2} = MeanHVelocityData;

AvVelocityDataOut{3} = BinSize_vx*(0:numel(MeanVVelocityData));
AvVelocityDataOut{4} = MeanVVelocityData;

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
bar(BinSize_ux*(1:numel(MeanHVelocityData)) - (BinSize_ux/2), MeanHVelocityData);
title(['Average horizontal velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('u');
set(gcf,'PaperPositionMode','auto'); print('Fig02 Mean u vs x', '-dpng', '-r0');

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
bar(BinSize_vx*(1:numel(MeanVVelocityData)) - (BinSize_vx/2), MeanVVelocityData);
title(['Average vertical velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('v');
set(gcf,'PaperPositionMode','auto'); print('Fig03 Mean v vs x', '-dpng', '-r0');


%% Mean age vs x and y
% Plots bar graph of cell ages averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   y = vertical position
%   age = age of cell
% Size of partition elements specified by 'BinSize_agex' input.
% Maximum x specified by 'max_x' input.

AgeData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');
x = AgeData{end}(3:4:end-3);
y = AgeData{end}(4:4:end-2);
age = AgeData{end}(5:4:end-1);
av_agedata_x = barplotdatagen(x, age, BinSize_agex, max_x);
av_agedata_y = barplotdatagen(y, age, BinSize_agey, max_y);

MeanAgeXData = av_agedata_x;
MeanAgeYData = av_agedata_y;

for k = 2:TotalJobs
    AgeData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellages.dat']);
    x = AgeData{end}(3:4:end-3);
    y = AgeData{end}(4:4:end-2);
    age = AgeData{end}(5:4:end-1);
    av_agedata_x = barplotdatagen(x, age, BinSize_agex, max_x);
    av_agedata_y = barplotdatagen(y, age, BinSize_agey, max_y);
    
    MeanAgeXData = ((k-1)*MeanAgeXData + av_agedata_x)./k;
    MeanAgeYData = ((k-1)*MeanAgeYData + av_agedata_y)./k;
end

AvAgeDataOut{1} = BinSize_agex*(0:numel(MeanAgeXData));
AvAgeDataOut{2} = MeanAgeXData;

AvAgeDataOut{3} = BinSize_agey*(0:numel(MeanAgeYData));
AvAgeDataOut{4} = MeanAgeYData;

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
bar(BinSize_agex*(1:numel(MeanAgeXData)) - (BinSize_agex/2), MeanAgeXData);
title(['Cell age vs. horzontal position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig04 Mean age vs x end', '-dpng', '-r0');

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
bar(BinSize_agey*(1:numel(MeanAgeYData)) - (BinSize_agey/2), MeanAgeYData);
title(['Cell age vs. vertical position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('y'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig05 Mean age vs y end', '-dpng', '-r0');


%% Finish

toc

end



function av_data = barplotdatagen(x, u, bin_size, max)
% Partitions x into elements [0, bin_size), [bin_size, 2*bin_size), ...
% until after k*bin_size > max. Then isolate values of u that correspond to
% each partition element and average over each of them. Return average u
% value over each partition element as a vector.

partitions_total = ceil(max/bin_size);
av_data = zeros(1, partitions_total);
for k=1:partitions_total
    indicies = (bin_size*(k-1) <= x) .* (x < bin_size*k);
    tmpdata = u .* indicies;
    av_data(k) = sum(tmpdata)/sum(indicies);
    
%     Removing this check makes the data inflated, since this stops the
%     addition of NaNs?
    if sum(indicies) == 0
        av_data(k) = 0;
    end
end

end




%% Attachment time histogram (OLD CODE)
% Plots histogram of the attachment times

% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
% 
%     AttachmentData = cell(1,TotalJobs);
%     AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
%     MaxValue = ceil(max(AttachmentData{1}));
%     binranges = 0:MaxValue;
%     bincounts = histc(AttachmentData{1}, binranges);
% 
%     for k = 2:TotalJobs
%         AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
%         temp = ceil(max(AttachmentData{k}));
%         if temp > MaxValue
%             MaxValue = temp;
%             binranges = 0:MaxValue;
%         end
%         b = histc(AttachmentData{k}, binranges);
%         spacefill = zeros(1, abs(length(b) - length(bincounts)));
%         
%         bincounts = [bincounts, spacefill] + b;
%         
%     end
%     
%     figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
%     bar(binranges, bincounts, 'histc');
%     title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
%     xlabel('time'); ylabel('counts');
%     set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');
% 
%     AttachDataOut{1} = binranges;
%     AttachDataOut{2} = bincounts;
% 
% end