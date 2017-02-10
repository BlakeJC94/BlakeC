function [AvPopulationDataOut, AvVelocityDataOut,...
    AvAgeDataOut, AttachDataOut] = ViewUtBudData(TotalJobs, ...
    BinSize_ux, BinSize_vx, BinSize_agex, BinSize_agey)
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

% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/cellmutationstates.dat', 'file') ~= 0
%     AttachmentData = importdata('testoutput/UtericBudSimulation_0/results_from_time_0/cellmutationstates.dat');
%     MeanAttachmentData = AttachmentData.data;
% end

for k = 2:TotalJobs
    PopulationData = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
    MeanPopulationData = ((k-1)*MeanPopulationData + PopulationData.data)./k;
    
%     if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%         AttachmentData = importdata('testoutput/UtericBudSimulation_0/results_from_time_0/cellmutationstates.dat');
%         MeanAttachmentData = ((k-1)*MeanAttachmentData + AttachmentData.data)./k;
%     end
end

AvPopulationDataOut{1} = MeanPopulationData(:,1);
AvPopulationDataOut{2} = MeanPopulationData(:,4);
AvPopulationDataOut{3} = MeanPopulationData(:,3);
AvPopulationDataOut{4} = MeanPopulationData(:,4) + MeanPopulationData(:,3);

SimTime = AvPopulationDataOut{1};
DiffCells = AvPopulationDataOut{2};
TransitCells = AvPopulationDataOut{3};
TotalCells = AvPopulationDataOut{4};

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%     plot(SimTime, TotalCells, 'k', SimTime, DiffCells, 'r',...
%     SimTime, TransitCells, 'b', SimTime, MeanAttachmentData(:,3),'m');
% legend('Total', 'Differentiated', 'Transit', 'Attached', 'Location', 'Best');
% else
%     plot(SimTime, TotalCells, 'k', SimTime, DiffCells, 'r',...
%     SimTime, TransitCells, 'b');
% legend('Total', 'Differentiated', 'Transit', 'Location', 'Best');
% end

plot(SimTime, TotalCells, 'k', SimTime, DiffCells, 'r',...
    SimTime, TransitCells, 'b');
legend('Total', 'Differentiated', 'Transit', 'Location', 'Best');

