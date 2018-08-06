function Affinity_Plots_Paper

close all;
addpath(genpath('PlotData/functions'));
load(['PlotData/MAT/Affinity.mat']);

% for model = 2:4
% 
%     p = p_cell{model-1};
%     
%     steadystateonset = steadystateonset_cell{model-1};
%     proportions = proportions_cell{model-1};
%     steadystateval = steadystateval_cell{model-1};
% %     shapeslope_total = shapeslope_total_cell{model-1};
% %     shapeslope_prolif = shapeslope_prolif_cell{model-1};
%     steadystate_flag = steadystate_flag_cell{model-1};
%     
%     
%     fig = figure;
%     fig.Units = 'centimeters';
%     fig.Position = [10 10 20 15];
%     left_color = [ 0 0.447 0.741];
%     right_color = [1 0 0];
%     set(fig,'defaultAxesColorOrder',[left_color; right_color]);
%     
%     
%     yyaxis left
%     b = bar(p,proportions);
%     b.FaceColor = (1/255)*[0 191 255];
%     axis([min(p)-0.1, max(p)+0.1, 0, 1]);
%     ylabel('Proliferative cells / Total cells');
%     
%     hold on;
%     for k = 1:length(steadystateval)
%         text_y = proportions(k) + 0.07;
%         text_x = p(k);
%         text(text_x,text_y, num2str(round(steadystateval(k))), ...
%             'HorizontalAlignment', 'center', ...
%             'BackgroundColor', 'white', ...
%             'EdgeColor', 'black');
%     end
%     hold off;
%     
%     yyaxis right
%     plot(p, steadystateonset, 'r--');
%     axis([min(p)-0.05, max(p)+0.05, 0, 1000]);
%     if model == 2
%         axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
%     end
%     ylabel('Time of steady state onset (h)');
%     hold on;
%     scatter(p(steadystate_flag==1), steadystateonset(steadystate_flag==1), 'r*');
%     scatter(p(steadystate_flag==0), steadystateonset(steadystate_flag==0), 'ro');
%     hold off;
%     
%     title(['Steady state data for $$B_' num2str(5 - model) '(x)$$' ], 'Interpreter', 'latex');
%     xlabel('\alpha');
%     
%     %%SaveAsPngEpsAndFig(-1,['Figures/Affinity_Plots/steadystates' num2str(5 - model)], 14, 7/5, 13);
% end

% %% New
% 
% for model = 2:4
%     p = p_cell{model-1};
%     
%     steadystateonset = steadystateonset_cell{model-1};
%     proportions = proportions_cell{model-1};
%     steadystateval = steadystateval_cell{model-1};
% %     shapeslope_total = shapeslope_total_cell{model-1};
% %     shapeslope_prolif = shapeslope_prolif_cell{model-1};
%     steadystate_flag = steadystate_flag_cell{model-1};
%     
%     
%     fig = figure;
%     fig.Units = 'centimeters';
%     fig.Position = [10 10 20 15];
%     left_color = [0 0 0];
%     right_color = [1 0 0];
%     set(fig,'defaultAxesColorOrder',[left_color; right_color]);
%     
%     
%     yyaxis left
%     prolif_cell_count = proportions.*steadystateval;
%     nonprolif_cell_count = steadystateval - proportions.*steadystateval;
%     b = bar(p,round([prolif_cell_count, nonprolif_cell_count]),'stacked');
%     b(1).FaceColor = (1/255)*[0 204 0];%green 
%     b(2).FaceColor = (1/255)*[0 191 255];%blue
%     axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
%     ylabel('Total cells');
%     
%     hold on;
%     for k = 1:length(steadystateval)
%         
%         if  steadystateval(k) > 900
%             text_y = steadystateval(k) - 50;
%         else
%             text_y = steadystateval(k) + 50;
%         end
%         
%         text_x = p(k);
%         
%         
%         text(text_x,text_y, num2str(round(100*proportions(k),1)), ...
%             'HorizontalAlignment', 'center');
%     end
%     hold off;
%     
%     yyaxis right
%     plot(p, steadystateonset, 'r--');
%     axis([min(p)-0.05, max(p)+0.05, 0, 1000]);
%     if model == 2
%         axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
%     end
%     ylabel('Time of steady state onset (h)');
%     hold on;
%     scatter(p(steadystate_flag==1), steadystateonset(steadystate_flag==1), 'r*');
%     scatter(p(steadystate_flag==0), steadystateonset(steadystate_flag==0), 'ro');
%     hold off;
%     
%     title(['Steady state data for $$B_' num2str(5 - model) '(x)$$' ], 'Interpreter', 'latex');
%     xlabel('\alpha');
%     
%     %%SaveAsPngEpsAndFig(-1,['Figures/Affinity_Plots/steadystates' num2str(5 - model) '_new'], 14, 7/5, 13);
% end
% 
%% STEADY STATE COMPOSITON VS AREA
% 
figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

