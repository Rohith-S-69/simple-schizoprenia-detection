clc;
clear;
close all;

%To find threshold value
Raw_eeg = importdata('eeg_data.csv');% Replace your file name
extract = Raw_eeg.data;
eeg_data = extract(2:end,1);

figure;
subplot(2,1,1);
plot(eeg_data);
title('Raw EEG Signal to find threshold');
xlabel('Sample Number');
ylabel('Amplitude');

[delta_threshold, theta_threshold] = calculate_delta_theta_power(eeg_data);

fprintf('The delta threshold value for given dataset: %f\n', delta_threshold);
fprintf('The theta threshold value for given dataset: %f\n\n', theta_threshold);

% Continous Monitoring
Raw_eeg = importdata('eeg_data.csv');% Replace your file name
extract = Raw_eeg.data;
eeg_data = extract(2:end,1);

subplot(2,1,2);
plot(eeg_data);
title('Raw EEG Signal for monitoring');
xlabel('Sample Number');
ylabel('Amplitude');

interval_size = 50;
start_index = 1;
for i = start_index:interval_size:length(eeg_data)-interval_size+1
    interval_data = eeg_data(i:i+interval_size-1);
    [delta_power, theta_power] = calculate_delta_theta_power(interval_data);
    disp(delta_power);

    if delta_power > delta_threshold
        fprintf('In Interval %d to %d Schizoprenia Detected\n', i, i+interval_size-1);
        

    end
    if theta_power > theta_threshold
        fprintf('In Interval %d to %d Schizoprenia Detected\n', i, i+interval_size-1);
        
    end
end
