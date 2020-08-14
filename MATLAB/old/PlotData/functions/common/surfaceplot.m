function surfaceplot(X,Y,A)

figure;
surf(X', Y', A);
xlabel('$$p_a$$', 'Interpreter', 'latex'); ylabel('$$p_d$$', 'Interpreter', 'latex');
colormap(jet)
colorbar;
view(0,90);

end


% [X,Y] = meshgrid(ap_vec,dp_vec);
% surfaceplot(X,Y, ssonsets)
% title('Onsets');

