%% ADS1115 Modulator System
clc
clear all

%% Calibration of test system
L = 2;                % Order of modulator
form = 'CIFB';        % Cascade of integrator feedback
fs = 220e3;           % Sampling frequency 
M = 512;              % OSR
N = 16*M;             % Simulation length (output samples), FFT points
fB = fs/2/M;          % Bandwidth
cycles = 9;           % Number of sinusoids
fx = cycles * fs/N;   % Test tone
A = 0.8;              % Signal amplitude

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
tsamples = 0:2048;
stairs(tsamples, u(tsamples+1));
hold on;
stairs(tsamples, v(tsamples+1));
hold off;
axis([0 2048 -1.2 1.2])

%% Spectral Anlysis, Lec. 4 - ADC Metrics
sq = abs(fft(v));

% Remove redundant half of spectrum and normalize to FS
f = [0:N/2-1]/N;  % frequency vector
FSR = 1;  % Full-scale range

sq_hlf = sq(1:end/2)*2/N/FSR;
sqdBFS = 20*log10(sq_hlf);

% log10(0) -> -inf/inf correction
sqdBFS(isinf(sqdBFS)) = -150;

%% Generate the magnitude plot with annotation
fig4 = figure(4);
set(gca, 'fontsize', 14);
plot(f, sqdBFS, 'linewidth', 2);
xlabel('Frequency f/fs')
ylabel('DFT Magnitude in dBFS')
grid;

%% Decimation filter
% Taking signal v as input which is output of SDM.
% x_sine -> SDM -> v -> SINC3 -> DCF -> HBF1 -> HBF2 -> I2C_out
% Assume fB = 20 kHz, fx = 20 kHz
% 120 kS/s at output

% SINC3
Nsinc = 64; % downsampling ratio
h1 = zeros(1, Nsinc);
h1(1:Nsinc) = 1/Nsinc;
hsinc1 = ones(1, Nsinc)*1/Nsinc;
hsinc2 = conv(hsinc1, hsinc1);
hsinc3 = conv(hsinc1, hsinc2);

%% Filter SDM output
Sinc3outOrg = conv(hsinc3, v);
Sinc3out = downsample(Sinc3outOrg, Nsinc);

%% Droop correction filter (DCF)
DCF = fdesign.decimator(Nsinc, 'ciccomp', 1, 3, 'n,fc,ap,ast', 12, 0.45, 0.05, 60);
Hdcf = design(DCF, 'equiripple', 'SystemObject', true);
DCFnum = Hdcf.Numerator;
[DCFfreq, w3] = freqz(DCFnum, 1);
[DCFimp, tw3] = impz(DCFnum, 1);

%% Filter operation
DCFout = conv(Sinc3out, DCFimp);

%% Half-band filter 1 (HBF1)
FsHBF1 = fs/Nsinc;
HBF1taps = 26;
HBF1num = firhalfband(HBF1taps, 0.25);
[hbf1f, w1] = freqz(HBF1num, 1);
[hbf1t, tw1] = impz(HBF1num, 1);
HBF1outOrg = conv(DCFout, hbf1t);
HBF1out = downsample(HBF1outOrg, 2);

%% Half-band filter 2 (HBF2)
FsHBF2 = FsHBF1/2;
HBF2taps = 50;
HBF2num = firhalfband(HBF2taps, 0.25);
[hbf2f, w2] = freqz(HBF2num, 1);
[hbf2t, tw2] = impz(HBF2num, 1);
HBF2outOrg = conv(HBF1out, hbf2t);
HBF2out = downsample(HBF2outOrg, 2);
