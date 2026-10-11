# Lesson 10.4 - Test Statistic for Means and Population Proportions

> **Video:** [Test Statistic For Means and Population Proportions](https://www.youtube.com/watch?v=Hag0GW9B6EY) by The Organic Chemistry Tutor
> **Chapter:** [10 - Hypothesis Testing - 1 Sample](https://www.video-tutor.net/hypothesis-testing-with-one-sample.html)

## The decision rule

1. Find the **critical value(s)** from the significance level and the type of test. For a two-tailed test at 95%, $\pm 1.96$.
2. Compute the **test statistic** $z_c$ (or $t$) from the sample.
3. Statistic in the rejection region → **reject $H_0$**. Statistic in the fail-to-reject region → **fail to reject $H_0$**.

*Example:* $H_0: \mu = 50$ vs $H_a: \mu \ne 50$ at 95% has critical values $\pm 1.96$. A calculated $z_c$ beyond 1.96 (or below −1.96) means reject.

---

## Test statistic for a mean

| Sample size | $\sigma$ known? | Distribution | Test statistic |
|---|---|---|---|
| $n < 30$ | **No** (only $s$) | **t**, df $= n - 1$ | $t = \dfrac{\bar x - \mu}{s/\sqrt n}$ |
| $n < 30$ | Yes | z | $z = \dfrac{\bar x - \mu}{\sigma/\sqrt n}$ |
| $n \ge 30$ | No (use $s$) | z (approximately normal) | $z = \dfrac{\bar x - \mu}{s/\sqrt n}$ |
| $n \ge 30$ | Yes | z | $z = \dfrac{\bar x - \mu}{\sigma/\sqrt n}$ |

Here $\mu$ is the value claimed in $H_0$.

> Many textbooks use the t-distribution **whenever $\sigma$ is unknown**, whatever the sample size. For $n \ge 30$, $t$ and $z$ give nearly the same answer, so the video's rule is a common shortcut.

---

## Test statistic for a proportion

$$z = \frac{\hat p - p}{\sqrt{\dfrac{pq}{n}}}, \qquad q = 1 - p$$

- $\hat p$ = sample proportion ($x/n$)
- $p$ = the proportion claimed in $H_0$ (sometimes written $p_0$). Use this hypothesized value under the square root, not $\hat p$.

---

## Key takeaways

- Test statistic = (sample value − hypothesized value) ÷ standard error.
- Mean: use $t$ with $s$ when $n < 30$ and $\sigma$ is unknown. Otherwise use $z$.
- Proportion: $z = (\hat p - p)/\sqrt{pq/n}$, with $p$ from $H_0$.
- Compare with the critical value(s) to reject or fail to reject $H_0$.
