function Adhesion_Heights_Plots

addpath(genpath('PlotData/functions'));
close all;

load('PlotData/MAT/Adhesion_Heights.mat')

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
ylabel('Proliferative cells / Total cells','FontSize',15);

hold on;
for k = 1:length(sscounts)
    textheight = proportions(k) + 0.07;
    textposx = ah_vec(k) - 0.075;
%     if (model == 3) && (k == 6)
%         textposx = p(k) - 0.05;
%     end
    text(textposx,textheight, num2str(round(sscounts(k))), ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'white', ...
        'EdgeColor', 'black');
end
hold off;


yyaxis right
plot(ah_vec, ssonsets, 'r--*');
axis([min(ah_vec)-0.25, max(ah_vec)+0.25, 0, 250]);
ylabel('Average time of steady state onset (h)','FontSize',15);
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/AH_SteadyStates', 11, 7/5, 10);


figure;
plot(ah_vec, shapetotal,'k--*')
title('Slope (total cells)');
ylabel('Slope');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/AH_Slope_total', 11, 7/5, 10);

figure;
plot(ah_vec, shapeprolif,'b--*')
title('Slope (CM cells)');
ylabel('Slope');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/AH_Slope_prolif', 11, 7/5, 10);

figure;
plot(ah_vec, capheights,'r--*')
title('Cap height');
ylabel('Height');
xlabel('$$h_a$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/AH_Cap_height', 11, 7/5, 10);

end


