# Lesson 13.2 - Correlation Coefficient

> **Video:** [Correlation Coefficient](https://www.youtube.com/watch?v=11c9cs6WpJU) by The Organic Chemistry Tutor
> **Chapter:** [13 - Regression & Correlation](https://www.video-tutor.net/linear-regression.html)

## What $r$ tells you

The **correlation coefficient** $r$ (sometimes written $\rho$) measures the **strength and direction of the linear relationship** between two variables. $-1 \le r \le 1$.

| $r$ | Picture | Relationship |
|---|---|---|
| $+1$ | All points exactly on a line going **up** | Perfect positive (direct): $y$ rises as $x$ rises |
| $-1$ | All points exactly on a line going **down** | Perfect negative (inverse): $y$ falls as $x$ rises |
| close to $\pm 1$ (e.g. 0.8) | Points close to a line | Strong linear relationship |
| smaller (e.g. 0.6-0.7) | Points more scattered around the line | Weaker linear relationship |
| ≈ 0 | Random cloud of points | No linear relationship |

The **sign** of $r$ matches the sign of the slope. The **size** of $r$ shows how tightly the points hug the line.

## Formula

$$r = \frac{n\sum xy - \sum x\sum y}{\sqrt{\left[n\sum x^2 - \left(\sum x\right)^2\right]\left[n\sum y^2 - \left(\sum y\right)^2\right]}}$$

$n$ = number of $(x, y)$ pairs.

---

## Example

| $x$ | $y$ | $xy$ | $x^2$ | $y^2$ |
|---:|---:|---:|---:|---:|
| 1 | 2 | 2 | 1 | 4 |
| 2 | 4 | 8 | 4 | 16 |
| 3 | 7 | 21 | 9 | 49 |
| 4 | 9 | 36 | 16 | 81 |
| 5 | 12 | 60 | 25 | 144 |
| 6 | 14 | 84 | 36 | 196 |
| **Sum** | **48** | **211** | **91** | **490** |

$\sum x = 21$, $\;\sum y = 48$, $\;\sum xy = 211$, $\;\sum x^2 = 91$, $\;\sum y^2 = 490$, $\;n = 6$

**Numerator:** $6(211) - 21(48) = 1266 - 1008 = 258$

**Denominator:**

- $6(91) - 21^2 = 546 - 441 = 105$
- $6(490) - 48^2 = 2940 - 2304 = 636$
- $\sqrt{105 \times 636} = \sqrt{66{,}780} \approx 258.42$

$$r = \frac{258}{258.42} \approx 0.998$$

A **very strong positive** linear relationship: as $x$ increases, $y$ increases almost exactly along a straight line.

---

## Key takeaways

- $r$ ranges from −1 to +1. The sign gives the direction and the size gives the strength of the **linear** relationship.
- Build a table of $x$, $y$, $xy$, $x^2$, $y^2$, add each column, then use the formula.
- $r \approx 0$ means no *linear* relationship. There could still be a curved one.
- Correlation is not causation.
