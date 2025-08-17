function air_spring_script(m, k, c, outputFolder)
% AIR_SPRING_SCRIPT Run air spring Simulink simulation and save plots
%
%   air_spring_script(m, k, c, outputFolder)
%
%   Inputs:
%       m           - Mass (kg)
%       k           - Spring constant (N/m)
%       c           - Damping coefficient (Ns/m)
%       outputFolder- Folder to save plots and JUnit XML

% Ensure output folder exists
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Simulation parameters
modelName = 'air_spring_zf';  % Replace with your Simulink model name
simTime = 10;                  % Simulation stop time (seconds)

% Load the Simulink model
load_system(modelName);

% Prepare simulation input
simIn = Simulink.SimulationInput(modelName);
simIn = simIn.setVariable('m', m);
simIn = simIn.setVariable('k', k);
simIn = simIn.setVariable('c', c);
simIn = simIn.setModelParameter('StopTime', num2str(simTime));  % Correct StopTime

% Run simulation
simOut = sim(simIn);

% Example: extract output (replace with your signal names)
time = simOut.tout;
try
    displacement = simOut.logsout.getElement('displacement').Values.Data;
    velocity = simOut.logsout.getElement('velocity').Values.Data;
catch
    warning('No logsout signals found. Skipping plot generation.');
    displacement = [];
    velocity = [];
end

% Save plots
if ~isempty(displacement)
    figure;
    plot(time, displacement);
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    title('Air Spring Displacement');
    saveas(gcf, fullfile(outputFolder, 'displacement_plot.png'));
end

if ~isempty(velocity)
    figure;
    plot(time, velocity);
    xlabel('Time (s)');
    ylabel('Velocity (m/s)');
    title('Air Spring Velocity');
    saveas(gcf, fullfile(outputFolder, 'velocity_plot.png'));
end

% Optional: Generate JUnit XML test result for Jenkins
resultsFile = fullfile(outputFolder, 'results.xml');
fid = fopen(resultsFile, 'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid, '<testsuite name="AirSpringTest">\n');
fprintf(fid, '  <testcase classname="AirSpring" name="SimulationRun"/>\n');
fprintf(fid, '</testsuite>\n');
fclose(fid);

% Close the model without saving changes
close_system(modelName, 0);

disp('Simulation completed successfully.');
end

