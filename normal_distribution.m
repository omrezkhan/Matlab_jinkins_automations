% Normal Distribution Automation Script
disp('Generating normal distribution data');

% Parameters for normal distribution
mu = 0;         % Mean
sigma = 1;      % Standard deviation
numSamples = 1000;

% Generate random data
data = mu + sigma * randn(1, numSamples);

% Plot histogram
figure;
histogram(data, 30); % 30 bins
title('Normal Distribution Histogram');
xlabel('Value');
ylabel('Frequency');

% Save the figure automatically
outputFolder = 'plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Create folder if it doesn't exist
end

filename = fullfile(outputFolder, 'normal_distribution_hist.png');
saveas(gcf, filename);

disp(['Plot saved as ', filename]);
