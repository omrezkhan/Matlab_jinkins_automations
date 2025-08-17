%% Air Spring System Simulation Automation Script
% Author: Omrez Khan
% Date: 2025-08-17
% Description: Simulates the air spring system, saves CSV + plots automatically,
%              and generates JUnit XML report for Jenkins pass/fail reporting.

function air_spring_script(m, k, c, outputFolder, maxDisp, maxVel, maxAcc)
clc;

%% ---------------- Default Parameters ----------------
if nargin < 3 || isempty(m); m = 500; end
if nargin < 2 || isempty(k); k = 20000; end
if nargin < 3 || isempty(c); c = 1500; end
if nargin < 4 || isempty(outputFolder); outputFolder = 'plots'; end

% Default thresholds
if nargin < 5 || isempty(maxDisp); maxDisp = 0.1; end
if nargin < 6 || isempty(maxVel);  maxVel  = 1.0; end
if nargin < 7 || isempty(maxAcc);  maxAcc  = 5.0; end

%% ---------------- Workspace Setup ----------------
% Assign variables to base workspace for Simulink
assignin('base', 'm', m);
assignin('base', 'k', k);
assignin('base', 'c', c);

% Create output folder
if ~exist(outputFolder, 'dir'); mkdir(outputFolder); end

%% ---------------- Simulation ----------------
simTime = 10;                  % Simulation time (s)
modelName = 'air_spring_zf';   % Simulink model name
load_system(modelName);

simOut = sim(modelName, 'StopTime', num2str(simTime));

% Extract simulation data
displacement = simOut.yout{1}.Values.Data;
velocity     = simOut.yout{2}.Values.Data;
acceleration = simOut.yout{3}.Values.Data;
time         = simOut.yout{1}.Values.Time;

timestamp = datestr(now,'yyyy_mm_dd_HH_MM_SS');

% Save CSV
csvFileName = fullfile(outputFolder, ['air_spring_simulation_data_' timestamp '.csv']);
writematrix([time, displacement, velocity, acceleration], csvFileName);
disp(['Simulation data saved to ', csvFileName]);

% Plot Results
figure('Position',[100 100 800 600]);
subplot(3,1,1); plot(time, displacement,'LineWidth',1.5); xlabel('Time (s)'); ylabel('Displacement (m)'); title('Displacement'); grid on;
subplot(3,1,2); plot(time, velocity,'LineWidth',1.5); xlabel('Time (s)'); ylabel('Velocity (m/s)'); title('Velocity'); grid on;
subplot(3,1,3); plot(time, acceleration,'LineWidth',1.5); xlabel('Time (s)'); ylabel('Acceleration (m/s^2)'); title('Acceleration'); grid on;

figFileName = fullfile(outputFolder, ['air_spring_simulation_plot_' timestamp '.png']);
saveas(gcf, figFileName);
disp(['Simulation plot saved to ', figFileName]);

%% ---------------- JUnit XML Generation ----------------
passFlag = true;
if max(abs(displacement)) > maxDisp; passFlag = false; end
if max(abs(velocity)) > maxVel;     passFlag = false; end
if max(abs(acceleration)) > maxAcc; passFlag = false; end

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

if passFlag
    disp('Simulation PASSED all limits checks.');
else
    disp('Simulation FAILED limits check.');
end

end

