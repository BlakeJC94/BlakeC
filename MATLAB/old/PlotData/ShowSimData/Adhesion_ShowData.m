function Adhesion_ShowData(ap, dp, ah)

if nargin < 3
    ah = 0;
end

close all;

if ah == 0
    testoutput_path = ['data/Adhesion/AP_' num2str(ap) '_testoutput_dats'];
    data_path = [testoutput_path '/UtericBudSimulation_ap_' num2str(ap) '_dp_' num2str(dp) '_'];
    disp(['Stats for (ap, dp) : (' num2str(ap) ', ' num2str(dp) ')']);
else
    testoutput_path = ['data/Adhesion/AdhesionHeight/AH_' num2str(ah) '_testoutput_dats'];
    data_path = [testoutput_path '/UtericBudSimulation_ap_' num2str(ap) '_dp_' num2str(dp) '_ah_' num2str(ah) '_'];
    disp(['Stats for (ap, dp, ah) : (' num2str(ap) ', ' num2str(dp) ', ' num2str(ah) ')']);
end

ShowData(data_path)

end

