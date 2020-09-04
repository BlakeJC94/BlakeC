function paper_diff_profiles_plots()

% load dependencies
addpath(genpath('src/common/'));

% declare variables
figureDir = 'output/diffProfiles/';

pdf_width = 7;
width_height_ratio = 7/5;
pdf_label_size = 15;

pltspec = {'r', 'k', 'b'};
figname = {'Step', 'Linear', 'Ramp'};

x = 0:0.01:20;
axisvec = [0, 20, -0.1, 1.1];

alpha = [...
    0.25, 0.5, 0.75; ...
    0.3, 0.6, 0.9; ...
    0.25, 0.5, 0.75 ...
];

x_annot = [...
    0.25, 0.85, 8; ...
    0.35, 0.55, 10; ...
    0.2, 0.5, 7 ...
];
y_annot = [...
    0.45, 0.45, 0.45; ...
    0.85, 0.4, 0.47; ...
    0.7, 0.45, 0.25 ...
];

% check output dir
if ~exist(figureDir, 'dir')
   mkdir(figureDir)
end

% define profiles
func{1} = @(x, alpha) (x > 20*alpha) .* (x <= 20);
func{2} = @(x, alpha) 1 - alpha .* (1 - x/20);
func{3} = @(x, alpha) x/(20*alpha) .* (x <= 20*alpha) +  (x > 20*alpha);

% plot curves
for i = 1:3
    
    figure(1); clf;
    
    hold on
    for j = 1:3
        plot(x, func{i}(x,alpha(i,j)), pltspec{j})
    end
    annotation('arrow', x_annot(i,1:2), y_annot(i,1:2));
    text(x_annot(i,3), y_annot(i,3),'\alpha')
    hold off

    axis(axisvec)

    xlabel("$$x$$", 'Interpreter', 'latex');
%     ystr = strcat("$$p_{\textrm{\scriptsize ", figname{i}, "}}(x)$$");
%     ylabel(ystr, 'Interpreter', 'latex');

    SaveAsPngEpsAndFig(-1, strcat(figureDir, lower(figname{i})), pdf_width, width_height_ratio, pdf_label_size);

end

end
