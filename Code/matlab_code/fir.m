% Step 1: Read the .hex file
fid = fopen('C:\Users\ACER\Downloads\audio.hex', 'r');
hex_values = textscan(fid, '%s');
fclose(fid);
hex_values = hex_values{1};

% Step 2: Convert the hexadecimal values to 24-bit signed integers
signal = zeros(length(hex_values), 1);  % Preallocate the signal array
for i = 1:length(hex_values)
    dec_val = hex2dec(hex_values{i});  % Convert hex to decimal
    if dec_val >= 2^23  % Handle 24-bit signed integer
        dec_val = dec_val - 2^24;  % Adjust for 24-bit signed integers
    end
    signal(i) = dec_val;  % Store the value
end

% Step 3: Normalize the signal to the range [-1, 1] if necessary
normalized_signal = signal / (2^23);
noisy_signal = normalized_signal;
% Assume your noisy signal is stored in 'noisy_signal'
Fs = 44100;  % Sampling frequency (adjust as per your data)
cutoff_freq = 50;  % Cutoff frequency for the low-pass filter in Hz
filter_order = 29;  % Order of the FIR filter (higher order for sharper cutoff)

% Step 1: Design the FIR filter using fir1
fir_coeff = fir1(filter_order, cutoff_freq/(Fs/2), 'low');

% Step 2: Apply the FIR filter to the noisy signal
filtered_signal = filtfilt(fir_coeff, 1, noisy_signal);  % Zero-phase filtering

% Step 3: Plot the original and filtered signal for comparison
t = (0:length(noisy_signal)-1) / Fs;  % Time vector for plotting

figure;
subplot(2,1,1);
plot(t, noisy_signal);
title('Original Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filtered_signal);
title('Filtered Signal with FIR Filter');
xlabel('Time (s)');
ylabel('Amplitude');

% Step 4: Display the FIR filter coefficients
disp('FIR Filter Coefficients:');
disp(fir_coeff);
% Step 5 (Optional for Audio): Play the audio if it's an audio signal
sound(normalized_signal, Fs);  % Play the sound if it's audio