% plot(20*p_cell{4-1}(steadystate_flag_cell{4-1} == 1), proportions_cell{4-1}(steadystate_flag_cell{4-1} == 1),'ko-',...
%     10*p_cell{3-1}(steadystate_flag_cell{3-1} == 1), proportions_cell{3-1}(steadystate_flag_cell{3-1} == 1),'ks--',...
%     10*p_cell{2-1}(steadystate_flag_cell{2-1} == 1), proportions_cell{2-1}(steadystate_flag_cell{2-1} == 1),'k^-.');

plot(20*(1 - p_cell{4-1}(steadystate_flag_cell{4-1} == 1)), proportions_cell{4-1}(steadystate_flag_cell{4-1} == 1),'ko-',...
    10*(2 - p_cell{3-1}(steadystate_flag_cell{3-1} == 1)), proportions_cell{3-1}(steadystate_flag_cell{3-1} == 1),'ks--',...
    10*(2 - p_cell{2-1}(steadystate_flag_cell{2-1} == 1)), proportions_cell{2-1}(steadystate_flag_cell{2-1} == 1),'k^-.');

axis([10 20 0 0.8]);
ylabel('Proliferative cells / Total cells','Interpreter','latex');


legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
title('Steady state cell composition vs. area','Interpreter','latex');
xlabel('Area under $$p(x)$$','Interpreter','latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/Affinity_Plots/areaplot1', 11, 7/5, 15);
close

%% Average total population vs. area

figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{4-1}(steadystate_flag_cell{4-1} == 1)), steadystateval_cell{4-1}(steadystate_flag_cell{4-1} == 1),'ko-',...
    10*(2 - p_cell{3-1}(steadystate_flag_cell{3-1} == 1)), steadystateval_cell{3-1}(steadystate_flag_cell{3-1} == 1),'ks--',...
    10*(2 - p_cell{2-1}(steadystate_flag_cell{2-1} == 1)), steadystateval_cell{2-1}(steadystate_flag_cell{2-1} == 1),'k^-.');

axis([10 20 100 400]);
ylabel('Total cells','Interpreter','latex');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
title('Average total population vs. area','Interpreter','latex');
xlabel('Area under $$p(x)$$','Interpreter','latex');

SaveAsPngEpsAndFig(-1,'Figures/Paper/Affinity_Plots/areaplot2', 11, 7/5, 15);
close

%% Shape vs. area (Total)

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{4-1}(steadystate_flag_cell{4-1} == 1)), shapeslope_total_cell{4-1}(steadystate_flag_cell{4-1}==1),'ko-',...
    10*(2 - p_cell{3-1}(steadystate_flag_cell{3-1} == 1)), shapeslope_total_cell{3-1}(steadystate_flag_cell{3-1}==1),'ks--',...
    10*(2 - p_cell{2-1}(steadystate_flag_cell{2-1} == 1)), shapeslope_total_cell{2-1}(steadystate_flag_cell{2-1}==1),'k^-.');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
axis([10 20 -3.3e-3 -1.5e-3]);

title('Shape vs. area (Total)');
xlabel('Area under $$p(x)$$','Interpreter','latex');
ylabel('Histogram slope');

SaveAsPngEpsAndFig(-1,'Figures/Paper/Affinity_Plots/areaplot3', 11, 7/5, 15);
close

%% Shape vs. area (CM)

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{4-1}(steadystate_flag_cell{4-1} == 1)), shapeslope_prolif_cell{4-1}(steadystate_flag_cell{4-1}==1),'ko-',...
    10*(2 - p_cell{3-1}(steadystate_flag_cell{3-1} == 1)), shapeslope_prolif_cell{3-1}(steadystate_flag_cell{3-1}==1),'ks--',...
    10*(2 - p_cell{2-1}(steadystate_flag_cell{2-1} == 1)), shapeslope_prolif_cell{2-1}(steadystate_flag_cell{2-1}==1),'k^-.');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
axis([10 20 -2.4e-3 4.0e-3]);

title('Shape vs. area (CM)');
xlabel('Area under $$p(x)$$','Interpreter','latex');
ylabel('Histogram slope');

SaveAsPngEpsAndFig(-1,'Figures/Paper/Affinity_Plots/areaplot4', 11, 7/5, 15);
close

%% Cap height vs. area

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*(1 - p_cell{4-1}(steadystate_flag_cell{4-1} == 1)), cap_height_cell{4-1}(steadystate_flag_cell{4-1}==1),'ko-',...
    10*(2 - p_cell{3-1}(steadystate_flag_cell{3-1} == 1)), cap_height_cell{3-1}(steadystate_flag_cell{3-1}==1),'ks--',...
    10*(2 - p_cell{2-1}(steadystate_flag_cell{2-1} == 1)), cap_height_cell{2-1}(steadystate_flag_cell{2-1}==1),'k^-.');

legend('1: Step', '2: Linear', '3: Ramp','Location','northeast');
axis([10 20 4 9]);

title('Cap height vs. area');
xlabel('Area under $$p(x)$$','Interpreter','latex');
ylabel('Cap height');

SaveAsPngEpsAndFig(-1,'Figures/Paper/Affinity_Plots/areaplot5', 11, 7/5, 15);
close 

disp('Done!');

end
