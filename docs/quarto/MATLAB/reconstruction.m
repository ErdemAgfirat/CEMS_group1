clc; clear; close all;

% Definiere Frequenzachse mit begrenzter Breite
w = linspace(-2.5*pi, 2.5*pi, 1000); % Kürzere Achse für kompaktere Darstellung

% Originales (analytisches) Spektrum U(w) - eine Gauß-Funktion
U_w = exp(-w.^2); 

% Abtastperiode Ta und Abtastfrequenz wa
Ta = pi/2; 
wa = 2*pi/Ta; % Abtastfrequenz
wg = pi/Ta;  % Grenzfrequenz des idealen Tiefpassfilters

% Periodisches Spektrum mit begrenzten Wiederholungen (-1, 0, +1)
n = -1:1; % Weniger Wiederholungen (nur 3 insgesamt)
U_a_w = zeros(size(w));

for k = n
    U_a_w = U_a_w + exp(-(w - k*wa).^2); % Verschobene Kopien des Spektrums
end

% Erstelle kleinere Figur, ähnlich einem Subplot-Bereich
figure;
set(gcf, 'Position', [100, 100, 700, 250]); % Kleinere Höhe (250 px statt 500 px)

% --- Plotte das periodische Spektrum nach der Abtastung ---
plot(w, U_a_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); hold on; % Dunkelblau

% --- Plotte den idealen Tiefpassfilter (dunkelgrüne gestrichelte Linie) ---
darkGreen = [0, 0.5, 0]; % Dunkelgrün RGB
plot([-wg, -wg, wg, wg], [0, 1, 1, 0], '--', 'Color', darkGreen, 'LineWidth', 2); 

% Achsenbeschriftungen
xlabel('\omega', 'FontSize', 14); 
ylabel('|U_a(\omega)|', 'FontSize', 14); 
title('Sampled Spectrum with Ideal Low-Pass Filter', 'FontSize', 12, 'FontWeight', 'normal'); 

% Gitter und Achseneinstellungen
grid on;
xlim([-2.2*pi 2.2*pi]); % Begrenzter Bereich für bessere Sichtbarkeit
ylim([0, 1.2]); % Leicht über 1 für bessere Sichtbarkeit
set(gca, 'FontSize', 12); % Angepasste Schriftgröße für kompaktere Darstellung

% Markiere die wichtigen Frequenzpunkte
xticks([-2*wg, -wg, 0, wg, 2*wg]);
xticklabels({'-2\omega_g', '-\omega_g', '0', '\omega_g', '2\omega_g'});

% Annotation nur für den Tiefpassfilter
text(wg + 0.2, 1.05, 'H_{TP}(\omega)', 'Color', darkGreen, 'FontSize', 12);

hold off;