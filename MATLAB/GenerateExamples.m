function GenerateExamples


data_path = get_data_path(3, 0.6);
UT_PopulationVsTime(data_path, 1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/01', 6, 7/5, 9);

data_path = get_data_path(4, 0.2);
UT_PopulationVsTime(data_path,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/02', 6, 7/5, 9);

data_path = get_data_path(2, 1);
UT_PopulationVsTime(data_path,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/03', 6, 7/5, 9);

%---

data_path = get_data_path(4, 0.15);
steadystateshape(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/04', 6, 7/5, 9);
steadystateshape(data_path,1,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/07', 6, 7/5, 9);

data_path = get_data_path(2, 0.7);
steadystateshape(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/05', 6, 7/5, 9);
steadystateshape(data_path,1,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/08', 6, 7/5, 9);

data_path = get_data_path(2, 0.9);
steadystateshape(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/06', 6, 7/5, 9);
steadystateshape(data_path,1,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/09', 6, 7/5, 9);

%----

% steadystateshape(3,0.7,0)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/04', 6, 7/5, 9);
% 
% steadystateshape(4, 0.15,0)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/05', 6, 7/5, 9);
% 
% steadystateshape(2, 0.7,0)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/06', 6, 7/5, 9);
% 
% 
% steadystateshape(3,0.7,1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/07', 6, 7/5, 9);
% 
% steadystateshape(4, 0.15,1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/08', 6, 7/5, 9);
% 
% steadystateshape(2, 0.7,1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/09', 6, 7/5, 9);

end

function data_path = get_data_path(model, parameter)

testoutput_path = ['PlotData/data/AffinityB/MODEL_' num2str(model) '_testoutput_dats'];
data_path = [testoutput_path '/UtericBudSimulation_concbmodel_' num2str(model) '_parameter_' num2str(parameter) '_' ];

end

function clearplotlabels
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
title([])
end









