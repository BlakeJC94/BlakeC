function paper_adhesion_plots


% load dependencies
addpath(genpath('src/common/'));
addpath(genpath('src/adhesion/'));

% declare variables
figureDir = 'output/adhesion/';
dataDir = 'data/adhesion/';

% Check output directory existence
if ~exist(figureDir, 'dir')
   mkdir(figureDir)
end

%% Onsets
load('data/adhesion/Adhesion_SteadyOnsets_paper.mat', 'ap_vec', 'dp_vec', 'ssonsets','sscounts','proportions');

% bar3plot(ap_vec,dp_vec,ssonsets,0)
% title('Onsets','Interpreter', 'latex');
% ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
% SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Onsets'), 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,sscounts,0)
title('Counts','Interpreter', 'latex');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Counts'), 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,proportions,-2)
title('Proportions','Interpreter', 'latex');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Proportions'), 14, 7/5, 18);

%% Shapes
load('data/adhesion/Adhesion_SteadyShapes_paper.mat', 'ap_vec', 'dp_vec', 'shapetotal','shapeprolif','capheights');

% bar3plot(ap_vec,dp_vec,shapetotal,-4)
% title('Slope (total cells)','Interpreter', 'latex');
% ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
% SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Slope_total'), 14, 7/5, 18);
% 
% bar3plot(ap_vec,dp_vec,shapeprolif,-4)
% title('Slope (CM cells)','Interpreter', 'latex');
% ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
% SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Slope_prolif'), 14, 7/5, 18);

bar3plot(ap_vec,dp_vec,capheights,-1)
title('Cap Height','Interpreter', 'latex');
ylabel('$$p_a$$', 'Interpreter', 'latex'); xlabel('$$p_d$$', 'Interpreter', 'latex');
SaveAsPngEpsAndFig(-1, strcat(figureDir, 'surf_Capheight'), 14, 7/5, 17);


disp('Done!')

end


