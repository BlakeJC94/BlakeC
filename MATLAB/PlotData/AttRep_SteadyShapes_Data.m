function AttRep_SteadyShapes_Data

addpath(genpath('functions/'));

fa_vec = round(linspace(0.5,2,10),2);
fr_vec = round(linspace(1.25,5,10),2);

DataDims = [length(fa_vec), length(fr_vec)];

shapetotal = zeros(DataDims);
shapeprolif = zeros(DataDims);
capheights = zeros(DataDims);

for fa_index = 1:length(fa_vec)
    fa = fa_vec(fa_index);
    disp(['fa = ' num2str(fa)])
    
    testoutput_path = ['data/AttRep/FA_' num2str(fa) '_testoutput_dats'];
    
    for fr_index = 1:length(fr_vec)
        fr = fr_vec(fr_index);
        disp(['    fr = ' num2str(fr)])
        
        data_path = [testoutput_path '/UtericBudSimulation_fa_' num2str(fa) '_fr_' num2str(fr) '_hr_1.5_'];
        
        shapetotal(fa_index, fr_index) = steadystateshape(data_path, 0);
        shapeprolif(fa_index, fr_index) = steadystateshape(data_path, 1);
        capheights(fa_index, fr_index) = capheight(data_path);
        
    end
end

save('MAT/AttRep_SteadyShapes.mat');

disp('Done');

end

