function Affinity_Plots

close all;
load(['PlotData/MAT/Affinity.mat']);

for model = 2:4

    p = p_cell{model-1};
    
    steadystateonset = steadystateonset_cell{model-1};
    proportions = proportions_cell{model-1};
    steadystateval = steadystateval_cell{model-1};
%     shapeslope_total = shapeslope_total_cell{model-1};
%     shapeslope_prolif = shapeslope_prolif_cell{model-1};
    steadystate_flag = steadystate_flag_cell{model-1};
    
    
    fig = figure;
    fig.Units = 'centimeters';
    fig.Position = [10 10 20 15];
    left_color = [ 0 0.447 0.741];
    right_color = [1 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);
    
    
    yyaxis left
    b = bar(p,proportions);
    b.FaceColor = (1/255)*[0 191 255];
    axis([min(p)-0.1, max(p)+0.1, 0, 1]);
    ylabel('Proliferative cells / Total cells','FontSize',15);
    
    hold on;
    for k = 1:length(steadystateval)
        text_y = proportions(k) + 0.07;
        text_x = p(k);
        text(text_x,text_y, num2str(round(steadystateval(k))), ...
            'HorizontalAlignment', 'center', ...
            'BackgroundColor', 'white', ...
            'EdgeColor', 'black');
    end
    hold off;
    
    yyaxis right
    plot(p, steadystateonset, 'r--');
    axis([min(p)-0.05, max(p)+0.05, 0, 1000]);
    if model == 2
        axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
    end
    ylabel('Average time of steady state onset (h)','FontSize',15);
    hold on;
    scatter(p(steadystate_flag==1), steadystateonset(steadystate_flag==1), 'r*');
    scatter(p(steadystate_flag==0), steadystateonset(steadystate_flag==0), 'ro');
    hold off;
    
    title(['Steady state onset data for B_' num2str(5 - model) '(x)' ], 'FontSize',15,'FontWeight','bold');
    xlabel('\alpha','FontSize',15);
    
    SaveAsPngEpsAndFig(-1,['Figures/steadystates' num2str(5 - model)], 14, 7/5, 10);
end

%% New

for model = 2:4
    p = p_cell{model-1};
    
    steadystateonset = steadystateonset_cell{model-1};
    proportions = proportions_cell{model-1};
    steadystateval = steadystateval_cell{model-1};
%     shapeslope_total = shapeslope_total_cell{model-1};
%     shapeslope_prolif = shapeslope_prolif_cell{model-1};
    steadystate_flag = steadystate_flag_cell{model-1};
    
    
    fig = figure;
    fig.Units = 'centimeters';
    fig.Position = [10 10 20 15];
    left_color = [0 0 0];
    right_color = [1 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);
    
    
    yyaxis left
    prolif_cell_count = proportions.*steadystateval;
    nonprolif_cell_count = steadystateval - proportions.*steadystateval;
    b = bar(p,round([prolif_cell_count, nonprolif_cell_count]),'stacked');
    b(1).FaceColor = (1/255)*[0 204 0];%green 
    b(2).FaceColor = (1/255)*[0 191 255];%blue
    axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
    ylabel('Total cells','FontSize',15);
    
    hold on;
    for k = 1:length(steadystateval)
        
        if  steadystateval(k) > 900
            text_y = steadystateval(k) - 50;
        else
            text_y = steadystateval(k) + 50;
        end
        
        text_x = p(k);
        
        
        text(text_x,text_y, num2str(round(100*proportions(k),1)), ...
            'HorizontalAlignment', 'center');
    end
    hold off;
    
    yyaxis right
    plot(p, steadystateonset, 'r--');
    axis([min(p)-0.05, max(p)+0.05, 0, 1000]);
    if model == 2
        axis([min(p)-0.1, max(p)+0.1, 0, 1000]);
    end
    ylabel('Average time of steady state onset (h)','FontSize',15);
    hold on;
    scatter(p(steadystate_flag==1), steadystateonset(steadystate_flag==1), 'r*');
    scatter(p(steadystate_flag==0), steadystateonset(steadystate_flag==0), 'ro');
    hold off;
    
    title(['Steady state onset data for B_' num2str(5 - model) '(x)' ], 'FontSize',15,'FontWeight','bold');
    xlabel('\alpha','FontSize',15);
    
    SaveAsPngEpsAndFig(-1,['Figures/steadystates' num2str(5 - model) '_new'], 14, 7/5, 10);
end

%% 

