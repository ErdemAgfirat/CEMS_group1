clc; clear; close all;

% Definiere Frequenzachse mit begrenzter Breite
w = linspace(-2.5*pi, 2.5*pi, 1000); % Frequenzbereich

% Originales Spektrum U(w) - Gauß-Funktion
U_w = exp(-w.^2);

% Abtastperiode Ta und Abtastfrequenz wa
Ta = pi/2;
wa = 2*pi/Ta; % Abtastfrequenz

% Neue Frequenzbezeichnungen: omega_g
omega_g = wa / 2; % Setze omega_g relativ zu wa

% Periodisches Spektrum mit begrenzten Wiederholungen (-1, 0, +1)
n = -1:1; 
U_a_w = zeros(size(w));

for k = n
    U_a_w = U_a_w + exp(-(w - k*2*omega_g).^2); % Verschobene Kopien des Spektrums
end

% Erstelle Figur mit kompakter Höhe
figure;
set(gcf, 'Position', [100, 100, 700, 500]); % Höhe angepasst für zwei Subplots

% --- Plotte das Originalspektrum mit kurzen vertikalen Linien an ±ω_g ---
subplot(2,1,1);
plot(w, U_w, 'Color', [1, 0.5, 0], 'LineWidth', 3); hold on; % Orange Linie
xlabel('\omega', 'FontSize', 14);
ylabel('|U(\omega)|', 'FontSize', 14);
title('Original Spectrum |U(\omega)|', 'FontSize', 12, 'FontWeight', 'normal');
grid on;
xlim([-2.5*pi 2.5*pi]); % Begrenzter Bereich
set(gca, 'FontSize', 12, 'XTick', [], 'XColor', 'k'); % Entfernt Zahlen auf der x-Achse

% **Kurze vertikale Striche bei ±omega_g für die Markierung**
plot([omega_g, omega_g], [0, 0.05], 'k', 'LineWidth', 1.5);
plot([-omega_g, -omega_g], [0, 0.05], 'k', 'LineWidth', 1.5);

% **Markierung für ω_g direkt unterhalb der Achse**
text(omega_g, -0.05, '\omega_g', 'FontSize', 14, 'HorizontalAlignment', 'center');
text(-omega_g, -0.05, '-\omega_g', 'FontSize', 14, 'HorizontalAlignment', 'center');

hold off;

% --- Plotte das periodische Spektrum nach der Abtastung ---
subplot(2,1,2);
plot(w, U_a_w, 'Color', [1, 0.5, 0], 'LineWidth', 3); hold on; % Orange Linie
xlabel('\omega', 'FontSize', 14);
ylabel('|U_a(\omega)|', 'FontSize', 14);
title('Sampled Spectrum |U_a(\omega)| (Limited Replication)', 'FontSize', 12, 'FontWeight', 'normal');
grid on;
xlim([-2.5*pi 2.5*pi]); % Begrenzter Bereich
set(gca, 'FontSize', 12); % Schriftgröße für Achsen

% Markiere die Wiederholungsfrequenzen als ±2ω_g
xticks([-2*omega_g, 0, 2*omega_g]);
xticklabels({'-2\omega_g', '0', '2\omega_g'});

hold off;
