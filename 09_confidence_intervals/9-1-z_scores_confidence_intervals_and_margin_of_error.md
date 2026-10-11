# Lesson 9.1 - Z-Scores, Confidence Intervals, and Margin of Error

> **Video:** [How To Find The Z Score, Confidence Interval, and Margin of Error for a Population Mean](https://www.youtube.com/watch?v=DT-fPG0Hff8) by The Organic Chemistry Tutor
> **Chapter:** [9 - Confidence Intervals](https://www.video-tutor.net/confidence-intervals.html)

## Confidence interval for $\mu$ (when $\sigma$ is known)

$$\bar x - z\,\frac{\sigma}{\sqrt n} \;<\; \mu \;<\; \bar x + z\,\frac{\sigma}{\sqrt n} \qquad\text{or}\qquad \bar x \pm \text{EBM}$$

**Margin of error**, also called the **error bound for the mean (EBM)**:

$$\text{EBM} = z\,\frac{\sigma}{\sqrt n}$$

## Finding the critical z-value

The area to the **left** of the positive critical value $z$ is

$$\text{left area} = \frac{\text{CL} + 1}{2}$$

where CL is the confidence level as a decimal. Look this area up in a z-table that gives **left** areas.

| Confidence level | Left area | $z$ |
|---:|---:|---:|
| 90% | 0.95 | 1.645 |
| 95% | 0.975 | 1.96 |

For 90%, the table has 0.94950 at $z = 1.64$ and 0.95053 at $z = 1.65$. 0.95 is about halfway between them, so average: $z = 1.645$.

---

## Example 1 - physics test, 95% CI

$\sigma = 5.4$, $n = 50$, $\bar x = 79$

1. $z$: left area $= (0.95 + 1)/2 = 0.975$ → $z = 1.96$
2. Standard error: $\dfrac{5.4}{\sqrt{50}} \approx 0.76368$
3. **(b) Margin of error:** $\text{EBM} = 1.96 \times 0.76368 \approx 1.4968$
4. **(a) Interval:** $79 \pm 1.4968$

$$77.5032 < \mu < 80.4968$$

We are 95% confident that the mean score of the whole class lies between about **77.50 and 80.50**.

## Example 2 - chemistry test, 90% CI

$\sigma = 6.5$, $n = 100$, $\bar x = 82$

1. $z$: left area $= (0.90 + 1)/2 = 0.95$ → $z = 1.645$
2. **(b) Margin of error:** $\text{EBM} = 1.645 \times \dfrac{6.5}{\sqrt{100}} = 1.645 \times 0.65 = 1.06925$
3. **(a) Interval:** $82 \pm 1.06925$

$$80.93075 < \mu < 83.06925$$

---

## Confidence interval vs confidence level

| Term | Meaning | Example |
|---|---|---|
| **Confidence interval (CI)** | The **range of values** $(\bar x - \text{EBM},\; \bar x + \text{EBM})$ | 80.93 to 83.07 |
| **Confidence level (CL)** | The **area under the curve** between $-z$ and $+z$ | 0.90 |
| $\alpha$ | The area **outside** the interval: $\alpha = 1 - \text{CL}$, split as $\alpha/2$ in each tail | 0.10 → 0.05 per tail |

```
  α/2 = 5%  |        CL = 90%         |  α/2 = 5%
 ───────────┼─────────────────────────┼───────────
          -z             x̄           +z
       x̄ − EBM                     x̄ + EBM
```

### Interpreting "95% confidence"

If we took many samples and built a 95% interval from each one, about **95% of those intervals would contain the true mean $\mu$**, and about 5% would miss it. The video phrases this in terms of sample means landing in the interval; this is the more precise statement.

---

## What changes the margin of error?

$$\text{EBM} = z\,\frac{\sigma}{\sqrt n}$$

| Change | Effect on EBM | Why |
|---|---|---|
| **Higher** confidence level (90% → 95%) | **Larger** | $z$ grows, so the interval gets wider |
| **Larger** sample size $n$ | **Smaller** | $\sqrt n$ is in the denominator |

To get a smaller margin of error, **lower the confidence level** or **increase the sample size**.

The EBM is half the width of the confidence interval.

---

## Key takeaways

- CI = $\bar x \pm z\,\sigma/\sqrt n$, and EBM = $z\,\sigma/\sqrt n$.
- Critical $z$: look up the left area $(\text{CL} + 1)/2$. 90% → 1.645, 95% → 1.96.
- Higher confidence gives a wider interval. A bigger sample gives a narrower one.
