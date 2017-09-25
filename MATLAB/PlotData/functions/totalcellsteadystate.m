function out = totalcellsteadystate(data_path)

D = dir([data_path '*']);
TotalJobs = length(D(:));

% PopulationDataSet = cell(1,TotalJobs);
% for k = 1:TotalJobs
%     loaddata = importdata([data_path 'sim_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
%     PopulationDataSet{k} = loaddata.data;
% end

out = QD2(data_path);

end

function out = QD1(PopulationDataSet)

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(PopulationDataSet);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
End_Time = MeanPopulationData(end,1);

t = 50; % number of data points in each window
eps_av = 0.025; % confidence interval
eps_sd = 0.25;

Sample1av = TotalCells(end-t+1:end, :);
Sample2av = TotalCells(end-2*t+1:end-t, :);

Stats1av = samplestats(Sample1av);
Stats2av = samplestats(Sample2av);

flag = 0;
j = 1;
if sum(abs(Stats1av - Stats2av) < eps_av*(Stats2av + Stats1av)/2) == 3
    Sample1sd = TotalCellsStd(end-t+1:end, :);
    Sample2sd = TotalCellsStd(end-2*t+1:end-t, :);
    
    Stats1sd = samplestats(Sample1sd);
    Stats2sd = samplestats(Sample2sd);
    
    if sum(abs(Stats1sd - Stats2sd) < eps_sd*(Stats2sd + Stats1sd)/2) == 3
        flag = 1;
        j = j+1;
    end
end


while flag == 1
    flag = 0;
    
    Sample1av = [Sample1av; Sample2av];
    Sample2av = TotalCells(end-(j+1)*t+1:end-j*t, :);
    
    Stats1av = samplestats(Sample1av);
    Stats2av = samplestats(Sample2av);
    
    if sum(abs(Stats1av - Stats2av) < eps_av*Stats1av) == 3
        Sample1sd = [Sample1sd; Sample2sd];
        Sample2sd = TotalCellsStd(end-(j+1)*t+1:end-j*t, :);
        
        Stats1sd = samplestats(Sample1sd);
        Stats2sd = samplestats(Sample2sd);
        
        if sum(abs(Stats1sd - Stats2sd) < eps_sd*(Stats2sd + Stats1sd)/2) == 3
            flag = 1;
            j=j+1;
        end
    end
    %     disp(j);
    
end


if j*0.6*t >= 50
    out = End_Time - j*0.6*t;
else
    disp('Not steady!');
    out = 0;
end

end

function out = QD2(data_path)

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(data_path);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
End_Time = MeanPopulationData(end,1);

eps = 0.10;

FinalCellCount = TotalCells(end);

EndOfSS = find(abs(TotalCells - FinalCellCount) > eps*FinalCellCount, 1, 'last');
out = EndOfSS*0.6;

% y = TotalCells(EndOfSS:end);
% x = MeanPopulationData(EndOfSS:end,1);
% X = [ones(length(x),1), x];
%
% b = X\y;
% ycalc = X * b;
%
% disp(b(2));
% figure
% plot(x,y, 'b', x, ycalc, 'r')


end


function out = QD3(PopulationDataSet)

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(PopulationDataSet);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
End_Time = MeanPopulationData(end,1);

t = 30; % number of data points in each window
eps_av = 0.025; % confidence interval
eps_sd = 0.25;

Sample1av = TotalCells(end-t+1:end, :);
%Sample2av = TotalCells(end-2*t+1:end-t, :);

% Stats1av = samplestats(Sample1av);
% Stats2av = samplestats(Sample2av);

y = (Sample1av - mean(Sample1av))/std(Sample1av);
scatter(1:length(y), y)

X = [ones(length(y),1), (1:length(y))'];
b = X\y;
disp(b(2))
ycalc = X * b;
hold on;
plot(ycalc);
hold off;

pause

flag = 0;
if abs(b(2)) < 0.05
    flag = 1;
    disp('accept')
end

j = 1;
while flag == 1
    disp(j)
    flag = 0;
    
    Sample1av = TotalCells(end-(j+1)*t+1:end, :);
    
    y = (Sample1av - mean(Sample1av))/std(Sample1av);
    scatter(1:length(y),y)
    X = [ones(length(y),1), (1:length(y))'];
    b = X\y;
    disp(b(2))
    ycalc = X * b;
    hold on;
    plot(ycalc);
    hold off;
    
    pause
    
    if abs(b(2)) < 0.05
        flag = 1;
        j = j+1;
        disp('accept')
    end
    
end

disp('rejected')

if j*0.6*t >= 50
    out = End_Time - j*0.6*t;
else
    disp('Not steady!');
    out = 0;
end

end



function out = samplestats(A)
out = [mean(A), min(A), max(A)];

end

