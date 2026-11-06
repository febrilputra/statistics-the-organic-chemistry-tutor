"""Render the CLT-to-confidence-interval illustration for Lesson 9.1.

Run with Python, NumPy, and Matplotlib installed. Outputs are written beside
this script so the Markdown image link works from any working directory.
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np


OUTPUT = Path(__file__).resolve().parent
BLUE = "#0072B2"
ORANGE = "#D55E00"
INK = "#243447"
MUTED = "#526171"

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "font.size": 12,
    "text.color": INK,
    "axes.labelcolor": INK,
    "xtick.color": INK,
    "ytick.color": INK,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "svg.fonttype": "none",
})

fig, axes = plt.subplots(
    3, 1, figsize=(11, 11.2),
    gridspec_kw={"height_ratios": [1.1, 1.1, 0.8]},
)
fig.subplots_adjust(left=0.11, right=0.97, top=0.86, bottom=0.13, hspace=0.95)
fig.suptitle("From the CLT to a confidence interval", fontsize=22, y=0.97)
fig.text(0.5, 0.929, "Known population standard deviation | 95% confidence", ha="center", color=MUTED)

critical = 1.96
z = np.unique(np.r_[np.linspace(-3.7, 3.7, 1101), -critical, critical])
density = np.exp(-z**2 / 2) / np.sqrt(2 * np.pi)

for ax in axes[:2]:
    ax.plot(z, density, color=BLUE, linewidth=2.5)
    center = np.abs(z) <= critical
    ax.fill_between(z, density, where=center, color=BLUE, alpha=0.20)
    ax.fill_between(z, density, where=z <= -critical, color=ORANGE, alpha=0.23)
    ax.fill_between(z, density, where=z >= critical, color=ORANGE, alpha=0.23)
    for cutoff in [-critical, critical]:
        ax.vlines(cutoff, 0, np.exp(-cutoff**2 / 2) / np.sqrt(2 * np.pi), color=MUTED, linewidth=1)
    ax.set_xlim(z.min(), z.max())
    ax.set_ylim(0, 0.47)
    ax.set_yticks([0, 0.2, 0.4])
    ax.set_ylabel("Density")
    ax.spines["bottom"].set_color(MUTED)
    ax.spines["left"].set_color(MUTED)
    ax.text(0, 0.19, "95%", ha="center", fontsize=18, color=INK)

axes[0].set_title("A  |  Choose a central area on the standard normal curve", loc="left", pad=18)
axes[0].set_xticks([-critical, 0, critical], ["-1.96", "0", "+1.96"])
axes[0].set_xlabel(r"Standardized sample mean  $Z=(\bar X-\mu)/\mathrm{SE}$", labelpad=10)
for sign in [-1, 1]:
    axes[0].annotate(
        "2.5%", xy=(sign * 2.45, 0.012), xytext=(sign * 2.8, 0.13),
        ha="center", color=INK,
        arrowprops={"arrowstyle": "->", "color": ORANGE, "lw": 1.3},
    )

axes[1].set_title(r"B  |  Sample means vary around the fixed population mean $\mu$", loc="left", pad=18)
axes[1].set_xticks(
    [-critical, 0, critical],
    [r"$\mu-1.96\,\mathrm{SE}$", r"$\mu$", r"$\mu+1.96\,\mathrm{SE}$"],
)
axes[1].set_xlabel(r"Sample mean $\bar X$  (original measurement units)", labelpad=10)
axes[1].set_ylabel("Density (schematic)")
axes[1].set_yticks([])
axes[1].text(0, 0.10, r"$\mathrm{SE}=\sigma/\sqrt{n}$", ha="center", fontsize=14)

ax = axes[2]
xbar, sigma, n = 79.0, 5.4, 50
se = sigma / np.sqrt(n)
margin = critical * se
low, high = xbar - margin, xbar + margin
ax.set_title(r"C  |  Rearrange, then center the interval on the observed $\bar x$", loc="left", pad=28)
ax.set_xlim(xbar - 3 * se, xbar + 3 * se)
ax.set_ylim(-0.1, 1)
ax.set_yticks([])
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_visible(False)
ax.tick_params(axis="x", length=0, pad=12)
ax.hlines(0.28, low, high, color=BLUE, linewidth=5)
ax.vlines([low, high], 0.20, 0.36, color=BLUE, linewidth=2.5)
ax.scatter([xbar], [0.28], s=95, color=ORANGE, zorder=3)
ax.set_xticks(
    [low, xbar, high],
    [rf"$\bar x-\mathrm{{EBM}}$" + f"\n{low:.4f}", r"$\bar x$" + f"\n{xbar:g}", rf"$\bar x+\mathrm{{EBM}}$" + f"\n{high:.4f}"],
)
for start, end in [(low, xbar), (xbar, high)]:
    ax.annotate("", xy=(start, 0.66), xytext=(end, 0.66), arrowprops={"arrowstyle": "<->", "color": MUTED, "lw": 1.3})
    ax.text((start + end) / 2, 0.79, f"EBM = {margin:.4f}", ha="center")
ax.set_xlabel("Population mean test score (points); true value remains unknown", labelpad=12)

fig.text(0.5, 0.017, r"A and B describe repeated sample means. C shows one interval, not a probability curve for $\mu$.", ha="center", color=MUTED, fontsize=11)

for extension in ("png", "svg"):
    fig.savefig(OUTPUT / f"clt_to_confidence_interval.{extension}", dpi=180, facecolor="white")
plt.close(fig)
print(f"SE = {se:.8f}; EBM = {margin:.8f}; CI = [{low:.8f}, {high:.8f}]")
