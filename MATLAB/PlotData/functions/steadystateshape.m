function slope = steadystateshape(data_path, prolif, plot_flag)

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

M = [ones(length(m),1), m'];
b = M\n';
ncalc = M * b;
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
    plot(m', ncalc, 'k--');
    hold off;
    title(['Horizontal position of cells']);
    if prolif == 1
        title(['Horizontal position of proliferative cells']);
    end
    xlabel('$$x$$', 'Interpreter', 'latex');
    ylabel('Probability');
end

end


