# Lesson 10.7 - Hypothesis Testing - Solving Problems with Proportions

> **Video:** [Hypothesis Testing - Solving Problems With Proportions](https://www.youtube.com/watch?v=76VruarGn2Q) by The Organic Chemistry Tutor
> **Chapter:** [10 - Hypothesis Testing - 1 Sample](https://www.video-tutor.net/hypothesis-testing-with-one-sample.html)

## Formulas

| Quantity | Formula |
|---|---|
| Sample proportion | $\hat p = \dfrac{x}{n}$ |
| Hypothesized proportion (from $H_0$) | $p_0$, with $q_0 = 1 - p_0$ |
| Test statistic | $z = \dfrac{\hat p - p_0}{\sqrt{\dfrac{p_0 q_0}{n}}}$ |

"Percent" in the problem means you are testing a **proportion** $p$, not a mean $\mu$.

---

## Example 1 - two-tailed (cell-phone ownership)

A tech company says **70%** of residents own a cell phone. A marketing manager thinks it is different. In a survey of **200**, **130** said yes.

**(a)**
$$H_0: p = 0.70 \qquad H_a: p \ne 0.70$$

**(b) At 95% confidence, is there enough evidence to reject $H_0$?**

- $\hat p = \dfrac{130}{200} = 0.65$, $\;p_0 = 0.70$, $\;q_0 = 0.30$
- $\ne$, so two-tailed: 0.025 per tail, critical values $\pm 1.96$

$$z = \frac{0.65 - 0.70}{\sqrt{\dfrac{0.70 \times 0.30}{200}}} = \frac{-0.05}{\sqrt{0.00105}} = \frac{-0.05}{0.0324} \approx -1.54$$

$-1.96 < -1.54 < 1.96$, which is in the fail-to-reject region. **Fail to reject $H_0$.** At the 5% level there is not enough evidence that the proportion differs from 70%.

---

## Example 2 - right-tailed (vehicle ownership)

A car company says **60% or less** of residents own a vehicle. A sales manager disagrees. In a survey of **250**, **170** said yes.

**(a)**
$$H_0: p \le 0.60 \qquad H_a: p > 0.60$$

**(b) At the 10% significance level, is there enough evidence?**

- $\hat p = \dfrac{170}{250} = 0.68$, $\;p_0 = 0.60$, $\;q_0 = 0.40$
- $>$, so this is a **right-tailed** test with **all** of $\alpha = 0.10$ in the right tail.
- Critical value: the left area is $1 - 0.10 = 0.90$, which gives **$z = 1.28$**.

$$z = \frac{0.68 - 0.60}{\sqrt{\dfrac{0.60 \times 0.40}{250}}} = \frac{0.08}{\sqrt{0.00096}} = \frac{0.08}{0.03098} \approx 2.58$$

$2.58 > 1.28$, which is in the rejection region. **Reject $H_0$.** At the 10% level there is enough evidence that more than 60% of residents own a vehicle.

> **Correction to the video:** the video splits $\alpha = 0.10$ into 5% in each tail and uses a critical value of 1.645. That split is only for **two-tailed** tests. For this **right-tailed** test the whole 10% is in one tail, so the critical value is **1.28**. Here the conclusion is the same, because 2.58 exceeds both.

---

## Key takeaways

- Proportion test: $z = (\hat p - p_0)/\sqrt{p_0q_0/n}$, using the **null** value $p_0$ in the standard error.
- Two-tailed: split $\alpha$ between the tails. One-tailed: put all of $\alpha$ in one tail.
- Critical z values: two-tailed 10% → ±1.645, 5% → ±1.96. One-tailed 10% → 1.28, 5% → 1.645.
