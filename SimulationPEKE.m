% Report Question 3 - PE and KE of simulation 

clear all
close all
clc

load_system('PDW_Simulation')

%% Initialise fixed parameters

max_run_time = 5;
maximum_step_size = 0.001;
relative_tolerance = 1e-3;
PDW_Simulation_DataFile4
set_param(bdroot,'Solver','ode23')
mass = 0.029;


%% Initialise variable parameters

ramp_angle = 4;
initial_inter_leg_angle = 38;
initial_stance_angle = 12;

set_model_parameters(ramp_angle, initial_inter_leg_angle, initial_stance_angle)
threshold = 0.1*initial_inter_leg_angle*pi/180;


%% Run Experiment
% Set simulation parameters
set_model_parameters(ramp_angle, initial_inter_leg_angle, initial_stance_angle);
    
% Start the simulation
set_param('PDW_Simulation', 'SimulationCommand', 'start');

% % Monitor the simulation
while strcmp(get_param('PDW_Simulation', 'SimulationStatus'), 'running')
    pause(0.1);
end

%% Obtain CoM output

CoM_height = out.CoM.Data(:,3);
CoM_length =  out.CoM.Data(:,1);
time = out.CoM.Time;

g = 9.80665;

%% PE (detrended)

CoM_PE = mass * g * (CoM_height + tan(ramp_angle*pi/180) .* CoM_length);

%% KE

% Obtain the velocity in the x and z direction
CoM_vx = gradient((CoM_length),time);
CoM_vz = gradient((CoM_height),time);

% Moving average on the CoM velocity to smoothen
window_size = 2000;
CoM_vx_smoothed = movmean(CoM_vx, window_size);
CoM_vz_smoothed = movmean(CoM_vz, window_size);

% Obtain the magnitude of the vectors and calculate KE
CoM_v = sqrt(CoM_vx_smoothed.^2 + CoM_vz_smoothed.^2);
CoM_KE = 1/2*mass*(CoM_v).^2;

%% Plot KE and detrended PE

figure;
hold on;
plot(time, CoM_KE, 'LineWidth', 2); 
hold on;
plot(time, CoM_PE, 'LineWidth', 2, 'Color',[0.8500 0.3250 0.0980]);

%plot the vertical lines
ylim([-0.003 0.006])
hold on;
plot([0.079 0.079],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([0.407 0.407],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([0.601 0.601],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([0.767 0.767],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([0.913 0.913],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([1.55 1.55],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([1.85 1.85],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([2.16 2.16],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);

xlabel('Time (s)', 'FontSize',20);
ylabel('Energy (J)', 'FontSize',20);
title('Kinetic Energy and Detrended Potential Energy against Time', 'FontSize',20); 
xlim([0 3])
legend('KE', 'PE', 'FontSize', 30);