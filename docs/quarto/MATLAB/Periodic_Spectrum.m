clc; clear; close all;

% Definiere Frequenzachse mit begrenzter Breite
w = linspace(-2.5*pi, 2.5*pi, 1000); % Kürzere Achse für kompaktere Darstellung

% Originales (analytisches) Spektrum U(w) - eine Gauß-Funktion
U_w = exp(-w.^2); 

% Abtastperiode Ta und Abtastfrequenz wa
Ta = pi/2; 
wa = 2*pi/Ta; % Abtastfrequenz

% Periodisches Spektrum mit begrenzten Wiederholungen (-1, 0, +1)
n = -1:1; % Weniger Wiederholungen (nur 3 insgesamt)
U_a_w = zeros(size(w));

for k = n
    U_a_w = U_a_w + exp(-(w - k*wa).^2); % Verschobene Kopien des Spektrums
end

% Erstelle Figur mit kompakter Höhe (Subplot-Stil)
figure;
set(gcf, 'Position', [100, 100, 700, 500]); % Höhe angepasst für zwei Subplots

% --- Plotte das Originalspektrum ---
subplot(2,1,1);
plot(w, U_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); hold on; % Dunkelblau
xlabel('\omega', 'FontSize', 14); 
ylabel('|U(\omega)|', 'FontSize', 14); 
title('Original Spectrum |U(\omega)|', 'FontSize', 12, 'FontWeight', 'normal'); 
grid on;
xlim([-2.5*pi 2.5*pi]); % Horizontal eingeschränkter Bereich
set(gca, 'FontSize', 12); % Angepasste Schriftgröße

% --- Plotte das periodische Spektrum nach der Abtastung (nur 3 Wiederholungen) ---
subplot(2,1,2);
plot(w, U_a_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); hold on; % Dunkelblau
xlabel('\omega', 'FontSize', 14); 
ylabel('|U_a(\omega)|', 'FontSize', 14); 
title('Sampled Spectrum |U_a(\omega)| (Limited Replication)', 'FontSize', 12, 'FontWeight', 'normal'); 
grid on;
xlim([-2.5*pi 2.5*pi]); % Begrenzter Bereich für bessere Sichtbarkeit
set(gca, 'FontSize', 12); % Schriftgröße für Achsen

% Markiere die Wiederholungsfrequenzen
xticks([-2*wa, -wa, 0, wa, 2*wa]);
xticklabels({'-2\omega_a', '-\omega_a', '0', '\omega_a', '2\omega_a'});

hold off;