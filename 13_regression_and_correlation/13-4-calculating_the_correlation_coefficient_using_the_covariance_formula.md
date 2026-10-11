# Lesson 13.4 - Calculating the Correlation Coefficient Using the Covariance Formula

> **Video:** [How To Calculate The Correlation Coefficient Using The Covariance Formula](https://www.youtube.com/watch?v=5wIiOFnXSYs) by The Organic Chemistry Tutor
> **Chapter:** [13 - Regression & Correlation](https://www.video-tutor.net/linear-regression.html)

## Two equivalent formulas

**Method 1 - from the covariance:**

$$r = \frac{\text{cov}(x, y)}{s_x\,s_y}, \qquad \text{cov}(x, y) = \frac{\sum (x - \bar x)(y - \bar y)}{n - 1}, \qquad s_x = \sqrt{\frac{\sum (x - \bar x)^2}{n - 1}}$$

Dividing the covariance by both standard deviations removes the units and puts $r$ on the −1 to +1 scale.

**Method 2 - the computational formula** (Lesson 13.2):

$$r = \frac{n\sum xy - \sum x\sum y}{\sqrt{\left[n\sum x^2 - (\sum x)^2\right]\left[n\sum y^2 - (\sum y)^2\right]}}$$

---

## Data

$x$: 3, 4, 6, 8, 9 $\qquad$ $y$: 4, 5, 9, 10, 12 $\qquad n = 5$

---

## Method 1 - covariance and standard deviations

$\bar x = 30/5 = 6$, $\;\bar y = 40/5 = 8$

| $x$ | $y$ | $x - \bar x$ | $y - \bar y$ | product | $(x - \bar x)^2$ | $(y - \bar y)^2$ |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 4 | −3 | −4 | 12 | 9 | 16 |
| 4 | 5 | −2 | −3 | 6 | 4 | 9 |
| 6 | 9 | 0 | 1 | 0 | 0 | 1 |
| 8 | 10 | 2 | 2 | 4 | 4 | 4 |
| 9 | 12 | 3 | 4 | 12 | 9 | 16 |
| **Sum** | | 0 | 0 | **34** | **26** | **46** |

(The video says "pos 2" for the first product at one point. $(-3)(-4) = 12$, and the column total of 34 is correct.)

$$\text{cov}(x, y) = \frac{34}{4} = 8.5$$
$$s_x = \sqrt{\frac{26}{4}} = \sqrt{6.5} \approx 2.54951, \qquad s_y = \sqrt{\frac{46}{4}} = \sqrt{11.5} \approx 3.39116$$
$$r = \frac{8.5}{2.54951 \times 3.39116} \approx 0.9831$$

**Mental-math tip:** $34/4 = 32/4 + 2/4 = 8 + 0.5 = 8.5$.

---

## Method 2 - computational formula (check)

| $x$ | $y$ | $xy$ | $x^2$ | $y^2$ |
|---:|---:|---:|---:|---:|
| 3 | 4 | 12 | 9 | 16 |
| 4 | 5 | 20 | 16 | 25 |
| 6 | 9 | 54 | 36 | 81 |
| 8 | 10 | 80 | 64 | 100 |
| 9 | 12 | 108 | 81 | 144 |
| **30** | **40** | **274** | **206** | **366** |

- Numerator: $5(274) - 30(40) = 1370 - 1200 = 170$
- $5(206) - 30^2 = 1030 - 900 = 130$
- $5(366) - 40^2 = 1830 - 1600 = 230$

$$r = \frac{170}{\sqrt{130 \times 230}} = \frac{170}{\sqrt{29{,}900}} \approx 0.9831 \;✓$$

(The product is 29,900; the video says "293,900" at one point.)

Both methods agree: $r \approx 0.983$, a **very strong positive** linear relationship.

---

## Key takeaways

- $r = \dfrac{\text{cov}(x, y)}{s_x s_y}$. Correlation is covariance rescaled to −1 … +1.
- Use $n - 1$ consistently in the covariance and in both standard deviations, or $N$ in all three for a population. The factors cancel either way.
- The computational formula gives the same $r$ without computing deviations.
