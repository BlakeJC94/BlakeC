function meanagevsxy(AgesDataSet, BinSize_agex, BinSize_agey, max_x, max_y)

fontopt = {'FontSize',50,'FontWeight','bold'};

AgesData = AgesDataSet{1};
[~, TotalJobs] = size(AgesDataSet);

x = AgesData{end}(3:4:end-3);
y = AgesData{end}(4:4:end-2);
age = AgesData{end}(5:4:end-1);
MeanAgeXData = barplotdatagen(x, age, BinSize_agex, max_x);
MeanAgeYData = barplotdatagen(y, age, BinSize_agey, max_y);

for k = 2:TotalJobs
    AgesData = AgesDataSet{k};
    x = AgesData{end}(3:4:end-3);
    y = AgesData{end}(4:4:end-2);
    age = AgesData{end}(5:4:end-1);
    av_agedata_x = barplotdatagen(x, age, BinSize_agex, max_x);
    av_agedata_y = barplotdatagen(y, age, BinSize_agey, max_y);
    
    MeanAgeXData = ((k-1)*MeanAgeXData + av_agedata_x)./k;
    MeanAgeYData = ((k-1)*MeanAgeYData + av_agedata_y)./k;
end

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
figure;
bar(BinSize_agex*(1:numel(MeanAgeXData)) - (BinSize_agex/2), MeanAgeXData);
title(['Cell age vs. horzontal position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig05', '-dpng', '-r0');

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
figure;
bar(BinSize_agey*(1:numel(MeanAgeYData)) - (BinSize_agey/2), MeanAgeYData);
title(['Cell age vs. vertical position at end of ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('y'); ylabel('age');
set(gcf,'PaperPositionMode','auto'); print('Fig06', '-dpng', '-r0');


end