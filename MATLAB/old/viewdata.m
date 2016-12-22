function viewdata

addpath(genpath('/home/blake/Workspace/Chaste/anim/'))
data = LoadNonConstantLengthData('nodevelocities.dat');

for k = 1:100
    cell_id = data{k}(2:5:end-4);
    x = data{k}(3:5:end-3);
    y = data{k}(4:5:end-2);
    u = data{k}(5:5:end-1);
    v = data{k}(6:5:end);
   
    plot(x,y,'ro');
    hold on;
    quiver(x,y,u,v);
    axis([0,16,0,12]);
    hold off;
    pause(0.1);
end

end