function out = totalcellsteadystate(PopulationDataSet, TotalJobs)
t = 40; % number of data points in each window
eps = 0.075; % confidence interval

PopulationData = PopulationDataSet{1};
Sample1 = PopulationData(end-t+1:end, :);
Sample2 = PopulationData(end-2*t+1:end-t, :);

for k = 2:TotalJobs
    PopulationData = PopulationDataSet{k};
    Sample1 = [Sample1; PopulationData(end-t+1:end, :)];
    Sample2 = [Sample2; PopulationData(end-2*t+1:end-t, :)];
    
end

Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));

flag = 0;
if sum(abs(Stats1 - Stats2) < eps*(Stats2 + Stats1)/2) == 2
    flag = 1;
end


j = 2;
while flag == 1
    flag = 0;
    
%     Sample1 = Sample2;
%     Stats1 = Stats2;
    
%     Sample1 = PopulationData(end-j*t+1:end, :);
    Sample1 = [Sample1; Sample2];
    Stats1 = samplestats(Sample1(:,3) + Sample1(:,2))
    
    Sample2 = PopulationData(end-(j+1)*t+1:end-j*t, :);
    for k = 2:TotalJobs
        PopulationData = PopulationDataSet{k};
        Sample2 = [Sample2; PopulationData(end-3*t+1:end-2*t, :)];
    end
    Stats2 = samplestats(Sample2(:,3) + Sample2(:,2))
    
    if sum(abs(Stats1 - Stats2) < eps*Stats1) == 2
        flag = 1;
        j = j+1;
    end
    disp(j);
    
end


out = PopulationData(end,1) - j*0.6*t;
display(j);
disp(['(QD) Total cells in Equilibrium from approx t = '...
    num2str(out)]);

end


function out = samplestats(A)
out = [mean(A), std(A)];

end




% t = 40; % number of data points in each window
% eps = 0.4; % confidence interval
% 
% PopulationData = PopulationDataSet{1};
% Sample1 = PopulationData(end-t+1:end, :);
% Sample2 = PopulationData(end-2*t+1:end-t, :);
% 
% for k = 2:TotalJobs
%     PopulationData = PopulationDataSet{k};
%     Sample1 = [Sample1; PopulationData(end-t+1:end, :)];
%     Sample2 = [Sample2; PopulationData(end-2*t+1:end-t, :)];
%     
% end
% 
% Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
% Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
% 
% flag = 0;
% if sum(abs(Stats1 - Stats2) < eps*(Stats1)) == 2
%     flag = 1;
% else 
%     error('failed steady test');
% end
% 
% 
% 
% j = 2;
% while flag == 1
%     flag = 0;
%     
%     Sample1 = Sample2;
%     Stats1 = Stats2;
%     
%     Sample1 = PopulationData(end-j*t+1:end, :);
%     Stats1 = samplestats(Sample1(:,3) + Sample1(:,2));
% 
%     
%     Sample2 = PopulationData(end-(j+1)*t+1:end-j*t, :);
%     for k = 2:TotalJobs
%         PopulationData = PopulationDataSet{k};
%         Sample2 = [Sample2; PopulationData(end-3*t+1:end-2*t, :)];
%     end
%     Stats2 = samplestats(Sample2(:,3) + Sample2(:,2));
%     
%     
%     if sum(abs(Stats1 - Stats2) < eps*(Stats1)) == 2
%         flag = 1;
%         j = j+1;
%     end
%     
% end
% 
% 
% out = PopulationData(end,1) - j*0.6*t;
% 
% disp(['(QD) Total cells in Equilibrium from approx t = '...
%     num2str(out)]);
