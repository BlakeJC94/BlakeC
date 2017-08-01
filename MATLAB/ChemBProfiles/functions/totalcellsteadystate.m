function out = totalcellsteadystate(PopulationDataSet)

[MeanPopulationData, TotalCellsStd] = meanscellsvstime(PopulationDataSet);
TotalCells = MeanPopulationData(:,3) + MeanPopulationData(:,2);
End_Time = MeanPopulationData(end,1);

t = 75; % number of data points in each window
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


disp(['(QD) Total cells in Equilibrium from approx t = '...
    num2str(out)]);

end



function out = samplestats(A)
out = [mean(A), min(A), max(A)];

end

