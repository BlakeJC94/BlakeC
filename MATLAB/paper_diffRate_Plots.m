function paper_diffRate_Plots

% load dependencies
addpath(genpath('src/common/'));
addpath(genpath('src/diffRate/'));

% declare variables
figureDir = 'output/diffRate/';
dataDir = 'data/diffRate/';

% check output dir
if ~exist(figureDir, 'dir')
   mkdir(figureDir)
end

load(strcat(dataDir, 'diffRate_paper.mat'), 'p_cell', 'steadystate_flag_cell', 'proportions_cell', 'steadystateval_cell', 'cap_height_cell');


%% STEADY STATE COMPOSITON VS AREA
% 
fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{1}(steadystate_flag_cell{1} == 1)), proportions_cell{1}(steadystate_flag_cell{1} == 1),'ko-',...
    10*(2 - p_cell{2}(steadystate_flag_cell{2} == 1)), proportions_cell{2}(steadystate_flag_cell{2} == 1),'ks--',...
    10*(2 - p_cell{3}(steadystate_flag_cell{3} == 1)), proportions_cell{3}(steadystate_flag_cell{3} == 1),'k^-.');

axis([8 20 0 1]);
ylabel('Proliferative cells / Total cells','Interpreter','latex');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
title('Steady state cell composition vs. area','Interpreter','latex');
xlabel('Area under $$p(x)$$','Interpreter','latex');

SaveAsPngEpsAndFig(-1, strcat(figureDir, 'areaplot1'), 11, 7/5, 15);
close

%% Average total population vs. area

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{1}(steadystate_flag_cell{1} == 1)), steadystateval_cell{1}(steadystate_flag_cell{1} == 1),'ko-',...
    10*(2 - p_cell{2}(steadystate_flag_cell{2} == 1)), steadystateval_cell{2}(steadystate_flag_cell{2} == 1),'ks--',...
    10*(2 - p_cell{3}(steadystate_flag_cell{3} == 1)), steadystateval_cell{3}(steadystate_flag_cell{3} == 1),'k^-.');

axis([8 20 100 600]);
ylabel('Total cells','Interpreter','latex');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
title('Average total population vs. area','Interpreter','latex');
xlabel('Area under $$p(x)$$','Interpreter','latex');

SaveAsPngEpsAndFig(-1, strcat(figureDir, 'areaplot2'), 11, 7/5, 15);
close


close

%% Cap height vs. area

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{1}(steadystate_flag_cell{1} == 1)), cap_height_cell{1}(steadystate_flag_cell{1}==1),'ko-',...
    10*(2 - p_cell{2}(steadystate_flag_cell{2} == 1)), cap_height_cell{2}(steadystate_flag_cell{2}==1),'ks--',...
    10*(2 - p_cell{3}(steadystate_flag_cell{3} == 1)), cap_height_cell{3}(steadystate_flag_cell{3}==1),'k^-.');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
axis([8 20 4 10]);

title('Cap height vs. area');
xlabel('Area under $$p(x)$$','Interpreter','latex');
ylabel('Cap height');

SaveAsPngEpsAndFig(-1, strcat(figureDir, 'areaplot5'), 11, 7/5, 15);
close 


disp('Pass!');

end


%
% load(strcat(dataDir, 'Affinity_paper.mat'), 'p_cell', 'steadystate_flag_cell', 'shapeslope_total_cell', 'shapeslope_prolif_cell');
% 
% %% Shape vs. area (Total)
% 
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% plot(20*(1 - p_cell{1}(steadystate_flag_cell{1} == 1)), shapeslope_total_cell{1}(steadystate_flag_cell{1}==1),'ko-',...
%     10*(2 - p_cell{2}(steadystate_flag_cell{2} == 1)), shapeslope_total_cell{2}(steadystate_flag_cell{2}==1),'ks--',...
%     10*(2 - p_cell{3}(steadystate_flag_cell{3} == 1)), shapeslope_total_cell{3}(steadystate_flag_cell{3}==1),'k^-.');
% 
% legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
% axis([8 20 -3.5e-3 -1e-3]);
% 
% title('Shape vs. area (Total)');
% xlabel('Area under $$p(x)$$','Interpreter','latex');
% ylabel('Histogram slope');
% 
% SaveAsPngEpsAndFig(-1, strcat(figureDir, 'areaplot3'), 11, 7/5, 15);
% close
% 
% %% Shape vs. area (CM)
% 
% fig = figure;
% fig.Units = 'centimeters';
% fig.Position = [10 10 20 15];
% 
% plot(20*(1 - p_cell{1}(steadystate_flag_cell{1} == 1)), shapeslope_prolif_cell{1}(steadystate_flag_cell{1}==1),'ko-',...
%     10*(2 - p_cell{2}(steadystate_flag_cell{2} == 1)), shapeslope_prolif_cell{2}(steadystate_flag_cell{2}==1),'ks--',...
%     10*(2 - p_cell{3}(steadystate_flag_cell{3} == 1)), shapeslope_prolif_cell{3}(steadystate_flag_cell{3}==1),'k^-.');
% 
% legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
% axis([8 20 -3e-3 5.5e-3]);
% 
% title('Shape vs. area (CM)');
% xlabel('Area under $$p(x)$$','Interpreter','latex');
% ylabel('Histogram slope');
% 
% SaveAsPngEpsAndFig(-1, strcat(figureDir, 'areaplot4'), 11, 7/5, 15);

