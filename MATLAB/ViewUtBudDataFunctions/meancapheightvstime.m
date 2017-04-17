function meancapheightvstime(VelocitiesDataSet)

fontopt = {'FontSize',50,'FontWeight','bold'};

VelocitiesData = VelocitiesDataSet{1};
[~, TotalJobs] = size(VelocitiesDataSet);

CapHeightData = zeros(TotalJobs, length(VelocitiesData));

x = VelocitiesData{1}(3:5:end-3);
y = VelocitiesData{1}(4:5:end-2);
cap_height_tmp = zeros(1,20);
for j = 1:20
    x_tmp = x .* (x >=  j-1) .* (x < j);
    y_tmp = y .* (x_tmp > 0);
    if sum(y_tmp) == 0
        y_tmp = 0;
    else
        y_tmp = y_tmp(y_tmp~=0);
    end
    cap_height_tmp(j) = max(y_tmp);
end
CapHeightData(1,1) = mean(cap_height_tmp);

for k = 1:length(VelocitiesData)
    x = VelocitiesData{k}(3:5:end-3);
    y = VelocitiesData{k}(4:5:end-2);
    cap_height_tmp = zeros(1,20);
    for j = 1:20
        x_tmp = x .* (x >=  j-1) .* (x < j);
        y_tmp = y .* (x_tmp > 0);
        if sum(y_tmp) == 0
            y_tmp = 0;
        else
            y_tmp = y_tmp(y_tmp~=0);
        end
        cap_height_tmp(j) = max(y_tmp);
    end
    CapHeightData(1,k) = mean(cap_height_tmp);
end

CapHeight_Sum1 = CapHeightData(1,:);
CapHeight_Sum2 = (CapHeightData(1,:)).^2;


for kk = 2:TotalJobs
    VelocitiesData = VelocitiesDataSet{kk};
    
    x = VelocitiesData{1}(3:5:end-3);
    y = VelocitiesData{1}(4:5:end-2);
    cap_height_tmp = zeros(1,20);
    for j = 1:20
        x_tmp = x .* (x >=  j-1) .* (x < j);
        y_tmp = y .* (x_tmp > 0);
        if sum(y_tmp) == 0
            y_tmp = 0;
        else
            y_tmp = y_tmp(y_tmp~=0);
        end
        cap_height_tmp(j) = max(y_tmp);
    end
    CapHeightData(kk,1) = mean(cap_height_tmp);
    
    
    for k = 1:length(VelocitiesData)
        x = VelocitiesData{k}(3:5:end-3);
        y = VelocitiesData{k}(4:5:end-2);
        cap_height_tmp = zeros(1,20);
        for j = 1:20
            x_tmp = x .* (x >=  j-1) .* (x < j);
            y_tmp = y .* (x_tmp > 0);
            if sum(y_tmp) == 0
                y_tmp = 0;
            else
                y_tmp = y_tmp(y_tmp~=0);
            end
            cap_height_tmp(j) = max(y_tmp);
        end
        CapHeightData(kk,k) = mean(cap_height_tmp);
        
    end
    
    CapHeight_Sum1 = CapHeight_Sum1 + CapHeightData(kk,:);
    CapHeight_Sum2 = CapHeight_Sum2 + (CapHeightData(kk,:)).^2;
    
end

CapHeightAvg = sum(CapHeightData)/TotalJobs;

CapHeightStd = sqrt((TotalJobs*CapHeight_Sum2 - CapHeight_Sum1.^2)/(TotalJobs*(TotalJobs-1)));

SimTime = linspace(0,VelocitiesData{end}(1,1), length(CapHeightAvg));

figure;
plot(SimTime, CapHeightAvg, 'k', ...
     SimTime, CapHeightAvg + CapHeightStd, 'k:', ...
     SimTime, CapHeightAvg - CapHeightStd, 'k:');

title(['Average cap height over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('t'); ylabel('y');

set(gcf,'PaperPositionMode','auto'); print('Fig02', '-dpng', '-r0');

end
