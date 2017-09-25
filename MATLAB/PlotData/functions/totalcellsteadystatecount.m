function [out1, out2] = totalcellsteadystatecount(data_path,sampleindexmax)
% sample from 'sampleindexmax' points spaced 12 hours apart from sim end


if nargin < 2
    sampleindexmax = 0;
end

D = dir([data_path '*']);
TotalJobs = length(D(:));

PopulationDataSet = cell(1,TotalJobs);
count_data = zeros(1,TotalJobs);
proportion_data = zeros(1,TotalJobs);
for k = 1:TotalJobs
    loaddata = importdata([data_path 'sim_' num2str(k-1) '/results_from_time_0/celltypescount.dat']);
    PopulationDataSet{k} = loaddata.data;
    EndTime = ceil(PopulationDataSet{k}(end,1));
    
    if (k == 1) && (sampleindexmax == 0)
        tmp = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
        sampleindexmax = size(tmp,2);        
    end
    
    count_data_raw = cell(1,sampleindexmax);
    proportion_data_raw = cell(1,sampleindexmax);
    for i = 1:sampleindexmax % over each sample step
        
        % Find which row of data to sample from
        sample = find(loaddata.data(:,1)  <= EndTime*(1 - (12/EndTime)*(i-1)), 1, 'last');
        
        % Pull total cell count at this step
        count_data_raw{k}(1,i) = loaddata.data(sample,3) + loaddata.data(sample,2);
        proportion_data_raw{k}(1,i) = loaddata.data(sample,2)/count_data_raw{k}(1,i);
    end
    
    count_data(k) = mean(count_data_raw{k});
    proportion_data(k) = mean(proportion_data_raw{k});
end

out1 = mean(count_data);
out2 = mean(proportion_data);

end