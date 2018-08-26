function paper_adhesion_plots

addpath(genpath('PlotData/functions'));
close all;

%% Onsets
clear all;
load('PlotData/MAT/Adhesion_SteadyOnsets_paper.mat')

bar3plot(ap_vec,dp_vec,ssonsets,0)
title('Onsets');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Onsets', 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,sscounts,0)
title('Counts');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Counts', 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,proportions,-2)
title('Proportions');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Proportions', 14, 7/5, 18);

%% Shapes
clear all;
load('PlotData/MAT/Adhesion_SteadyShapes_paper.mat')

bar3plot(ap_vec,dp_vec,shapetotal,-4)
title('Slope (total cells)');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Slope_total', 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,shapeprolif,-4)
title('Slope (CM cells)');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Slope_prolif', 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,capheights,-1)
title('Cap Height');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1,'Figures/Paper/adhesion/surf_Capheight', 14, 7/5, 17);


disp('Done!')

end


