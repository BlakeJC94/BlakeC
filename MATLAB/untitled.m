a = [0.8147, 0.9058, 0.1270, 0.9134, 0.6324];
av = mean(a);

smoof = a(1);
for k = 2:5
    smoof = ((k-1)*smoof + a(k))./k;
end

disp(smoof)
disp(av)