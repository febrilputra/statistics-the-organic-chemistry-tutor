# Lesson 10.6 - P-Value Method for Hypothesis Testing

> **Video:** [P-Value Method For Hypothesis Testing](https://www.youtube.com/watch?v=8Aw45HN5lnA) by The Organic Chemistry Tutor
> **Chapter:** [10 - Hypothesis Testing - 1 Sample](https://www.video-tutor.net/hypothesis-testing-with-one-sample.html)

## Two ways to make the decision

| | Traditional (critical-value) method | **P-value method** |
|---|---|---|
| Compare | calculated $z$ **vs** critical $z$ | **p-value vs $\alpha$** |
| Reject $H_0$ when | $z$ is in the rejection region | $p\text{-value} < \alpha$ |
| Fail to reject when | $z$ is in the fail-to-reject region | $p\text{-value} \ge \alpha$ |

**Significance level:** $\alpha = 1 - \text{confidence level}$.

**p-value** = the area in the tail(s) beyond the calculated test statistic:

| Test | p-value |
|---|---|
| Left-tailed | area to the **left** of $z$ |
| Right-tailed | area to the **right** of $z$ |
| Two-tailed | **2 ×** the area in the tail beyond $|z|$ |

---

## Example 1 - two-tailed (town weights)

Town XYZ's mean weight is claimed to be **168 lb**. A nutritionist thinks it is different. A sample of **36** people has $\bar x = 169.5$ lb and $s = 3.9$ lb.

**(a)**
$$H_0: \mu = 168 \qquad H_a: \mu \ne 168$$

**(b) Test at 95% confidence** ($\alpha = 0.05$), two-tailed, $n \ge 30$ so use $z$:

$$z = \frac{169.5 - 168}{3.9/\sqrt{36}} = \frac{1.5}{0.65} \approx 2.31$$

**Traditional method:** the critical values are $\pm 1.96$ (left area 0.975). $2.31 > 1.96$, so it is in the rejection region → **reject $H_0$**.

**P-value method:**
- The table gives a left area of 0.98956 for $z = 2.31$.
- Right tail: $1 - 0.98956 = 0.01044$.
- Two-tailed p-value: $2 \times 0.01044 = 0.02088$.

$0.02088 < 0.05$ → **reject $H_0$**. At the 5% level there is enough evidence that the mean weight is not 168 lb.

---

## Example 2 - left-tailed (car warranty)

A factory gives a **5-year** warranty on the engine and transmission. An engineer believes failures happen **in less than 5 years**. A sample of **40** cars has $\bar x = 4.8$ years and $s = 0.5$ years.

**(a)**
$$H_0: \mu \ge 5 \qquad H_a: \mu < 5$$

**(b) Is there evidence at the 2% significance level ($\alpha = 0.02$, 98% confidence) to revise the warranty?**

This is left-tailed (shade the left only), and $n = 40 \ge 30$ so use $z$:

$$z = \frac{4.8 - 5}{0.5/\sqrt{40}} = \frac{-0.2}{0.07906} \approx -2.53$$

The p-value is the area to the left of −2.53 = **0.0057**.

$0.0057 < 0.02$ → **reject $H_0$**. There is enough evidence that the mean time to failure is under 5 years, so the warranty should be revised.

---

## Key takeaways

- p-value = the probability, assuming $H_0$ is true, of a result at least as extreme as the one observed.
- **Small p-value (< α) → reject $H_0$.** Large p-value (≥ α) → fail to reject.
- For a two-tailed test, **double** the one-tail area.
- The p-value method and the critical-value method always give the same decision.
