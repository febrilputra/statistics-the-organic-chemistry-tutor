# Lesson 9.4 - Student's T-Distribution

> **Video:** [Student's T Distribution - Confidence Intervals & Margin of Error](https://www.youtube.com/watch?v=MUD390jtgQs) by The Organic Chemistry Tutor
> **Chapter:** [9 - Confidence Intervals](https://www.video-tutor.net/confidence-intervals.html)

## When to use t instead of z

| Use the **normal (z)** distribution when... | Use **Student's t** when... |
|---|---|
| the **population** SD $\sigma$ is known | only the **sample** SD $s$ is known |
| $n \ge 30$ | $n < 30$ |

Having only $s$ and a small $n$ are both signs that you need $t$.

## Formulas

$$\bar x \pm t_{\nu,\,\alpha/2}\,\frac{s}{\sqrt n}, \qquad \text{EBM} = t_{\nu,\,\alpha/2}\,\frac{s}{\sqrt n}$$

| Symbol | Meaning |
|---|---|
| $\nu = n - 1$ | **Degrees of freedom** (Greek "nu") |
| $\alpha = 1 - \text{CL}$ | The total area outside the interval, i.e. both tails |
| $\alpha/2 = \dfrac{1 - \text{CL}}{2}$ | The **one-tail** area, used to look up $t$ |

```
  α/2   |          1 − α          |   α/2
 ───────┼─────────────────────────┼───────
       −t                        +t
```

**Reading a t-table:** go to the row for $\nu$ and the column for the one-tail area $\alpha/2$.

---

## Example 1 - student weights, 95% CI

20 students: $\bar x = 165$ lb, $s = 4.5$ lb.

$s$ is a **sample** SD (the school has far more than 20 students) and $n = 20 < 30$, so use $t$.

- $\nu = 20 - 1 = 19$
- $\alpha/2 = (1 - 0.95)/2 = 0.025$
- Table: $t_{19,\,0.025} = 2.093$

**(b) Margin of error**
$$\text{EBM} = 2.093 \times \frac{4.5}{\sqrt{20}} = \frac{9.4185}{4.4721} \approx 2.106$$

**(a) Interval**
$$165 \pm 2.106 \;\Rightarrow\; 162.894 < \mu < 167.106$$

We are 95% confident that the mean weight of all the school's students is between about **162.9 and 167.1 lb**.

---

## Example 2 - chemistry scores, 90% CI

The class has 500 students. 10 scores were sampled: 76, 84, 69, 92, 58, 89, 73, 97, 85, 77.

**(a) Sample mean and SD**

$$\bar x = \frac{800}{10} = 80$$

Distances from 80: 4, 4, 11, 12, 22, 9, 7, 17, 5, 3 (squaring removes the signs).

$$s = \sqrt{\frac{4^2 + 4^2 + 11^2 + 12^2 + 22^2 + 9^2 + 7^2 + 17^2 + 5^2 + 3^2}{10 - 1}} = \sqrt{\frac{1234}{9}} \approx 11.709$$

**(b) Margin of error at 90%**

- $\nu = 10 - 1 = 9$
- $\alpha/2 = (1 - 0.90)/2 = 0.05$
- Table: $t_{9,\,0.05} = 1.8331$

$$\text{EBM} = 1.8331 \times \frac{11.709}{\sqrt{10}} \approx 6.787$$

**(c) 90% confidence interval**
$$80 \pm 6.787 \;\Rightarrow\; 73.213 < \mu < 86.787$$

---

## Key takeaways

- Use $t$ when $\sigma$ is unknown (you only have $s$), especially when $n < 30$.
- Degrees of freedom $\nu = n - 1$. Look up the one-tail area $\alpha/2 = (1 - \text{CL})/2$.
- CI = $\bar x \pm t\,s/\sqrt n$. The $t$ value is larger than $z$ for small samples, which gives a wider and more cautious interval.
