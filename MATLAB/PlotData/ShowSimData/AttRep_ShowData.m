function AttRep_ShowData(fa, fr, rf)
% fa : 0.5 0.67 0.83 1 1.17 1.33 1.5 1.67 1.83 2
% fr : 1.25 1.67 2.08 2.5 2.92 3.33 3.75 4.17 4.58 5
% rf : 0 1 2

if nargin < 3
    rf = 0;
end

close all;

if rf == 0
    testoutput_path = ['data/AttRep/FA_' num2str(fa) '_testoutput_dats'];
    data_path = [testoutput_path '/UtericBudSimulation_fa_' num2str(fa) '_fr_' num2str(fr) '_hr_1.5_'];
    disp(['Stats for (fa, fr) : (' num2str(fa) ', ' num2str(fr) ')']);
else
    testoutput_path = ['data/AttRep/RadForce' num2str(rf) '/RF' num2str(rf) '_testoutput_dats'];
    data_path = [testoutput_path '/UtericBudSimulation_RadForce' num2str(rf) '_'];
    disp(['Stats for rf : ' num2str(rf)]);
end

ShowData(data_path)

end


