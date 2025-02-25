import numpy as np
import matplotlib.pyplot as plt

# Daten generieren
x = np.linspace(-10, 10, 1000)
y = np.exp(-x**2)

# Plot-Stil anpassen
plt.figure(figsize=(6, 4))
plt.plot(x, y, color='darkorange', linewidth=3)

# Achsenbeschriftungen mit LaTeX
plt.xlabel(r'$\omega$', fontsize=14)
plt.ylabel(r'$|U(\omega)|$', fontsize=14)

# Achsen verschieben (um sie wie Pfeile wirken zu lassen)
plt.axhline(0, color='black', linewidth=1)
plt.axvline(0, color='black', linewidth=1)

# Pfeilspitzen an den Achsen
plt.xlim(-10, 10)
plt.ylim(-0.1, 1.1)
plt.annotate("", xy=(10, 0), xytext=(-10, 0), arrowprops=dict(arrowstyle="->", color='black'))
plt.annotate("", xy=(0, 1.1), xytext=(0, -0.1), arrowprops=dict(arrowstyle="->", color='black'))

# Markierung für ω_g
plt.text(2.5, -0.05, r'$\omega_g$', fontsize=14, ha='center')

# Keine Gitterlinien
plt.grid(False)

# Anzeigen
plt.show()
