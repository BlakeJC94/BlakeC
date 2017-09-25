function av_data = barplotdatagen(x, u, bin_size, max)
% Partitions x into elements [0, bin_size), [bin_size, 2*bin_size), ...
% until after k*bin_size > max. Then isolate values of u that correspond to
% each partition element and average over each of them. Return average u
% value over each partition element as a vector.

partitions_total = ceil(max/bin_size);
av_data = zeros(1, partitions_total);
for k=1:partitions_total
    indicies = (bin_size*(k-1) <= x) .* (x < bin_size*k);
    tmpdata = u .* indicies;
    av_data(k) = sum(tmpdata)/sum(indicies);
    
    %     Removing this check makes the data inflated, since this stops the
    %     addition of NaNs?
    if sum(indicies) == 0
        av_data(k) = 0;
    end
end

end