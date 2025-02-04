% Report Question 3 - PE and KE of physical (digitised) model

clear all
close all
clc

%% Initialise fixed parameters

ramp_angle = -4; % negative slope since video is filmed this way
mass = 0.029;
g = 9.80665;


%% Open digitized data from video

data = readtable('pixel_data_correct_ref.csv');

rod_x = data{:, 1};
rod_y = data{:, 2};

frames = 0:length(rod_x)-1; 


% Plot of flipped data to see rod x and y
figure;
scatter(frames, rod_x, 'LineWidth', 2);
hold on;
scatter(frames, rod_y, 'LineWidth', 2);

%% Detrend PE

% Convert from pixels to mm
rod_x_mm = rod_x*0.0002987;
rod_y_mm = rod_y*0.0002987;

% Compute PE
rod_PE = mass * g * (rod_y_mm + tan(ramp_angle*pi/180) * rod_x_mm);

%% KE rod

% Obtain time 
time = frames * 1/240; % 240 frames per second (FPS)

% Obtain the velocity in the x and z direction
rod_vx = gradient((rod_x_mm*0.0002987),time);
rod_vz = gradient((rod_y_mm*0.0002987),time);

% Moving average on the CoM velocity to smoothen
window_size = 20;
rod_vx_smoothed = movmean(rod_vx, window_size);
rod_vz_smoothed = movmean(rod_vz, window_size);

% Obtain the magnitude of the vectors and calculate KE
rod_v = sqrt(rod_vx_smoothed.^2 + rod_vz_smoothed.^2);
rod_KE = 1/2*mass*(rod_v).^2;


%% Plot KE and detrended PE

time = frames * 1/240;

figure;
yyaxis left;
plot(time, rod_KE, 'LineWidth', 2);
hold on;
yyaxis right;
plot(time, rod_PE, 'LineWidth', 2);
hold on;

plot([3.3 3.3],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([3.51 3.51],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([3.73 3.73],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([3.97 3.97],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([4.225 4.225],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;

xlabel('Time (s)', 'FontSize',20);
ylabel('Energy (J)', 'FontSize',20);
legend('KE', 'PE', 'FontSize', 30);
title('Kinetic Energy and Detrended Potential Energy against Time', 'FontSize',20); 

