function AttRep_Plots

close all;
addpath('PlotData')
addpath(genpath('PlotData/functions'));

%% Onsets
clear all;
load('PlotData/MAT/AttRep_SteadyOnsets.mat')

bar3plot(fa_vec,fr_vec,ssonsets,1)
title('Onsets');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_Onsets', 14, 7/5, 16);

bar3plot(fa_vec,fr_vec,sscounts,1)
title('Counts');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_Counts',14, 7/5, 16);

bar3plot(fa_vec,fr_vec,proportions,-1)
title('Proportions');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_Proportions', 14, 7/5, 16);

%% Shapes
clear all;
load('PlotData/MAT/AttRep_SteadyShapes.mat')

bar3plot(fa_vec,fr_vec,shapetotal,-4)
title('Slope (total cells)');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_Slope_total',14, 7/5, 16);


bar3plot(fa_vec,fr_vec,shapeprolif,-4)
title('Slope (CM cells)');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_Slope_prolif',14, 7/5, 16);


bar3plot(fa_vec,fr_vec,capheights,0)
title('Cap Height');
ylabel('$$F_a$$', 'Interpreter', 'latex'); xlabel('$$F_r$$', 'Interpreter', 'latex');
pbaspect([5 7 1]);
SaveAsPngEpsAndFig(-1,'Figures/AttRep_Plots/surf_AttRep_CapHeight', 14, 7/5, 16);

%%
disp('Done!');

end


