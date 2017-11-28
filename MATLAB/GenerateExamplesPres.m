function GenerateExamples

addpath(genpath('PlotData/functions'));

% data_path = get_data_path(3, 0.6);
% UT_PopulationVsTime(data_path, 1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/01', 6, 7/5, 14);
% 
% data_path = get_data_path(4, 0.2);
% UT_PopulationVsTime(data_path,1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/02', 6, 7/5, 14);
% 
% data_path = get_data_path(2, 1);
% UT_PopulationVsTime(data_path,1)
% clearplotlabels
% SaveAsPngEpsAndFig(-1,'Figures/Examples/03', 6, 7/5, 14);

%---

data_path = get_data_path(4, 0.15);
steadystateshape_simple(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/04a', 6, 7/5, 14);

data_path = get_data_path(2, 0.7);
steadystateshape_simple(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/05a', 6, 7/5, 14);


data_path = get_data_path(2, 0.9);
steadystateshape_simple(data_path,0,1)
clearplotlabels
SaveAsPngEpsAndFig(-1,'Figures/Examples/06a', 6, 7/5, 14);


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

function slope = steadystateshape_simple(data_path, prolif, plot_flag)

if nargin < 3
    plot_flag = 0;
    if nargin < 2
        prolif = 0;
    end
end

D = dir([data_path '*']);
TotalJobs = length(D(:));

histogram_data = cell(TotalJobs,1);
for i = 1:TotalJobs
    histogram_data{i} = zeros(21, 20);
end

for k = 1:TotalJobs
    
    loaddata = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
    
    for i = 1:length(loaddata) % over each sample step
        x = loaddata{i}(3:4:end-2);
        if prolif == 1
            state = loaddata{i}(5:4:end);
            tmp = (state ~= 0) .* x;
            x = x(tmp>0);
        end
        histogram_data{k}(i,:) = histcounts(x,0:1:20, 'Normalization', 'probability');
    end
    
    if k == 1
        bincounts=mean(histogram_data{k});
    else
        temp = mean(histogram_data{k});
        bincounts = ((k-1)*bincounts + temp)/k;
    end
end

n = bincounts;
m = 0.5:1:19.5;

n_trunc = n(2:end-2);
m_trunc = m(2:end-2);

M_trunc = [ones(length(m_trunc),1), m_trunc'];
b = M_trunc\n_trunc';
ncalc = M_trunc * b;
slope = b(2);

if plot_flag == 1
    close;
    fig = figure;
    fig.Units = 'centimeters';
    fig.Position = [10 10 20 15];
    b=bar(m,n);
    b.FaceColor = (1/255)*[0 191 255];
    if prolif == 1
        b.FaceColor = (1/255)*[0 204 0];
    end
    hold on;
    plot(m_trunc', ncalc, 'r--');
    hold off;
    title(['Horizontal position of cells']);
    if prolif == 1
        title(['Horizontal position of proliferative cells']);
    end
    xlabel('$$x$$', 'Interpreter', 'latex');
    ylabel('Probability');
end

end








