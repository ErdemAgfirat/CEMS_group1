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

% Erhöhe den Noise-Pegel für bessere Sichtbarkeit
noise_level = 0.6; % Erhöhter Rauschpegel

% Erstelle eine neue Figur nur mit dem zweiten Subplot
figure;
set(gcf, 'Position', [100, 100, 700, 250]); % Kompakte Höhe für besseres Layout

% --- Plotte das periodische Spektrum nach der Abtastung mit Noise ---
hold on;
plot(w, U_a_w, 'Color', [0, 0, 0.5], 'LineWidth', 2); % Dunkelblau

% Fülle den Bereich für Quantisierungsrauschen als rote Fläche
fill([w fliplr(w)], [zeros(size(w)) noise_level*ones(size(w))], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

xlabel('\omega', 'FontSize', 14);
ylabel('|U_a(\omega)|', 'FontSize', 14);
title('Sampled Spectrum |U_a(\omega)| with Quantization Noise', 'FontSize', 12, 'FontWeight', 'normal');
grid on;
xlim([-2.5*pi 2.5*pi]);
ylim([0, 1.2]); % Platz für Noise sichtbar halten
set(gca, 'FontSize', 12);

% Markiere die Wiederholungsfrequenzen
xticks([-2*wa, -wa, 0, wa, 2*wa]);
xticklabels({'-2\omega_a', '-\omega_a', '0', '\omega_a', '2\omega_a'});

% Legende hinzufügen
legend({'Sampled Spectrum', 'Quantization Noise'}, 'FontSize', 10);

hold off;
