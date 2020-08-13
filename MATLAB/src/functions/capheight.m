function avg = capheight(data_path, prolif, sampleindexmax)

if nargin < 3
    sampleindexmax = 0;
if nargin < 2
    prolif = 0;
end
end

D = dir([data_path '*']);
TotalJobs = length(D(:));

height_data = cell(TotalJobs,1);
for i = 1:TotalJobs
    height_data{i} = zeros(20, 1);
end

for k = 1:TotalJobs
    
    loaddata = LoadNonConstantLengthData([data_path 'sim_' num2str(k-1) '/results_from_time_0/cellstate.dat']);
    
    if (k == 1) && (sampleindexmax == 0)
        sampleindexmax = length(loaddata);        
    end
    
    for i = 1:sampleindexmax %over each sample step
        y = loaddata{i}(4:4:end-1);
        if prolif == 1
            state = loaddata{i}(5:4:end);
            tmp = (state ~= 0) .* y;
            y = y(tmp>0);
        end
        tmp = sort(y,'descend');
        if length(tmp) < 10
            height_data{k}(i,1) = tmp(1);
        else
            height_data{k}(i,1) = tmp(10);
        end
    end
    
    if k == 1
        avg=mean(height_data{k});
    elseif k > 1
        temp = mean(height_data{k});
        avg = ((k-1)*avg + temp)/k;
    end
end

end


