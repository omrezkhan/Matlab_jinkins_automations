%% MATLAB Automation Script
% This script generates random data, plots it, and saves the figure automatically

% Generate random data
x = 1:10;
y = rand(1,10); % 10 random numbers between 0 and 1

% Create a figure
figure;
plot(x, y, '-o', 'LineWidth', 2);
title('Random Data Plot');
xlabel('X-axis');
ylabel('Y-axis');
grid on;

% Save the figure automatically
outputFolder = 'plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Create folder if it doesn't exist
end

filename = fullfile(outputFolder, 'random_plot.png');
saveas(gcf, filename);

disp(['Plot saved as ', filename]);
