%% Init LTspice2Matlab
addpath("../ltspice2matlab/")

%% Read raw
raw_data = LTspice2Matlab('dsm_l2.raw', [])
disp( sprintf('\n\nThis file contains %.0f variables:\n', raw_data.num_variables) );
disp( sprintf('NAME         TYPE\n-------------------------') );
disp( [char(raw_data.variable_name_list), ...
    char(zeros(raw_data.num_variables,5)), ...
    char(raw_data.variable_type_list)] );

%% Read raw vin, vx1, vq
raw_data = LTspice2Matlab('dsm_l2.raw',[1 3 4 5]);
ts = raw_data.time_vect;
vin = raw_data.variable_mat(1,:);
vx1 = raw_data.variable_mat(2,:);
vx2 = raw_data.variable_mat(3,:);
vq  = raw_data.variable_mat(4,:);

%% Init
N = length(vq);
fs = 220e3;
Ts = 1/fs;
fx = 80;
FS = 1.4; % full-scale amplitude
f = [0:N/2-1]/N; % frequency vector

%% Generate signal and FFT
s = abs(fft(vq));

% Windowing
N = length(vq);
vqw = vq.*hann(N)';
sw = abs(fft(vqw));

% Remove redundant half of spectrum
s_hlf = s(1:end/2);
sw_hlf = sw(1:end/2);

% Normalize magnitude to dBFS
% dbFS = dB relative to FS
sdBFS = 20*log10(2*s_hlf/N/FS);
swdBFS = 20*log10(2*sw_hlf/N/FS);

%% Generate the magnitude plot with annotation
fig1 = figure(1);
set(gca, 'fontsize', 14);
plot(f, sdBFS, f, swdBFS, 'linewidth', 2);
xlabel('Frequency f/fs')
ylabel('DFT Magnitude in dBFS')
grid;
legend('No Window', 'Hann Window')


%% Export figure
N = length(v_d);
f = linspace(0, 0.5, N/2+1);
specHW = abs(fft(vq.*hann(N)));

fig1 = figure(1);
plot(f, dbv(specHW(1:N/2+1)));
axis([0 0.2 -150 0]);
grid on;
ylabel('dBFS/NBW');
