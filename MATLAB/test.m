close all; 
clear all;

disp('smoof');

a = ones(1,3);
b = 1:7;

% disp(length(a)); disp(length(b)); disp(length(b) - length(a))
spacefill = zeros(1, abs(length(b) - length(a)));


if length(a) < length(b)
    a = [a, spacefill];
elseif length(a) > length(b)
    b = [b, spacefill];
end 
c = a + b;

disp(c);