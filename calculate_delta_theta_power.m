function [delta_power, theta_power] = calculate_delta_theta_power(eeg_data)

% Filter the signal
N = length(eeg_data);
fs = 150; % Sampling frequency
hp = 0.5; % High pass cutoff frequency in Hz
lp = 50; % Low pass cutoff frequency in Hz
[b,a] = butter(4, [hp/(fs/2), lp/(fs/2)]);
temp_filt = filtfilt(b,a,eeg_data);

% Remove line noise
wo = 50/(fs/2);
bw = wo/35;
[b,a] = iirnotch(wo,bw);
temp_filt = filtfilt(b,a,temp_filt);

% Apply notch filter to remove 60Hz power-line noise
wo = 60/(fs/2);
bw = wo/35;
[b,a] = iirnotch(wo,bw);
temp_filt = filtfilt(b,a,temp_filt);

% Apply artifact rejection based on thresholding
threshold = 80; % Threshold value in microvolts
idx = abs(temp_filt) > threshold;
temp_filt(idx) = NaN;

% Interpolate missing data
temp_filt = fillmissing(temp_filt,'linear');

% Calculate FFT
fft_data = fft(temp_filt);
P2 = abs(fft_data/N);
P1 = P2(1:N/2+1);
f = fs*(0:(N/2))/N;

% Find delta and theta frequencies
delta_range = [0.5 4];
theta_range = [4 8];
delta_idx = f>=delta_range(1) & f<=delta_range(2);
theta_idx = f>=theta_range(1) & f<=theta_range(2);

% Calculate delta and theta power
delta_power = sum(P1(delta_idx).^2);
theta_power = sum(P1(theta_idx).^2);

end
