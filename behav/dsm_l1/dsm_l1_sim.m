%% Init
clc
clearvars
clear

%% Spec. normalized
N  = 64;             % simulation length (output samples)
cycles = 2;          % number of sinusoids
A  = 0.8;            % signal amplitude
offset = 0;
fs = 1;              % sampling frequency 
Ts  = 1/fs;          % time step
fx = cycles/(N*Ts);  % signal frequency

t = 0:Ts:(N-1)/fs;
u = A * sin(2 * pi * fx * t + 2*pi*rand(1));

%% Calibration of test system
L = 1;                % Order of modulator
form = 'CIFB';        % Cascade of integrator feedback
opt = 0;              % No optimisation
nLev = 2;             % Quantizer level
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

%% Simulink
mdl = 'dsm_l1_sim';
%load_system(mdl);
open_system(mdl);

%sigIn.time = ([0:N-1]/fs)';
%sigIn.signals(1).values = u';
%sigIn.signals(1).dimensions = 1;

%simOut = sim(mdl, 'Solver', 'FixedStepDiscrete', 'StopTime', num2str(max(t)), ...
%    'SaveState','on','StateSaveName','xout',...
%    'SaveOutput','on','OutputSaveName','yout',...
%    'SaveFormat', 'Dataset');

% Solver options
simoptions=simset( ...
    'Solver', 'FixedStepDiscrete', ...
    'RelTol', 1e-3, ...
    'MaxStep', Ts);

[t_, u_, simout] = sim(mdl, max(t), simoptions, [t', u']);
    
%% Post-processing quantizer gain
y = simout(:,1)'; % prime to adapt dimension
v = simout(:,2)'; % prime to adapt dimension
%y = simOut.yout.get('y').Values.Data';
%v = simOut.yout.get('v').Values.Data';
k = (v*y')/(y*y');

%% Time domain plot
fig1 = figure(1)
set(gca, 'fontsize', 14);
plot(t, u, 'LineWidth', 2);
axis([ min(t) max(t)/8 1.1*min(v) 1.1*max(v) ]);
hold on;
stairs(t, v, 'LineWidth', 2);
xlabel('Time t/T');
ylabel('Amplitude');
legend('u', 'v');
title('1st Order \Sigma\Delta');
hold off;

%% Spectral analysis, Lec. 4 - ADC Metrics
sq = abs(fft(v));

% Remove redundant half of spectrum and normalize to FS
f = [0:N/2-1]/N;  % frequency vector
z = exp(2i*pi*f);

sq_hlf = sq(1:end/2)/(N/2);
sqdBFS = 20*log10(sq_hlf);

% log10(0) -> -inf/inf correction
sqdBFS(isinf(sqdBFS)) = -150;

% Generate the magnitude plot with annotation
fig2 = figure(2);
set(gca, 'fontsize', 14);
plot(f, sqdBFS, 'linewidth', 2);
axis([0 0.06 -150 0]);
xlabel('Frequency f/fs')
ylabel('DFT Magnitude in dBFS')
grid;

%% Spectral analysis, delsig toolbox

% Normalize magnitudes to full-scale (FS=nLev-1=1) 
sqFS = sq/(N/2);

fig3 = figure(3);
set(gca, 'fontsize', 14);
plot(f, dbv(sqFS(1:end/2)), 'LineWidth', 2);
axis([0 0.06 -150 0]);
grid on;
ylabel('dBFS');
xlabel('f/fs')


%% Windowed plot
specHW = fft(v.*ds_hann(N))/(N/4);

fig4 = figure(4);
set(gca, 'fontsize', 14);
plot(f, dbv(specHW(1:end/2)), 'LineWidth', 2);
axis([0 0.06 -150 0]);
grid on;
ylabel('dBFS');
xlabel('f/fs');
