clc; clear; close all;

% Definiere Zeitachse
T_a = 1;  % Abtastperiode
t = linspace(-T_a, 4*T_a, 1000);  % Kontinuierliche Zeitachse für Darstellung
n = -1:4;  % Abtastwerte bei diskreten Zeitpunkten

% Originalsignal (Beispiel: exponentiell wachsendes Signal)
u = exp(0.5 * n);

% Sinc-Interpolation
reconstructed_signal = zeros(size(t));
for k = 1:length(n)
    reconstructed_signal = reconstructed_signal + u(k) * sinc((t - n(k) * T_a) / T_a);
end

% Farben entsprechend der gewünschten Darstellung
signal_color = [0, 0, 0.5];  % Dunkelblau für das rekonstruierte Signal
sinc_color = [0, 0.5, 0];    % Dunkelgrün für die einzelnen Sinc-Funktionen

% Erstelle die Figur
figure;
set(gcf, 'Position', [100, 100, 700, 250]); % Kleinere Höhe (250 px statt 500 px)
hold on; grid on;

% Plot des rekonstruierten Signals in dunkelblau
plot(t, reconstructed_signal, 'Color', signal_color, 'LineWidth', 2); 

% Plot der einzelnen Sinc-Funktionen (dunkelgrün gestrichelt)
for k = 1:length(n)
    plot(t, u(k) * sinc((t - n(k) * T_a) / T_a), '--', 'Color', sinc_color, 'LineWidth', 1.5);
end

% Achsenbeschriftung in der gewünschten Schriftgröße und -art
xlabel('$t$', 'Interpreter', 'Latex', 'FontSize', 12); % x-Achse
ylabel('$u(t)$', 'Interpreter', 'Latex', 'FontSize', 12); % y-Achse

% Titel in der passenden Schriftgröße und ohne Fettdruck
title('Sinc Interpolation', 'FontSize', 12, 'FontWeight', 'normal');

% Achsen-Ticks
ax = gca;
ax.FontSize = 12; % Einheitliche Schriftgröße
ax.XTick = n * T_a;
ax.XTickLabel = {'-T_a', '0', 'T_a', '2T_a', '3T_a', '4T_a'};

% Horizontale Achsenlinie in Schwarz
plot([-T_a, 4*T_a], [0 0], 'k', 'LineWidth', 1);

hold off;
