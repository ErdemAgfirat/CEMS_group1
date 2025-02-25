clc; clear; close all;

% Definiere Frequenzachse mit noch größerer Breite
w = linspace(-4*pi, 4*pi, 1000); % Noch breitere Achse für mehr Sichtbarkeit

% Originales (analytisches) Spektrum U(w) - eine Gauß-Funktion
U_w = exp(-w.^2);

% Neue Abtastperiode Ta und Abtastfrequenz wa
Ta = pi/2; 
wa = 4*pi/Ta; % Noch weiter erhöhte Abtastfrequenz für größere Signalabstände
wg = pi/Ta;  % Grenzfrequenz für korrekte Platzierung der Peaks

% Periodisches Spektrum mit begrenzten Wiederholungen (-1, 0, +1)
n = -1:1; % Weniger Wiederholungen (nur 3 insgesamt)
U_a_w = zeros(size(w));

for k = n
    U_a_w = U_a_w + exp(-(w - k*2*wg).^2); % Verschobene Kopien des Spektrums bei +-2wg
end

% Erstelle kleinere Figur, ähnlich einem Subplot-Bereich
figure;
set(gcf, 'Position', [100, 100, 700, 250]); % Kleinere Höhe (250 px statt 500 px)

% --- Plotte das periodische Spektrum nach der Abtastung ---
plot(w, U_a_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); hold on; % Dunkelblau

% --- Plotte den neuen flachen Rechteck-Tiefpassfilter ---
darkGreen = [0, 0.5, 0]; % Dunkelgrün RGB
H_TP = ones(size(w));
H_TP(abs(w) > wg) = 1 - (abs(w(abs(w) > wg)) - wg) / (wg); % Sanfte Übergänge
H_TP(abs(w) > 2*wg) = 0; % Begrenzung des Filters bei 2wg
plot(w, H_TP, '--', 'Color', darkGreen, 'LineWidth', 2);

% Achsenbeschriftungen
xlabel('\omega', 'FontSize', 14); 
ylabel('|U_a(\omega)|', 'FontSize', 14); 
title('Sampled Spectrum with Flat Rectangular Low-Pass Filter', 'FontSize', 12, 'FontWeight', 'normal'); 

% Gitter und Achseneinstellungen
grid on;
xlim([-4*pi 4*pi]); % Noch breiterer Bereich
ylim([0, 1.2]); % Leicht über 1 für bessere Sichtbarkeit
set(gca, 'FontSize', 12);

% Markiere die wichtigen Frequenzpunkte
xticks([-2*wg, -wg, 0, wg, 2*wg]);
xticklabels({'-2\omega_g', '-\omega_g', '0', '\omega_g', '2\omega_g'});

% Annotation für den Tiefpassfilter
text(wg + 0.2, 1.05, 'H_{TP}(\omega)', 'Color', darkGreen, 'FontSize', 12);

hold off;