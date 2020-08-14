function test_barplotveclocity

addpath(genpath('/functions'));

%testing on cellvelocities.dat
% data = LoadNonConstantLengthData('test_cellvelocities.dat');

bin_size = 1;
max = 20;

testoutput_path = ['data/Adhesion/AP_0_testoutput_dats'];
data_path = [testoutput_path '/UtericBudSimulation_ap_0_dp_0_'];
D = dir([data_path '*']);
TotalJobs = length(D(:));

for j = 1:TotalJobs
    
    data = LoadNonConstantLengthData([data_path 'sim_' num2str(j-1) '/results_from_time_0/cellvelocities.dat']);
    
    
    for i = 1:length(data)
        x = data{i}(3:5:end-3);
        u = data{i}(5:5:end-1);
        tmp = barplotveclocity(x, u, bin_size, max);
        
        if i == 1
            avg = tmp;
        else
            avg = ((i-1)*avg + tmp)/i;
        end
        
    end
    
    if j == 1
        avg2 = avg;
    else
        avg2 = ((i-1)*avg2 + avg)/i;
    end
    
end



partitions_total = ceil(max/bin_size);
bar(bin_size*(1:partitions_total), avg)
bar(bin_size*(1:partitions_total), avg2)

disp('Passed!');

end



function av_data = barplotveclocity(x, u, bin_size, max)
% Partitions x into elements [0, bin_size), [bin_size, 2*bin_size), ...
% until after k*bin_size > max. Then isolate values of u that correspond to
% each partition element and average over each of them. Return average u
% value over each partition element as a vector.

partitions_total = ceil(max/bin_size);
av_data = zeros(1, partitions_total);

for k=1:partitions_total
    
    indices = find( (x>=(k-1)*bin_size).*(x<k*bin_size) ~= 0 );
    
    if numel(indices) == 0
        av_data(k) = 0;
    else
        av_data(k) = sum(u(indices))/length(u(indices));
    end
end


end