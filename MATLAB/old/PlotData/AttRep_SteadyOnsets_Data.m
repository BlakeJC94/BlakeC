function AttRep_SteadyOnsets_Data
% NEEDS TO BE RETESTED

close all;

addpath(genpath('functions/'));

fa_vec = round(linspace(0.5,2,10),2);
fr_vec = round(linspace(1.25,5,10),2);

DataDims = [length(fa_vec), length(fr_vec)];

ssonsets = zeros(DataDims);
sscounts = zeros(DataDims);
proportions = zeros(DataDims);


for fa_index = 1:length(fa_vec)
    fa = fa_vec(fa_index);
    disp(['fa = ' num2str(fa)])
    testoutput_path = ['data/AttRep/FA_' num2str(fa) '_testoutput_dats'];
    
    for fr_index = 1:length(fr_vec)
        fr = fr_vec(fr_index);
        disp(['    fr = ' num2str(fr)])

        data_path = [testoutput_path '/UtericBudSimulation_fa_' num2str(fa) '_fr_' num2str(fr) '_hr_1.5_'];
        
        
        ssonsets(fa_index, fr_index) = totalcellsteadystate(data_path);
        [sscounts(fa_index, fr_index), proportions(fa_index, fr_index)] = totalcellsteadystatecount(data_path);        

    end
end

save('MAT/AttRep_SteadyOnsets.mat')

disp('Done!');

end

