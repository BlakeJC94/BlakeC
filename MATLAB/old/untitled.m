X=[1.1 1.4 1.2 1.1];
Y=[1.4 1.4 1.1];
a = [1 11] - 1;

bar((1:numel(X))+a(1)-0.5, X, 'b')
hold on
bar((1:numel(Y))+a(2), Y, 'r')
hold off
set(gca,'XTickMode','auto')
legend({'X','Y'})