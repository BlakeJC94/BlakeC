function Adhesion_Heights_Plots

addpath(genpath('PlotData/functions'));
close all;

load('PlotData/MAT/Adhesion_Heights.mat')

%%
fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];
left_color = [ 0 0.447 0.741];
right_color = [1 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);


yyaxis left
b = bar(ah_vec, proportions);
b.FaceColor = (1/255)*[0 191 255];
axis([min(ah_vec)-0.25, max(ah_vec)+0.25, 0, 1]);
ylabel('Proliferative cells / Total cells');

hold on;
for k = 1:length(sscounts)
    textheight = proportions(k) + 0.07;
    text_x = ah_vec(k) - 0.075;
%     if (model == 3) && (k == 6)
%         textposx = p(k) - 0.05;
%     end
    text(text_x,textheight, num2str(round(sscounts(k))), ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'white', ...
        'EdgeColor', 'black');
end
hold off;


yyaxis right
plot(ah_vec, ssonsets, 'r--*');
axis([min(ah_vec)-0.25, max(ah_vec)+0.25, 0, 250]);
ylabel('Time of steady state onset (h)');
xlabel('$$h_a$$', 'Interpreter', 'latex');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Adhesion_Heights_Plots/AH_SteadyStates',  11, 7/5, 15);



%% NEW
fig = figure;
fig.Units = 'centimeters';
fig.Position = [10 10 20 15];
left_color = [0 0 0];
right_color = [1 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);


yyaxis left
prolif_cell_count = proportions.*sscounts;
nonprolif_cell_count = sscounts - proportions.*sscounts;
b = bar(ah_vec,round([prolif_cell_count', nonprolif_cell_count']),'stacked');
b(1).FaceColor = (1/255)*[0 204 0];%green
b(2).FaceColor = (1/255)*[0 191 255];%blue
axis([min(ah_vec)-0.25, max(ah_vec)+0.25, 0, 250]);
ylabel('Total cells');


hold on;
for k = 1:length(sscounts)
    text_y = sscounts(k) + 15;
    text_x = ah_vec(k);
%     if (model == 3) && (k == 6)
%         textposx = p(k) - 0.05;
%     end
    text(text_x,text_y, num2str(round(100*proportions(k),1)), ...
        'HorizontalAlignment', 'center');
end
hold off;


yyaxis right
plot(ah_vec, ssonsets, 'r--*');
axis([min(ah_vec)-0.25, max(ah_vec)+0.25, 0, 250]);
ylabel('Time of steady state onset (h)');
xlabel('$$h_a$$', 'Interpreter', 'latex');
title('Steady state data ($$h_a$$)', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Adhesion_Heights_Plots/AH_SteadyStates_new',  11, 7/5, 15);





%%
figure;
plot(ah_vec, shapetotal,'k--*')
title('Slope (total cells)');
ylabel('Slope');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Adhesion_Heights_Plots/AH_Slope_total', 11, 7/5, 15);

%%
figure;
plot(ah_vec, shapeprolif,'b--*')
title('Slope (CM cells)');
ylabel('Slope');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Adhesion_Heights_Plots/AH_Slope_prolif', 11, 7/5, 15);

%%
figure;
plot(ah_vec, capheights,'r--*')
title('Cap height');
ylabel('Height');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Adhesion_Heights_Plots/AH_Cap_height', 11, 7/5, 15);


%%
disp('Done!')
end


