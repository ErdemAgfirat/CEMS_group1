%% 1st order Modulator System
clc
clear all

%% Calibration of test system
L = 1;                % Order of modulator
form = 'CIFB';        % Cascade of integrator feedback
fs = 220e3;           % Sampling frequency 
Ts = 1/fs;            % Sampling time
M = 512;              % OSR
N = 16*M;             % Simulation length (output samples), FFT points
fB = fs/2/M;          % Bandwidth
cycles = 9;           % Number of sinusoids
fx = cycles * fs/N;   % Test tone
A = 0.8;              % Signal amplitude
t = Ts * [0:N-1];
u = A * sin(2 * pi * fx/fs * [0:N-1]);

%% Design NTF
H = synthesizeNTF(L, M);

%% Bode plot
f = linspace(0, 0.5, N/2+1);
z = exp(2i*pi*f);
fig2 = figure(2);
plot(f, dbv(evalTF(H, z)));
sigma_H = dbv( rmsGain(H, 0, 0.5/M))

%% Realize SDM
[a, g, b, c] = realizeNTF(H, form);
b(2:end) = 0;
ABCD = stuffABCD(a, g, b, c, form);
[ABCDs umax] = scaleABCD(ABCD);
[a, g, b, c] = mapABCD(ABCDs, form);

%% Simulate DSM with delsig toolbox
[v, xn, xmax, y] = simulateDSM(u, ABCD);

%% Time-domain plot of DSM with delsig toolbox
fig3 = figure(3);
set(gca, 'fontsize', 14);
plot(t, u, 'LineWidth', 2);
hold on;
stairs(t, v, 'LineWidth', 2);
hold off;
axis([ min(t) max(t)/8 1.1*min(v) 1.1*max(v) ]);
xlabel('Time t/T');
ylabel('Amplitude');
legend('u', 'v');
title('1st Order \Sigma\Delta');

%% Spectral Anlysis, FFT
sq = abs(fft(v));

% Remove redundant half of spectrum and normalize to FS
f = [0:N/2-1]/N;  % frequency vector
FSR = 1;  % Full-scale range

sq_hlf = sq(1:end/2)*2/N/FSR;
sqdBFS = 20*log10(sq_hlf);

% log10(0) -> -inf/inf correction
sqdBFS(isinf(sqdBFS)) = -150;

% Calculate SNR
sigbin = 1 + cycles;
noise = [sq_hlf(1:sigbin-1), sq_hlf(sigbin+1:end)];
snr = 10*log10(sq_hlf(sigbin)^2/sum(noise.^2))

% Generate the magnitude plot with annotation
fig4 = figure(4);
set(gca, 'fontsize', 14);
plot(f, sqdBFS, 'linewidth', 2);
xlabel('Frequency f/fs')
ylabel('DFT Magnitude in dBFS')
grid;

%% Spectral analysis, delsig toolbox

% Normalize magnitudes to full-scale (FS=nLev-1=1) 
sqFS = sq/(N/2);

fig5 = figure(5);
set(gca, 'fontsize', 14);
plot(f, dbv(sqFS(1:end/2)), 'LineWidth', 2);
axis([0 0.06 -150 0]);
grid on;
ylabel('dBFS');
xlabel('f/fs')


%% Windowed plot
specHW = fft(v.*ds_hann(N))/(N/4);

fig6 = figure(6);
set(gca, 'fontsize', 14);
plot(f, dbv(specHW(1:end/2)), 'LineWidth', 2);
axis([0 0.06 -150 0]);
grid on;
ylabel('dBFS');
xlabel('f/fs');
