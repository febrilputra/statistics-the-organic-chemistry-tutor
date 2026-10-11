# Lesson 11.1 - Hypothesis Testing - Difference of Two Means

> **Video:** [Hypothesis Testing - Difference of Two Means - Student's t-Distribution & Normal Distribution](https://www.youtube.com/watch?v=UcZwyzwWU7o) by The Organic Chemistry Tutor
> **Chapter:** [11 - Hypothesis Testing - 2 Samples](https://www.video-tutor.net/hypothesis-testing-with-two-samples.html)

## Setup

Two **independent** groups. Does their population mean differ?

$$H_0: \mu_1 = \mu_2 \;\;(\mu_1 - \mu_2 = 0) \qquad H_a: \mu_1 \ne \mu_2 \;\;(\mu_1 - \mu_2 \ne 0)$$

## Test statistic

$$t \text{ (or } z) = \frac{(\bar x_1 - \bar x_2) - (\mu_1 - \mu_2)}{\sqrt{\dfrac{s_1^2}{n_1} + \dfrac{s_2^2}{n_2}}}$$

Under $H_0$, $\mu_1 - \mu_2 = 0$. The denominator is the **standard error of the difference**.

| Sample sizes | Use |
|---|---|
| Small ($< 30$) | **t-distribution** (Welch), with the degrees of freedom below |
| Large ($\ge 30$) | **z** (normal distribution) |

**Degrees of freedom (Welch-Satterthwaite):**

$$\text{df} = \frac{\left(\dfrac{s_1^2}{n_1} + \dfrac{s_2^2}{n_2}\right)^2}{\dfrac{\left(s_1^2/n_1\right)^2}{n_1 - 1} + \dfrac{\left(s_2^2/n_2\right)^2}{n_2 - 1}}$$

---

## Example 1 - two teachers (t-test)

Do two teachers' classes score differently? $\alpha = 0.05$.

| | Class 1 | Class 2 |
|---|---:|---:|
| $n$ | 15 | 12 |
| $\bar x$ | 82 | 84 |
| $s$ | 2.4 | 1.7 |

**Hypotheses:** $H_0: \mu_1 - \mu_2 = 0$, $\;H_a: \mu_1 - \mu_2 \ne 0$ (two-tailed, $\alpha/2 = 0.025$).

**Both samples are small → t-test.**

**Degrees of freedom:**

- $s_1^2/n_1 = 5.76/15 = 0.384$ and $s_2^2/n_2 = 2.89/12 = 0.24083$
- Numerator: $(0.384 + 0.24083)^2 = (0.62483)^2 = 0.390417$
- Denominator: $\dfrac{0.384^2}{14} + \dfrac{0.24083^2}{11} = 0.010533 + 0.005273 = 0.015805$
- $\text{df} = 0.390417 / 0.015805 \approx 24.7$

The video rounds this to **25**, giving $t_{0.025,\,25} = 2.0595$. Many textbooks round df **down** to be conservative ($24 \to t = 2.064$). Both give the same decision here.

**Test statistic:**
$$t = \frac{82 - 84 - 0}{\sqrt{0.384 + 0.24083}} = \frac{-2}{0.79046} \approx -2.53$$

$-2.53 < -2.0595$, which is in the rejection region. **Reject $H_0$.** At the 5% level there is a significant difference between the two teachers' class means.

---

## Example 2 - two oil refineries (z-test)

Is there a difference in refining rate (liters per second)? $\alpha = 0.10$.

| | Old factory | New factory |
|---|---:|---:|
| $n$ | 40 | 36 |
| $\bar x$ | 3.1 | 3.8 |
| $s$ | 1.0 | 1.5 |

**Hypotheses:** $H_0: \mu_1 = \mu_2$, $\;H_a: \mu_1 \ne \mu_2$ (two-tailed).

**Both samples are large → z-test.** The confidence level is 90%, so the left area for the critical value is 0.95: $z = \pm 1.645$.

$$z = \frac{3.1 - 3.8}{\sqrt{\dfrac{1^2}{40} + \dfrac{1.5^2}{36}}} = \frac{-0.7}{\sqrt{0.025 + 0.0625}} = \frac{-0.7}{0.2958} \approx -2.37$$

$-2.37 < -1.645$ → **reject $H_0$**. At the 10% level there is a significant difference between the factories; the new one refines faster.

---

## Key takeaways

- $H_0$: equal means (difference 0). Test statistic = (difference in sample means) ÷ $\sqrt{s_1^2/n_1 + s_2^2/n_2}$.
- Small samples → t with Welch's df. Large samples → z.
- Compare with the critical value(s), or with the p-value, as in the one-sample case.