title(['Average number of cells over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('simulation time'); ylabel('no. of cells');
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
title(['cell age vs. horzontal position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig04 Mean age vs x end', '-dpng', '-r0');

figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
bar(BinSize_agey*(1:numel(MeanAgeYData)) - (BinSize_agey/2), MeanAgeYData);
title(['cell age vs. vertical position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('y'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig05 Mean age vs y end', '-dpng', '-r0');


%% Attachment time histogram
% Plots histogram of the attachment times

if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0

    AttachmentData = cell(1,TotalJobs);
    AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
    MaxValue = ceil(max(AttachmentData{1}));
    binranges = 0:MaxValue;
    bincounts = histc(AttachmentData{1}, binranges);

    for k = 2:TotalJobs
        AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
        temp = ceil(max(AttachmentData{k}));
        if temp > MaxValue
            MaxValue = temp;
            binranges = 0:MaxValue;
        end
        b = histc(AttachmentData{k}, binranges);
        spacefill = zeros(1, abs(length(b) - length(bincounts)));
        
        bincounts = [bincounts, spacefill] + b;
        
    end
    
    figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
    bar(binranges, bincounts, 'histc');
    title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
    xlabel('time'); ylabel('counts');
    set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');

    AttachDataOut{1} = binranges;
    AttachDataOut{2} = bincounts;

end


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



%% Mean u vs x (OLD CODE)
% Plots bar graph of horizonal velocities averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   u = velocity in x direction
% Size of partition elements specified by 'BinSize_ux' input.
% Maximum x specified by 'max_x' input.

%%%%%% Revision 1

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% VelocityData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% x = VelocityData{end}(3:5:end-3);
% u = VelocityData{end}(5:5:end-1);
% av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
% 
% MeanHVelocityData = av_udata;
% 
% for k = 2:TotalJobs
%     VelocityData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
%     x = VelocityData{end}(3:5:end-3);
%     u = VelocityData{end}(5:5:end-1);
%     av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
%     % if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%     
%     AttachmentData = cell(1,TotalJobs);
%     AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
%     MaxValue = max(AttachmentData{1});
%     for k = 2:TotalJobs
%         AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
%         temp = max(AttachmentData{k});
%         if temp > MaxValue
%             MaxValue = temp;
%         end
%     end
%     
%     MaxValue = ceil(MaxValue);
%     binranges = 0:MaxValue;
%     
%     bincounts = histc(AttachmentData{1}, binranges);
%     for k = 2:TotalJobs
%         bincounts = bincounts + histc(AttachmentData{k}, binranges);
%     end
%     
%     figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
%     bar(binranges, bincounts, 'histc');
%     title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
%     xlabel('time'); ylabel('counts');
%     set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');
%     
% end

%     MeanHVelocityData = ((k-1)*MeanHVelocityData + av_udata)./k;
% end
% 
% AvHVelocityDataOut{1} = BinSize_ux*(0:numel(MeanHVelocityData));
% AvHVelocityDataOut{2} = MeanHVelocityData;
% 
% bar(BinSize_ux*(1:numel(MeanHVelocityData)) - (BinSize_ux/2), MeanHVelocityData);
% title(['Average horizontal velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('x'); ylabel('u');

%%%%%% Revision 2

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% VelocityData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% x = VelocityData{1}(3:5:end-3);
% u = VelocityData{1}(5:5:end-1);
% av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
% for j = 2:length(VelocityData)
%     x = VelocityData{j}(3:5:end-3);
%     u = VelocityData{j}(5:5:end-1);
%     av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
% end
% MeanHVelocityData = av_udata;
% 
% for k = 2:TotalJobs
%     VelocityData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
%     x = VelocityData{1}(3:5:end-3);
%     u = VelocityData{1}(5:5:end-1);
%     av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
%     for j = 2:length(VelocityData)
%         x = VelocityData{j}(3:5:end-3);
%         u = VelocityData{j}(5:5:end-1);
%         av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
%     end
%     
%     MeanHVelocityData = ((k-1)*MeanHVelocityData + av_udata)./k;
% end
% 
% AvHVelocityDataOut{1} = BinSize_ux*(0:numel(MeanHVelocityData));
% AvHVelocityDataOut{2} = MeanHVelocityData;
% 
% bar(BinSize_ux*(1:numel(MeanHVelocityData)) - (BinSize_ux/2), MeanHVelocityData);
% title(['Average horizontal velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('x'); ylabel('u');



%% Mean v vs x (OLD CODE)
% Plots bar graph of vertical velocities averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   v = velocity in y direction
% Size of partition elements specified by 'BinSize_vx' input.
% Maximum x specified by 'max_x' input.

%%%%%% Revision 1

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% VelocityData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% x = VelocityData{end}(3:5:end-3);
% v = VelocityData{end}(6:5:end);
% av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
% 
% MeanVVelocityData = av_vdata;
% 
% for k = 2:TotalJobs
%     VelocityData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
%     x = VelocityData{end}(3:5:end-3);
%     v = VelocityData{end}(6:5:end);
%     av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
%     
%     MeanVVelocityData = ((k-1)*MeanVVelocityData + av_vdata)./k;
% end
% 
% AvVVelocityDataOut{1} = BinSize_vx*(0:numel(MeanVVelocityData));
% AvVVelocityDataOut{2} = MeanVVelocityData;
% 
% bar(BinSize_vx*(1:numel(MeanVVelocityData)) - (BinSize_vx/2), MeanVVelocityData);
% title(['Average vertical velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('x'); ylabel('v');

%%%%%% Revision 2

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% VelocityData = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellvelocities.dat');
% x = VelocityData{1}(3:5% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%     
%     AttachmentData = cell(1,TotalJobs);
%     AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
%     MaxValue = max(AttachmentData{1});
%     for k = 2:TotalJobs
%         AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
%         temp = max(AttachmentData{k});
%         if temp > MaxValue
%             MaxValue = temp;
%         end
%     end
%     
%     MaxValue = ceil(MaxValue);
%     binranges = 0:MaxValue;
%     
%     bincounts = histc(AttachmentData{1}, binranges);
%     for k = 2:TotalJobs
%         bincounts = bincounts + histc(AttachmentData{k}, binranges);
%     end
%     
%     figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
%     bar(binranges, bincounts, 'histc');
%     title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
%     xlabel('time'); ylabel('counts');
%     set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');
%     
% end

% v = VelocityData{1}(6:5:end);
% av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
% for j = 2:length(VelocityData)
%     x = VelocityData{j}(3:5:end-3);
%     v = VelocityData{j}(6:5:end);
%     av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
% end
% MeanVVelocityData = av_vdata;
% 
% for k = 2:TotalJobs
%     VelocityData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
%     x = VelocityData{1}(3:5:end-3);
%     v = VelocityData{1}(6:5:end);
%     av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
%     for j = 2:length(VelocityData)
%         x = VelocityData{j}(3:5:end-3);
%         v = VelocityData{j}(6:5:end);
%         av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
%     end
%     
%     MeanVVelocityData = ((k-1)*MeanVVelocityData + av_vdata)./k;
% end
% 
% AvVVelocityDataOut{1} = BinSize_vx*(0:numel(MeanVVelocityData));
% AvVVelocityDataOut{2} = MeanVVelocityData;
% 
% bar(BinSize_vx*(1:numel(MeanVVelocityData)) - (BinSize_vx/2), MeanVVelocityData);
% title(['Average vertical velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('x'); ylabel('v');



%% Mean age vs x (OLD CODE)
% Plots bar graph of cell ages averaged over a partition of x on
% the last frame of the simulation.
%   x = horizontal position
%   age = age of cell
% Size of partition elements specified by 'BinSize_agex' input.
% Maximum x specified by 'max_x% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%     
%     AttachmentData = cell(1,TotalJobs);
%     AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
%     MaxValue = max(AttachmentData{1});
%     for k = 2:TotalJobs
%         AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
%         temp = max(AttachmentData{k});
%         if temp > MaxValue
%             MaxValue = temp;
%         end
%     end
%     
%     MaxValue = ceil(MaxValue);
%     binranges = 0:MaxValue;
%     
%     bincounts = histc(AttachmentData{1}, binranges);
%     for k = 2:TotalJobs
%         bincounts = bincounts + histc(AttachmentData{k}, binranges);
%     end
%     
%     figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
%     bar(binranges, bincounts, 'histc');
%     title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
%     xlabel('time'); ylabel('counts');
%     set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');
%     
% end

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% agedata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');
% x = agedata{end}(3:4:end-3);
% age = agedata{end}(5:4:end-1);
% av_agedata = barplotdatagen(x, age, BinSize_agex, max_x);
% 
% MeanAgeXData = av_agedata;
% 
% for k = 2:TotalJobs
%     agedata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellages.dat']);
%     x = agedata{end}(3:4:end-3);
%     age = agedata{end}(5:4:end-1);
%     av_agedata = barplotdatagen(x, age, BinSize_agex, max_x);
%     
%     MeanAgeXData = ((k-1)*MeanAgeXData + av_agedata)./k;
% end
% 
% AvHAgeDataOut{1} = BinSize_agex*(0:numel(MeanAgeXData));
% AvHAgeDataOut{2} = MeanAgeXData;
% 
% bar(BinSize_agex*(1:numel(MeanAgeXData)) - (BinSize_agex/2), MeanAgeXData);
% title(['cell age vs. horzontal position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('x'); ylabel('age');


%% Mean age vs y (OLD CODE)
% Plots bar graph of cell ages averaged over a partition of y on
% the last frame of the simulation.
%   y = vertical position
%   age = age of cell
% Size of partition elements specified by 'BinSize_agey' input.
% Maximum x specified by 'max_y' input.

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
% 
% agedata = LoadNonConstantLengthData('testoutput/UtericBudSimulation_0/results_from_time_0/cellages.dat');
% y = agedata{end}(4:4:end-2);
% age = agedata{end}(5:4:end-1);
% av_agedata = barplotdatagen(y, age, BinSize_agey, max_y);
% 
% MeanAgeYData = av_agedata;
% 
% for k = 2:TotalJobs
%     agedata = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellages.dat']);
%     y = agedata{end}(4:4:end-2);
%     age = agedata{end}(5:4:end-1);
%     av_agedata = barplotdatagen(y, age, BinSize_agey, max_y);
%     
%     MeanAgeYData = ((k-1)*MeanAgeYData + av_agedata)./k;
% end
% 
% AvVAgeDataOut{1} = BinSize_agey*(0:numel(MeanAgeYData));
% AvVAgeDataOut{2} = MeanAgeYData;
% 
% bar(BinSize_agey*(1:numel(MeanAgeYData)) - (BinSize_agey/2), MeanAgeYData);
% title(['cell age vs. vertical position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
% xlabel('y'); ylabel('age');




%% Attachment time histogram (OLD CODE)
% Plots histogram of the attachment times

% if exist('testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat', 'file') ~= 0
%     
%     AttachmentData = cell(1,TotalJobs);
%     AttachmentData{1} = importdata(['testoutput/UtericBudSimulation_0/results_from_time_0/attachmentdurations.dat']);
%     MaxValue = ceil(max(AttachmentData{1}));
%     for k = 2:TotalJobs
%         AttachmentData{k} = importdata(['testoutput/UtericBudSimulation_' num2str(k-1) '/results_from_time_0/attachmentdurations.dat']);
%         temp = max(AttachmentData{k});
%         if temp > MaxValue
%             MaxValue = temp;
%         end
%     end
%     
%     MaxValue = ceil(MaxValue);
%     binranges = 0:MaxValue;
%     
%     bincounts = histc(AttachmentData{1}, binranges);
%     for k = 2:TotalJobs
%         bincounts = bincounts + histc(AttachmentData{k}, binranges);
%     end
%     
%     figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
%     bar(binranges, bincounts, 'histc');
%     title(['Histogram of attachment times over ', num2str(TotalJobs), ' simulations'], fontopt{:});
%     xlabel('time'); ylabel('counts');
%     set(gcf,'PaperPositionMode','auto'); print('Fig06 Attachment time histogram', '-dpng', '-r0');
%     
% end
