function meanvelocityvsx(VelocitiesDataSet, BinSize_ux, BinSize_vx, max_x, max_y)

fontopt = {'FontSize',50,'FontWeight','bold'};

VelocitiesData = VelocitiesDataSet{1};
[~, TotalJobs] = size(VelocitiesDataSet);


x = VelocitiesData{1}(3:5:end-3);
u = VelocitiesData{1}(5:5:end-1);
av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
v = VelocitiesData{1}(6:5:end);
av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
for j = 2:length(VelocitiesData)
    x = VelocitiesData{j}(3:5:end-3);
    u = VelocitiesData{j}(5:5:end-1);
    av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
    v = VelocitiesData{j}(6:5:end);
    av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
end
MeanHVelocitiesData = av_udata;
MeanVVelocitiesData = av_vdata;

for k = 2:TotalJobs
    VelocitiesData = LoadNonConstantLengthData(['testoutput/UtericBudSimulation_', num2str(k-1) '/results_from_time_0/cellvelocities.dat']);
    x = VelocitiesData{1}(3:5:end-3);
    u = VelocitiesData{1}(5:5:end-1);
    av_udata = barplotdatagen(x, u, BinSize_ux, max_x);
    v = VelocitiesData{1}(6:5:end);
    av_vdata = barplotdatagen(x, v, BinSize_vx, max_x);
    for j = 2:length(VelocitiesData)
        x = VelocitiesData{j}(3:5:end-3);
        u = VelocitiesData{j}(5:5:end-1);
        av_udata = ((j-1)*av_udata + barplotdatagen(x, u, BinSize_ux, max_x))./j;
        v = VelocitiesData{j}(6:5:end);
        av_vdata = ((j-1)*av_vdata + barplotdatagen(x, v, BinSize_vx, max_x))./j;
    end
    
    MeanHVelocitiesData = ((k-1)*MeanHVelocitiesData + av_udata)./k;
    MeanVVelocitiesData = ((k-1)*MeanVVelocitiesData + av_vdata)./k;
end

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
figure;
bar(BinSize_ux*(1:numel(MeanHVelocitiesData)) - (BinSize_ux/2), MeanHVelocitiesData);
title(['Average horizontal velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('u');
set(gcf,'PaperPositionMode','auto'); print('Fig03', '-dpng', '-r0');

% figure('units', 'normalized', 'position', [.3 .3 0.12 0.4]);
figure;
bar(BinSize_vx*(1:numel(MeanVVelocitiesData)) - (BinSize_vx/2), MeanVVelocitiesData);
title(['Average vertical velocity vs. horizontal position over ', num2str(TotalJobs), ' simulations'], fontopt{:});
xlabel('x'); ylabel('v');
set(gcf,'PaperPositionMode','auto'); print('Fig04', '-dpng', '-r0');



end