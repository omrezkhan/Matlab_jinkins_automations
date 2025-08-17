%% Air Spring System Simulation Automation Script
% Author: Omrez Khan
% Date: 2025-08-13
% Description: Simulates the air spring system and saves CSV + plots automatically
%              Adds JUnit XML report for Jenkins pass/fail reporting

function air_spring_script(m, k, c, outputFolder)
clc

% Default values if parameters not provided
if nargin < 3
    m = 500;              % Mass (kg)
    k = 20000;            % Spring stiffness (N/m)
    c = 1500;             % Damping coefficient (Ns/m)
end

% Default output folder if not provided
if nargin < 4
    outputFolder = fullfile(pwd, 'plots');  % default folder
end

% Create output folder if it does not exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Change current directory to output folder parent
cd(fileparts(outputFolder));

% Assign variables to base workspace for Simulink
assignin('base', 'm', m);
assignin('base', 'k', k);
assignin('base', 'c', c);

% Simulation Parameters
simTime = 10;          % Simulation time in seconds

% Load Simulink Model
modelName = 'air_spring_zf';
load_system(modelName);

% Run Simulation
simOut = sim(modelName, 'StopTime', num2str(simTime));

% Extract output data
displacement = simOut.yout{1}.Values.Data;
velocity     = simOut.yout{2}.Values.Data;
acceleration = simOut.yout{3}.Values.Data;
time         = simOut.yout{1}.Values.Time;

% Optional: Timestamp for files
timestamp = datestr(now,'yyyy_mm_dd_HH_MM_SS');

% Save Data to CSV
csvFileName = fullfile(outputFolder, ['air_spring_simulation_data_' timestamp '.csv']);
data = [time, displacement, velocity, acceleration];
writematrix(data, csvFileName);
disp(['Simulation data saved to ', csvFileName]);

% Plot Results
figure('Position',[100 100 800 600]);
subplot(3,1,1);
plot(time, displacement, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Displacement (m)');
title('Air Spring Displacement'); grid on;

subplot(3,1,2);
plot(time, velocity, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Velocity (m/s)');
title('Air Spring Velocity'); grid on;

subplot(3,1,3);
plot(time, acceleration, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)');
title('Air Spring Acceleration'); grid on;

% Save figure
figFileName = fullfile(outputFolder, ['air_spring_simulation_plot_' timestamp '.png']);
saveas(gcf, figFileName);
disp(['Simulation plot saved to ', figFileName]);

disp('Air spring simulation completed successfully!');

%% ---------------- JUnit XML Generation ----------------
% Define pass/fail conditions
maxDisplacementAllowed = 0.001; % meters
maxVelocityAllowed     = 0.001; % m/s
maxAccelerationAllowed = 0.001; % m/s^2

passFlag = true;
if max(abs(displacement)) > maxDisplacementAllowed
    passFlag = false;
end
if max(abs(velocity)) > maxVelocityAllowed
    passFlag = false;
end
if max(abs(acceleration)) > maxAccelerationAllowed
    passFlag = false;
end

% Create JUnit XML content
xmlFileName = fullfile(outputFolder, ['junit_air_spring_' timestamp '.xml']);
fid = fopen(xmlFileName,'w');
fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<testsuites>\n');
fprintf(fid,'  <testsuite name="AirSpringSimulation" tests="1" failures="%d">\n', ~passFlag);
fprintf(fid,'    <testcase classname="AirSpringSimulation" name="CheckLimits">\n');
if ~passFlag
    fprintf(fid,'      <failure message="Limits exceeded">Simulation exceeded allowed limits.</failure>\n');
end
fprintf(fid,'    </testcase>\n');
fprintf(fid,'  </testsuite>\n');
fprintf(fid,'</testsuites>\n');
fclose(fid);

disp(['JUnit XML report generated: ', xmlFileName]);

% Return pass/fail flag (optional for MATLAB console)
if passFlag
    disp('Simulation PASSED all limits checks.');
else
    disp('Simulation FAILED limits check.');
end
end

