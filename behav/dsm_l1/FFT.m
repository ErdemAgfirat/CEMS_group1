% Parameterdefinition
N = 2048;          % Anzahl der Samples
cycles = 67;       % Anzahl der Signalzyklen
fs = 1000;         % Abtastrate (Hz)
ts = 1 / fs;       % Abtastperiode
fx = cycles * fs / N;  % Signal-Frequenz
FSR = 1;           % Full Scale Range
B = 10;            % Anzahl der Quantisierungsbits
LSB = (2 * FSR) / (2 ^ B);  % Kleinste Stufe der Quantisierung

% Erzeuge das ursprüngliche Sinussignal
x = FSR * sin(2 * pi * fx / fs * (0:N-1));

% Quantisierung des Signals
xq = round(x / LSB) * LSB;

% Berechnung der spektralen Komponenten mittels FFT
sq = abs(fft(xq));

% Normalisierung des Spektrums
sq_hlf = sq(1:N/2) * 2 / N / FSR;
sqdBFS = 20 * log10(sq_hlf);

% Ersetze -inf Werte durch einen minimalen Pegel (-150 dBFS)
sqdBFS(isinf(sqdBFS)) = -150;

% Signal- und Rauschkomponenten für SNR-Berechnung
sigbin = cycles + 1;
noise = [sq_hlf(1:sigbin-1), sq_hlf(sigbin+1:end)];

% Signal-Rausch-Verhältnis (SNR) in dB
snr = 10 * log10(sq_hlf(sigbin) ^ 2 / sum(noise .^ 2));

% Ausgabe des SNR-Werts
fprintf('Signal-to-Noise Ratio (SNR): %.2f dB\n', snr);

% Darstellung des Spektrums
figure;
plot([0:N/2-1] * fs / N, sqdBFS, 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dBFS)');
title('Spectrum of Quantized Signal');
grid on;
