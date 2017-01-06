clear all;
close all;

addpath(genpath('/home/blake/Workspace/Chaste/anim/'));

RawData = LoadNonConstantLengthData('cellattachment.dat');

maxlength = length(RawData{1});
for i = 1:length(RawData)
    if maxlength < length(RawData{i})
        maxlength = length(RawData{i});
    end
end

maxlength = (maxlength + 3)/4;

A = zeros(length(RawData), maxlength);
for i = 1:length(RawData)
    vec = zeros(1, maxlength);
    vec(1,1:(length(RawData{i}(5:4:end-1))+1)) = [RawData{i}(1), RawData{i}(5:4:end-1)];
    A(i,:) = vec;    
end

% Now calculate the length of these columns of ones..

diffs = zeros(1,(maxlength - 1 + length(A(:,1))));
for i = 2:maxlength
    
    vec = A(:,i);
    
    flag = 0;
    for j = 1:length(vec)
        
        point = vec(j);
        
        
        if (flag == 0) && (point == 1)
            flag = 1;
            starttime = A(j,1);
        end
        
        if (flag == 1) && (point == 0)
            flag = 0;
            endtime = A(j-1,1);
            difference = endtime - starttime;
            
            diffs(1, end+1) = difference;
        end

    end
    
end

diffs = nonzeros(diffs);

hist(diffs);
