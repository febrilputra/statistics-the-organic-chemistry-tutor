# Lesson 8.1 - Standard Normal Distributions

> **Video:** [Standard Normal Distribution Tables, Z Scores, Probability & Empirical Rule](https://www.youtube.com/watch?v=CjF_yQ2N638) by The Organic Chemistry Tutor
> **Chapter:** [8 - Normal Probability Distributions](https://www.video-tutor.net/normal-probability-distributions.html)

## The normal distribution

- A **bell-shaped**, symmetric curve, written $X \sim N(\mu, \sigma)$: the first number is the **mean**, the second the **standard deviation**.
- The mean sits at the center. Each standard deviation away from it is one unit of **z-score**.

```
 z:   -3     -2     -1      0      1      2      3
 x: μ-3σ   μ-2σ   μ-σ      μ     μ+σ   μ+2σ   μ+3σ
```

## Key formulas

| Purpose | Formula |
|---|---|
| z-score of a value $x$ | $z = \dfrac{x - \mu}{\sigma}$ |
| Value $x$ from a z-score | $x = \mu + z\sigma$ |
| PDF (for reference) | $f(x) = \dfrac{1}{\sigma\sqrt{2\pi}}\, e^{-\frac12\left(\frac{x-\mu}{\sigma}\right)^2}$ |

You don't need the PDF to find probabilities in an intro course. Use z-tables (or calculus, see Lesson 8.2).

- **Positive $z$** → the value is **above** the mean. **Negative $z$** → **below** the mean.

---

## The empirical rule (68-95-99.7)

| Within | Percent of the data |
|---|---:|
| $\mu \pm 1\sigma$ | 68% |
| $\mu \pm 2\sigma$ | 95% |
| $\mu \pm 3\sigma$ | 99.7% |

Split into the 8 regions of the bell curve:

```
 0.15% | 2.35% | 13.5% |  34%  |  34%  | 13.5% | 2.35% | 0.15%
     -3σ     -2σ     -1σ       μ      +1σ     +2σ     +3σ
```

- $68/2 = 34\%$
- $(95 - 68)/2 = 13.5\%$
- $(99.7 - 95)/2 = 2.35\%$
- $(100 - 99.7)/2 = 0.15\%$

The total area under the curve is 1 (100%).

---

## Example 1 - $X \sim N(50, 10)$

**(a)** $\mu = 50$, $\sigma = 10$.

**(b) Which $x$ has $z = 1.4$?**
$$x = 50 + 1.4(10) = 64$$

**(c) What is the z-score of $x = 30$?**
$$z = \frac{30 - 50}{10} = -2$$

**(d)** Negative z-scores (like −2 for 30) are left of the mean. Positive ones (like 1.4 for 64) are right of it.

---

## Example 2 - empirical rule: test scores, $\mu = 74$, $\sigma = 8$, 2,000 students

Mark the axis: 50, 58, 66, **74**, 82, 90, 98 (from $-3\sigma$ to $+3\sigma$).

| Question | Regions | Answer |
|---|---|---|
| (a) % below 58 ($< \mu - 2\sigma$) | 0.15 + 2.35 | **2.5%** |
| (b) P(66 < X < 82) ($\mu \pm 1\sigma$) | 34 + 34 | **68%** |
| (c) **How many** scored at most 90? | everything below $+2\sigma$ = 100 − (2.35 + 0.15) = 97.5% | $0.975 \times 2000 = $ **1,950 students** |
| (d) % at least 66 | 34 + 34 + 13.5 + 2.35 + 0.15 | **84%** |
| (e) **How many** scored more than 98? | 0.15% | $0.0015 \times 2000 = $ **3 students** |

---

## Using z-tables

When $z$ is not a whole number, such as $z = 1.56$, the empirical rule can't be used. Use a **standard normal (z) table** instead.

**A z-table gives the area to the LEFT of $z$.**

- Find the row for the first decimal (**1.5**) and the column for the second decimal (**0.06**): area = **0.94062**.
- For $z = -0.43$: row **−0.4**, column **0.03**, area = **0.33360** (33.36%).

| To find | Use |
|---|---|
| $P(X < x)$ | the table value directly |
| $P(X > x)$ | $1 - \text{table value}$ |
| $P(a < X < b)$ | table($z_b$) − table($z_a$) |

---

## Example 3 - IQ scores, $\mu = 100$, $\sigma = 15$

**(a) P(IQ < 80)**
$$z = \frac{80 - 100}{15} = -1.33 \;\Rightarrow\; \text{area} = 0.09176 \approx 9.18\%$$

**(b) P(IQ > 136)**
$$z = \frac{136 - 100}{15} = 2.40 \;\Rightarrow\; \text{left area} = 0.99180$$
$$P(X > 136) = 1 - 0.99180 = 0.0082 = 0.82\%$$
(The video says "eight point two" at one point; the correct value is 0.0082, which is **0.82%**.)

**(c) P(95 < IQ < 110)**
$$z_{110} = \frac{10}{15} \approx 0.67 \to 0.74857, \qquad z_{95} = \frac{-5}{15} \approx -0.33 \to 0.37070$$
$$P = 0.74857 - 0.37070 = 0.37787 \approx 37.8\%$$

**(d) IQ at the 90th percentile** (work backwards from the area)

The left area is 0.90. In the table, $z = 1.28$ gives 0.89973 and $z = 1.29$ gives 0.90147. 0.89973 is closer to 0.90, so take $z = 1.28$.
$$x = 100 + 1.28(15) = 119.2$$

**(e) Between which two IQs are the middle 30%?**

The middle 30% leaves 15% on each side of the mean, so it runs from the **35th** to the **65th** percentile.

- For an area of 0.65: $z = 0.38$ gives 0.64803 and $z = 0.39$ gives 0.65173. 0.65 is about halfway, so $z \approx 0.385$.
- By symmetry, the 35th percentile is $z \approx -0.385$.

$$x_2 = 100 + 0.385(15) \approx 105.8, \qquad x_1 = 100 - 0.385(15) \approx 94.2$$

The middle 30% of IQs lie between about **94.2 and 105.8**.

---

## Example 4 - normal approximation to a binomial (defective tires)

2% of tires are defective, and a sample of $n = 500$ is checked. So $p = 0.02$, $q = 0.98$.

**(a) Mean and standard deviation**
$$\mu = np = 500(0.02) = 10, \qquad \sigma = \sqrt{npq} = \sqrt{500(0.02)(0.98)} = \sqrt{9.8} \approx 3.13$$

**(b) P(fewer than 8 defective)**
$$z = \frac{8 - 10}{3.13} \approx -0.64 \;\Rightarrow\; P \approx 0.2611 = 26.1\%$$

**(c) P(more than 15 defective)**
$$z = \frac{15 - 10}{3.13} \approx 1.60 \;\Rightarrow\; \text{left} = 0.9452,\; P = 1 - 0.9452 = 0.0548 = 5.48\%$$

**(d) P(between 7 and 14 defective)**
$$z_{14} = \frac{4}{3.13} \approx 1.28 \to 0.89973, \qquad z_7 = \frac{-3}{3.13} \approx -0.96 \to 0.16853$$
$$P = 0.89973 - 0.16853 = 0.7312 = 73.1\%$$

> **Note:** the video uses the normal curve directly on the counts. Many textbooks add a **continuity correction** of ±0.5 (e.g. "fewer than 8" → $x < 7.5$) when approximating a discrete binomial with the continuous normal, which gives slightly different, more accurate answers.

---

## Key takeaways

- $z = (x - \mu)/\sigma$ and $x = \mu + z\sigma$.
- Empirical rule: 68 / 95 / 99.7, which splits into 34 / 13.5 / 2.35 / 0.15 per region.
- A z-table gives the **left** area. Right area = 1 − left. Between = difference of two left areas.
- For percentiles, look up the **area** in the table to find $z$, then convert to $x$.
