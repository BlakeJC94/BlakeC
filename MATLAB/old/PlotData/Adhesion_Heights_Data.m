function Adhesion_Heights_Data

close all;

addpath(genpath('functions/'));

ah_vec = [1:0.25:3];

DataDims = [1, length(ah_vec)];

ssonsets = zeros(DataDims);
sscounts = zeros(DataDims);
proportions = zeros(DataDims);
shapetotal = zeros(DataDims);
shapeprolif = zeros(DataDims);
capheights = zeros(DataDims);

for ah_index = 1:length(ah_vec)
    ah = ah_vec(ah_index);
    disp(['ah = ' num2str(ah)])

    testoutput_path = ['data/Adhesion/AdhesionHeight/AH_' num2str(ah) '_testoutput_dats'];
    
    data_path = [testoutput_path '/UtericBudSimulation_ap_0.5_dp_0.5_ah_' num2str(ah) '_'];
    
    ssonsets(1, ah_index) = totalcellsteadystate(data_path);
    [sscounts(1, ah_index), proportions(1, ah_index)] = totalcellsteadystatecount(data_path);
    
    shapetotal(1, ah_index) = steadystateshape(data_path, 0);
    shapeprolif(1, ah_index) = steadystateshape(data_path, 1);
    capheights(1, ah_index) = capheight(data_path);
end

save('MAT/Adhesion_Heights.mat');
disp('Done!');



end

function surfaceplot(X,Y,A)

figure;
surf(X', Y', A);
xlabel('$$p_a$$', 'Interpreter', 'latex'); ylabel('$$p_d$$', 'Interpreter', 'latex');
colormap(jet)
colorbar;
view(0,90);

end


