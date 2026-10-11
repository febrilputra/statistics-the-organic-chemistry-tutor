# Lesson 8.2 - Standard Normal Distribution with Calculus

> **Video:** [Normal Distribution & Probability Problems](https://www.youtube.com/watch?v=gHBL5Zau3NE) by The Organic Chemistry Tutor
> **Chapter:** [8 - Normal Probability Distributions](https://www.video-tutor.net/normal-probability-distributions.html)

## More precise empirical-rule percentages

The bell curve runs from $-\infty$ to $+\infty$ with total area 1 (100%). Each half is 50%.

| Within | Percent |
|---|---:|
| $\mu \pm 1\sigma$ | 68.27% |
| $\mu \pm 2\sigma$ | 95.45% |
| $\mu \pm 3\sigma$ | 99.73% |

Per region, using symmetry:

```
 0.135% | 2.14% | 13.59% | 34.13% | 34.13% | 13.59% | 2.14% | 0.135%
     μ-3σ    μ-2σ     μ-σ        μ       μ+σ     μ+2σ    μ+3σ
```

- $68.27 / 2 \approx 34.13$
- $(95.45 - 68.27)/2 \approx 13.59$
- $(99.73 - 95.45)/2 = 2.14$
- $(100 - 99.73)/2 = 0.135$

---

## The exact method: integrate the PDF

$$P(a < X < b) = \int_a^b \frac{1}{\sigma\sqrt{2\pi}}\, e^{-\frac{(x - \mu)^2}{2\sigma^2}}\, dx$$

There is no simple antiderivative, so evaluate it with a **graphing calculator** or an online tool such as a definite-integral calculator (e.g. Wolfram|Alpha).

**Typing tips:** put the whole exponent in parentheses and include the negative sign. For $\mu = 75$, $\sigma = 7$:

```
e^(-((x-75)^2)/(2*7^2)) / (7*sqrt(2*pi))
```

**For "greater than" questions, the upper limit is $+\infty$, not the maximum score.** Integrating up to 100 underestimates the answer. Use a very large number (1,000; 100,000), or ∞ if the tool accepts it, and check that the result has stopped changing.

---

## Example - physics test scores

800 students; scores are normal with $\mu = 75$, $\sigma = 7$.

Axis marks: 54, 61, 68, **75**, 82, 89, 96 (from $-3\sigma$ to $+3\sigma$).

**(a) What percentage scored between 68 and 82?** ($\pm 1\sigma$)

- Empirical rule: $34.134 + 34.134 = 68.27\%$
- Integral from 68 to 82: $0.682689 \to$ **68.27%** ✓

**(b) About how many students scored between 61 and 89?** ($\pm 2\sigma$)

- Empirical rule: $13.59 + 34.13 + 34.13 + 13.59 \approx 95.45\%$
- Integral from 61 to 89: $0.954500$
- Number of students: $0.9545 \times 800 \approx 763.6 \to$ **about 764 students**

**(c) P(score between 54 and 75)** ($-3\sigma$ to the mean)

- Empirical rule: $2.14 + 13.59 + 34.13 \approx 49.87\%$
- Integral from 54 to 75: $0.498650 \to$ **49.87%**

**(d) About how many students scored 96 or more?** (beyond $+3\sigma$)

- Empirical rule: **0.135%**
- Integral from 96 to 100: 0.00117. This is **too small**, because the curve continues past 100 (think of extra credit).
- Integral from 96 to 1,000 (effectively ∞): $0.0013499 \approx 0.135\%$ ✓
- Number of students: $0.0013499 \times 800 \approx 1.08 \to$ **about 1 student**

---

## Key takeaways

- More precise empirical-rule values: **68.27 / 95.45 / 99.73**, which split into 34.13 / 13.59 / 2.14 / 0.135 per region.
- The exact probability is the integral of the normal PDF between the limits. Use technology.
- For tails, integrate out to **infinity**, using a very large number if needed.
- To get a **count**, multiply the probability by the group size and round to a whole number.
