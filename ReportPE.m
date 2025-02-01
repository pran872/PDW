% Report Question 3 - PE and KE of physical model

clear all
close all
clc

%% Initialise fixed parameters

ramp_angle = 4;
mass = 0.029;
g = 9.80665;


%% Open digitized data from video

data = readtable('12_38_1_rod_data_xypts.csv');

rod_x = data{:, 1};
rod_y = data{:, 2};

% include onlt frames without NaN value
clean_rod_x = rmmissing(rod_x); 
clean_rod_y =rmmissing(rod_y);

% flip data (didn't use this in the end)
frames = 0:length(clean_rod_x)-1; 
flipped_rod_x = clean_rod_x(end:-1:1);
flipped_rod_y = clean_rod_y(end:-1:1);

% plot of flipped data to see rod x and y
figure;
scatter(frames, flipped_rod_x, 'LineWidth', 2, 'Color', 'r');
hold on;
scatter(frames, flipped_rod_y);

%% Detrend PE
PE = mass * g * (clean_rod_y*0.0002987 + tan(ramp_angle*pi/180) .* clean_rod_x*0.0002987);
PE_trend = mass * g * clean_rod_y*0.0002987;

%% KE
time = frames * 1/240;
% Obtain the velocity in the x and z direction
CoM_vx = gradient((clean_rod_x*0.0002987),time);
CoM_vz = gradient((clean_rod_y*0.0002987),time);

% Moving average on the CoM velocity to smoothen
window_size = 20;
CoM_vx_smoothed = movmean(CoM_vx, window_size);
CoM_vz_smoothed = movmean(CoM_vz, window_size);

% Obtain the magnitude of the vectors and calculate KE
CoM_v = sqrt(CoM_vx_smoothed.^2 + CoM_vz_smoothed.^2);
CoM_KE = 1/2*mass*(CoM_v).^2;

%% Plot KE and detrended PE

time = frames * 1/240;
figure;
plot(time, PE, '-r', 'LineWidth', 1.5);
hold on;
plot(time, CoM_KE, '-b', 'LineWidth', 1.5);
hold on;

plot([1.0125 1.0125],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([1.1125 1.1125],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([1.2375 1.2375],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;
plot([1.3583 1.3583],ylim,'Color', [0 0 0 0.6], 'LineStyle', '--', 'LineWidth', 1);
hold on;

xlabel('Time (s)', 'FontSize',20);
ylabel('Energy (J)', 'FontSize',20);
legend('PE', 'KE', 'FontSize', 40);
title('Kinetic Energy and Detrended Potential Energy against Time', 'FontSize',20); 

