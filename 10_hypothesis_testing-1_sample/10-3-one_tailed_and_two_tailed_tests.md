# Lesson 10.3 - One Tailed and Two Tailed Tests

> **Video:** [One Tailed and Two Tailed Tests, Critical Values, & Significance Level](https://www.youtube.com/watch?v=XHPIEp-3yC0) by The Organic Chemistry Tutor
> **Chapter:** [10 - Hypothesis Testing - 1 Sample](https://www.video-tutor.net/hypothesis-testing-with-one-sample.html)

## Vocabulary

| Term | Meaning |
|---|---|
| **Rejection region** | The shaded tail area(s). If the test statistic lands here, reject $H_0$ |
| **Fail-to-reject region** | The unshaded middle. If the statistic lands here, keep $H_0$ |
| **Critical value(s)** | The z (or t) value(s) separating the two regions |
| **Confidence level** $c$ | The area of the fail-to-reject region |
| **Significance level** $\alpha$ | The total area of the rejection region: $\alpha = 1 - c$ |
| **Calculated value** $z_c$ | The **test statistic** computed from the sample (see Lesson 10.4) |

**Decision:** if $z_c$ falls in the rejection region (beyond the critical value), **reject $H_0$**. Otherwise, **fail to reject $H_0$**.

---

## Which test? Read the sign in $H_a$

| $H_a$ | Test | Rejection region | At 95% ($\alpha = 0.05$) |
|---|---|---|---|
| $\mu \ne \mu_0$ | **Two-tailed** | Both tails, $\alpha/2$ each | 0.025 in each tail, critical $z = \pm 1.96$ |
| $\mu < \mu_0$ | **Left-tailed** | Left tail only, area $\alpha$ | 0.05 on the left, critical $z = -1.645$ |
| $\mu > \mu_0$ | **Right-tailed** | Right tail only, area $\alpha$ | 0.05 on the right, critical $z = +1.645$ |

```
 Two-tailed:      ███|                 |███      (α/2 each side)
 Left-tailed:  █████|                           (α on the left)
 Right-tailed:                         |█████   (α on the right)
                    -z       mean       +z
```

The **arrow** in $H_a$ points to the tail: $<$ → left, $>$ → right, $\ne$ → both.

---

## Example - potato-chip bags

A company says its chip bags average **100 g**.

- An employee thinks the mean is **not** 100 g: $H_0: \mu = 100$, $H_a: \mu \ne 100$ → **two-tailed**. At 95% confidence, $\alpha = 0.05$ is split into 0.025 per tail, and 0.95 is in the middle.
- If instead $H_a: \mu < 100$ → **left-tailed**, with all 0.05 in the left tail.
- If instead $H_a: \mu > 100$ → **right-tailed**, with all 0.05 in the right tail.

---

## Key takeaways

- $\alpha = 1 - c$ is the significance level, the size of the rejection region.
- $\ne$ → two tails (split $\alpha$). $<$ → left tail. $>$ → right tail.
- Compare the calculated statistic with the critical value(s) to decide.