figure;
plot(20*p_cell{4-1}(steadystate_flag_cell{4-1} == 1), proportions_cell{4-1}(steadystate_flag_cell{4-1} == 1),'r*--',...
    10*p_cell{3-1}(steadystate_flag_cell{3-1} == 1), proportions_cell{3-1}(steadystate_flag_cell{3-1} == 1),'b*--',...
    10*p_cell{2-1}(steadystate_flag_cell{2-1} == 1), proportions_cell{2-1}(steadystate_flag_cell{2-1} == 1),'m*--');

axis([1 10 0 0.8]);
ylabel('Ratio of proliferative cells to total cells','FontSize',15);

hold on;
for model = 2:4
    
    steadystateval = steadystateval_cell{model-1}(steadystate_flag_cell{model-1} == 1);
    proportions = proportions_cell{model-1}(steadystate_flag_cell{model-1} == 1);
    
    area = 10*(1+(model==4))*p_cell{model-1}(steadystate_flag_cell{model-1} == 1);
    for k = 1:length(steadystateval)
        textheight = proportions(k) - 0.025;

%             text(area(k),textheight, num2str(round(steadystateval(k))), ...
%                 'HorizontalAlignment', 'left', ...
%                 'BackgroundColor', 'white', ...
%                 'EdgeColor', 'black');
            text(area(k),textheight, num2str(round(steadystateval(k))), ...
                'HorizontalAlignment', 'left');

    end
end
hold off;

legend('1: Step', '2: Linear', '3: Ramp','Location','northwest');
title('Steady state cell composition vs. area', 'FontSize',15,'FontWeight','bold');
xlabel('Area under B','FontSize',15);

SaveAsPngEpsAndFig(-1,'Figures/areaplot1', 14, 7/5, 10);

%%

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*p_cell{4-1}(steadystate_flag_cell{4-1}==1), shapeslope_total_cell{4-1}(steadystate_flag_cell{4-1}==1),'r*--',...
    10*p_cell{3-1}(steadystate_flag_cell{3-1}==1), shapeslope_total_cell{3-1}(steadystate_flag_cell{3-1}==1),'b*--',...
    10*p_cell{2-1}(steadystate_flag_cell{2-1}==1), shapeslope_total_cell{2-1}(steadystate_flag_cell{2-1}==1),'m*--');
legend('1: Step', '2: Linear', '3: Ramp','Location','northwest');
%axis([1 10 -0.05 -0.01]);
title('Shape vs. area (Total cells)', 'FontSize',15,'FontWeight','bold');
xlabel('Area under B','FontSize',15);
ylabel('Histogram slope','FontSize',15);

SaveAsPngEpsAndFig(-1,'Figures/areaplot2', 11, 7/5, 10);


%%

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*p_cell{4-1}(steadystate_flag_cell{4-1}==1), shapeslope_prolif_cell{4-1}(steadystate_flag_cell{4-1}==1),'r*--',...
    10*p_cell{3-1}(steadystate_flag_cell{3-1}==1), shapeslope_prolif_cell{3-1}(steadystate_flag_cell{3-1}==1),'b*--',...
    10*p_cell{2-1}(steadystate_flag_cell{2-1}==1), shapeslope_prolif_cell{2-1}(steadystate_flag_cell{2-1}==1),'m*--');
%legend('1: Step', '2: Linear', '3: Ramp','Location','northwest');
%axis([1 10 -0.05 -0.01]);
title('Shape vs. area (CM cells)', 'FontSize',15,'FontWeight','bold');
xlabel('Area under B','FontSize',15);
ylabel('Histogram slope','FontSize',15);

SaveAsPngEpsAndFig(-1,'Figures/areaplot3', 11, 7/5, 10);


%%

fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];

plot(20*p_cell{4-1}(steadystate_flag_cell{4-1}==1), cap_height_cell{4-1}(steadystate_flag_cell{4-1}==1),'r*--',...
    10*p_cell{3-1}(steadystate_flag_cell{3-1}==1), cap_height_cell{3-1}(steadystate_flag_cell{3-1}==1),'b*--',...
    10*p_cell{2-1}(steadystate_flag_cell{2-1}==1), cap_height_cell{2-1}(steadystate_flag_cell{2-1}==1),'m*--');
%legend('1: Step', '2: Linear', '3: Ramp','Location','northwest');
%axis([1 10 -0.05 -0.01]);
title('Cap height vs. area', 'FontSize',15,'FontWeight','bold');
xlabel('Area under B','FontSize',15);
ylabel('Cap height','FontSize',15);

SaveAsPngEpsAndFig(-1,'Figures/areaplot4', 14, 7/5, 10);

disp('Done!');

end

