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

%% % histogram_demo.m
% histogram_auto.m
% Generate random data and plot a histogram, then save in 'plots' folder

% Generate random data
data = randn(1000,1);

% Create a histogram
figure;
histogram(data, 20); % 20 bins
title('Histogram of Random Data');
xlabel('Value');
ylabel('Frequency');

% Save the figure automatically
outputFolder = 'plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Create folder if it doesn't exist
end

filename = fullfile(outputFolder, 'histogram_plot.png');
saveas(gcf, filename);

disp(['Plot saved as ', filename]);

%%
%% MATLAB Automation Script - Add Boxplot
% Generate random data
dataBox = randn(100,1);

% Create a boxplot
figure;
boxplot(dataBox);
title('Boxplot of Random Data');
ylabel('Value');

% Save the figure automatically
outputFolder = 'plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Create folder if it doesn't exist
end

filenameBoxplot = fullfile(outputFolder, 'boxplot_random_data.png');
saveas(gcf, filenameBoxplot);

disp(['Boxplot saved as ', filenameBoxplot]);

%% MATLAB Automation Script - Sine Wave with Noise

% Parameters
fs = 1000;          % Sampling frequency
t = 0:1/fs:1;       % Time vector (1 second)
f = 5;              % Frequency of sine wave
noiseAmp = 0.3;     % Noise amplitude

% Generate clean sine wave
y_clean = sin(2*pi*f*t);

% Add random noise
y_noisy = y_clean + noiseAmp*randn(size(t));

% Plot noisy sine wave
figure;
plot(t, y_noisy, 'r', 'LineWidth', 1.5);
hold on;
plot(t, y_clean, 'b--', 'LineWidth', 1.5);
title('Noisy Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Noisy', 'Clean');
grid on;

% Save the figure automatically
outputFolder = 'plots';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
filenameFig = fullfile(outputFolder, 'noisy_sine_wave.png');
saveas(gcf, filenameFig);
disp(['Figure saved as ', filenameFig]);

% Save data as CSV
data = [t' y_noisy'];
filenameCSV = fullfile(outputFolder, 'noisy_sine_wave_data.csv');
writematrix(data, filenameCSV);
disp(['Data saved as ', filenameCSV]);




