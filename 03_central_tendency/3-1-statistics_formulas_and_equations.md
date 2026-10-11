# Lesson 3.1 - Statistics Formulas and Equations

> **Video:** [Statistics - Formulas and Equations](https://www.youtube.com/watch?v=FP6qS5d3Ly4) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

A reference sheet of the basic formulas used at the start of a statistics course. Later lessons in this chapter work through each one in detail.

---

## 1. Median, mode, range, quartiles

**Example data** ($n = 9$, already sorted): 2, 3, 5, 5, 7, 8, 9, 10, 12

| Quantity | Definition | Value |
|---|---|---|
| Median ($Q_2$, 50th percentile) | Middle value | 7 |
| Mode | Most frequent value | 5 (appears twice) |
| Range | max − min | $12 - 2 = 10$ |
| $Q_1$ (25th percentile) | Median of the lower half | 5 (video) |
| $Q_3$ (75th percentile) | Median of the upper half | 9 (video) |
| IQR | $Q_3 - Q_1$ | $9 - 5 = 4$ |

> **Quartile conventions differ.** The video's $Q_1 = 5$ and $Q_3 = 9$ come from **including** the median 7 in both halves (2 3 5 **5** 7 and 7 8 **9** 10 12). The Lesson 1.1 method **excludes** the median, giving halves 2 3 5 5 and 8 9 10 12, so $Q_1 = 4$ and $Q_3 = 9.5$. Use whichever method your course uses, and use it consistently.

---

## 2. Arithmetic (sample) mean

$$\bar x = \frac{\sum x}{n} = \frac{x_1 + x_2 + \dots + x_n}{n}$$

Example: $\bar x = \dfrac{2+3+5+5+7+8+9+10+12}{9} = \dfrac{61}{9} \approx 6.78$

---

## 3. Four kinds of mean

### For two numbers $a$ and $b$

| Mean | Formula |
|---|---|
| Arithmetic (AM) | $\dfrac{a+b}{2}$ |
| Geometric (GM) | $\sqrt{ab}$ |
| Harmonic (HM) | $\dfrac{2}{\frac1a + \frac1b} = \dfrac{2ab}{a+b}$ |
| Root mean square (RMS) | $\sqrt{\dfrac{a^2+b^2}{2}}$ |

For any two positive numbers:

$$\text{HM} \le \text{GM} \le \text{AM} \le \text{RMS}, \qquad \text{GM} = \sqrt{\text{AM} \cdot \text{HM}}$$

**Quick check with $a = 4$, $b = 9$:** AM = 6.5, GM = 6, HM = $72/13 \approx 5.54$, RMS = $\sqrt{48.5} \approx 6.96$. The order is 5.54 ≤ 6 ≤ 6.5 ≤ 6.96 ✓, and $\sqrt{6.5 \times 5.54} = 6$ ✓.

### For $n$ numbers

| Mean | Formula |
|---|---|
| Arithmetic | $\bar x = \dfrac{x_1 + x_2 + \dots + x_n}{n}$ |
| Geometric | $(x_1 \cdot x_2 \cdots x_n)^{1/n}$ |
| Harmonic | $\dfrac{n}{\frac{1}{x_1} + \frac{1}{x_2} + \dots + \frac{1}{x_n}}$ |
| Root mean square | $\sqrt{\dfrac{x_1^2 + x_2^2 + \dots + x_n^2}{n}}$ |
| **Weighted** | $\bar x_w = \dfrac{\sum w x}{\sum w} = \dfrac{w_1x_1 + w_2x_2 + \dots + w_nx_n}{w_1 + w_2 + \dots + w_n}$ |

With $n = 2$ the geometric-mean formula becomes $(ab)^{1/2} = \sqrt{ab}$.

---

## 4. Sample vs population symbols

| | Sample | Population |
|---|:---:|:---:|
| Mean | $\bar x$ | $\mu$ |
| Size | $n$ | $N$ |
| Standard deviation | $s$ | $\sigma$ |
| Variance | $s^2$ | $\sigma^2$ |

Example: a city has $N = 10{,}000$ residents, but a study surveys $n = 300$ of them. $n$ and $N$ are different numbers.

---

## 5. Standard deviation and variance

| | Sample | Population |
|---|---|---|
| Standard deviation | $s = \sqrt{\dfrac{\sum (x - \bar x)^2}{n - 1}}$ | $\sigma = \sqrt{\dfrac{\sum (x - \mu)^2}{N}}$ |
| Variance | $s^2 = \dfrac{\sum (x - \bar x)^2}{n - 1}$ | $\sigma^2 = \dfrac{\sum (x - \mu)^2}{N}$ |

- The **sample** formulas divide by $n - 1$. The **population** formulas divide by $N$.
- Variance = (standard deviation)², the same formula without the square root.

---

## 6. Coefficient of variation (CV)

$$\text{CV}_{\text{sample}} = \frac{s}{\bar x} \times 100\%, \qquad \text{CV}_{\text{population}} = \frac{\sigma}{\mu} \times 100\%$$

The CV expresses the standard deviation as a **percentage of the mean**. A CV of 0.25 (25%) means the standard deviation is 25% of the mean.

---

## 7. Mean absolute deviation (MAD)

$$\text{MAD} = \frac{\sum |x - \bar x|}{n}$$

It looks like the standard deviation, but it uses **absolute values instead of squares** and has **no square root**.

---

## Key takeaways

- Know the four means (AM, GM, HM, RMS), their order HM ≤ GM ≤ AM ≤ RMS, and the weighted mean.
- Sample formulas use $\bar x$, $n$, $s$ and divide variance by $n - 1$. Population formulas use $\mu$, $N$, $\sigma$ and divide by $N$.
- CV = SD ÷ mean × 100%. MAD = average absolute distance from the mean.
