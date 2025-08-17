%% Air Spring System Simulation Automation Script
% Author: Omrez Khan
% Date: 2025-08-13
% Description: Simulates the air spring system and saves CSV + plots automatically

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
    outputFolder = 'plots';
end

% Create output folder if it does not exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Simulation Parameters
simTime = 10;          % Simulation time in seconds

% Load Simulink Model
modelName = 'air_spring_zf';
load_system(modelName);

% Prepare simulation input with variables
simIn = Simulink.SimulationInput(modelName);
simIn = simIn.setVariable('m', m);
simIn = simIn.setVariable('k', k);
simIn = simIn.setVariable('c', c);

% Run Simulation
simOut = sim(simIn, 'StopTime', num2str(simTime));

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

% ---- Generate JUnit XML report ----
testName = 'AirSpringSimulation';
testsuiteName = 'AirSpringTests';
xmlFileName = fullfile(outputFolder, ['test_results_' timestamp '.xml']);

% Example test condition: displacement max < 0.2 m
maxDisp = max(abs(displacement));
pass = maxDisp < 0.2;  

fid = fopen(xmlFileName, 'w');
fprintf(fid, '<testsuite name="%s" tests="1" failures="%d">\n', testsuiteName, ~pass);
fprintf(fid, '  <testcase classname="%s" name="%s">\n', testsuiteName, testName);
if ~pass
    fprintf(fid, '    <failure message="Displacement too high">Max displacement = %.4f</failure>\n', maxDisp);
end
fprintf(fid, '  </testcase>\n');
fprintf(fid, '</testsuite>\n');
fclose(fid);

disp(['JUnit test results saved to ', xmlFileName]);

end

