clc; clear; close all;

% Definiere Frequenzachse mit angepasster Breite
w = linspace(-4*pi, 4*pi, 1000); % Breitere Achse, um abgeschnittene Signale zu vermeiden

% Originales (analytisches) Spektrum U(w) - eine Gauß-Funktion
U_w = exp(-w.^2);

% Neue Abtastperiode Ta und Abtastfrequenz wa
Ta = pi/2; 
wa = 4*pi/Ta; % Noch weiter erhöhte Abtastfrequenz für größere Signalabstände
wg = pi/Ta;  % Grenzfrequenz für korrekte Platzierung der Peaks

% Erhöhter Abstand für die Signale rechts und links
shift_factor = 5; % Noch weiter entfernte Spektralkopien für mehr Oversampling

% Periodisches Spektrum mit nur 3 Peaks (-shift_factor * wg, 0, +shift_factor * wg)
n = [-1, 0, 1]; % Nur 3 Wiederholungen
U_a_w = zeros(size(w));

for k = n
    U_a_w = U_a_w + exp(-(w - k * shift_factor * wg).^2); % Noch weiter verschobene Kopien
end

% Erstelle kleinere Figur, ähnlich einem Subplot-Bereich
figure;
set(gcf, 'Position', [100, 100, 700, 250]); % Kleinere Höhe für kompaktere Darstellung

% --- Plotte das periodische Spektrum nach der Abtastung ---
plot(w, U_a_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); hold on; % Dunkelblau

% --- Plotte das noch flachere Rechteck-Tiefpassfilter ---
darkGreen = [0, 0.5, 0]; % Dunkelgrün RGB
H_TP = ones(size(w));
H_TP(abs(w) > wg) = 1 - (abs(w(abs(w) > wg)) - wg) / (3 * wg); % Noch sanftere Übergänge
H_TP(abs(w) > shift_factor * wg) = 0; % Begrenzung des Filters bei ±shift_factor * wg
plot(w, H_TP, '--', 'Color', darkGreen, 'LineWidth', 2);

% Achsenbeschriftungen
xlabel('\omega', 'FontSize', 14); 
ylabel('|U_a(\omega)|', 'FontSize', 14); 
title('Effect of Increased Over-Sampling with Wider Signal Separation', 'FontSize', 12, 'FontWeight', 'normal'); 

% Gitter und Achseneinstellungen
grid on;
xlim([-4*pi 4*pi]); % Breiter, um abgeschnittene Signale zu vermeiden
ylim([0, 1.2]); % Leicht über 1 für bessere Sichtbarkeit
set(gca, 'FontSize', 12);

% Markiere die wichtigen Frequenzpunkte
xticks([-shift_factor * wg, 0, shift_factor * wg]);
xticklabels({'-2\omega_g', '0', '2\omega_g'});

% Annotation für den Tiefpassfilter noch weiter nach rechts verschoben
text(1.5 * wg, 1.05, 'H_{TP}(\omega)', 'Color', darkGreen, 'FontSize', 12); % Noch weiter nach rechts verschoben

% Speichere die Figur als hochauflösendes PNG (600 DPI)
print('mein_plot', '-dpng', '-r600') % 600 DPI für beste Qualität in Quarto

hold off;