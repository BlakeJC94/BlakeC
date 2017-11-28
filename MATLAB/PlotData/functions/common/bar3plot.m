function bar3plot(x_vec,y_vec,A,e) % e floor up to digit at 10^(e)

h = floor(min(min(A))*10^(-e))*10^(e);
figure;
b = bar3(A-h,1);
set(gca,'XTickLabel',y_vec);
set(gca,'YTickLabel',x_vec);

for i=1:numel(b)
    %# get the ZData matrix of the current group
    Z = get(b(i), 'ZData');
    
    %# row-indices of Z matrix. Columns correspond to each rectangular bar
    rowsInd = reshape(1:size(Z,1), 6,[]);
    
    %# find bars with zero height
    barsIdx = all([Z(2:6:end,2:3) Z(3:6:end,2:3)]==0, 2);
    
    %# replace their values with NaN for those bars
    Z(rowsInd(:,barsIdx),:) = NaN;
    
    %# update the ZData
    set(b(i), 'ZData',Z)
end



for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end


colormap(jet)
cb = colorbar;
set(cb,'TickLabels',cb.Ticks + h);
%set(cb, 'YTickLabel', cellstr(num2str(reshape(get(cb, 'YTick'),[],1),'%1.1e')) )
view(-90,90);
axis tight;


end