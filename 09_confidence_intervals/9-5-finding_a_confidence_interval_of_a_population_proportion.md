# Lesson 9.5 - Finding a Confidence Interval of a Population Proportion

> **Video:** [Finding The Confidence Interval of a Population Proportion Using The Normal Distribution](https://www.youtube.com/watch?v=_aQTgv_OOSU) by The Organic Chemistry Tutor
> **Chapter:** [9 - Confidence Intervals](https://www.video-tutor.net/confidence-intervals.html)

## Formulas

| Quantity | Formula |
|---|---|
| Sample proportion ("p-hat" or "p-prime") | $\hat p = \dfrac{x}{n}$, where $x$ = number of "yes" (successes) |
| Proportion of failures | $\hat q = 1 - \hat p$ |
| Normal approximation is OK if | $n\hat p\hat q \ge 10$ (many texts check $n\hat p \ge 10$ and $n\hat q \ge 10$) |
| Error bound for a proportion (EBP) | $E = z\sqrt{\dfrac{\hat p\hat q}{n}}$ |
| Confidence interval | $\hat p - E < p < \hat p + E$ |
| Sample size needed | $n = \dfrac{z^2\,\hat p\,\hat q}{E^2}$, rounded **up** |
| Critical $z$ | look up the left area $\dfrac{1 + \text{CL}}{2}$ |

Common $z$ values: 90% → 1.645, 95% → 1.96, 98% → 2.33, 99% → 2.575.

---

## Example 1 - laptop ownership

800 students were surveyed and 584 own a laptop.

**(a) Can the normal distribution be used?** This is a binomial situation (yes/no answers).
$$\hat p = \frac{584}{800} = 0.73, \quad \hat q = 0.27, \quad n\hat p\hat q = 800(0.73)(0.27) = 157.68 \ge 10 \;✓$$

**(b) 95% confidence interval and margin of error** ($z = 1.96$, since the left area is 0.975)
$$E = 1.96\sqrt{\frac{0.73 \times 0.27}{800}} = 1.96\sqrt{2.46375 \times 10^{-4}} \approx 0.0308$$
$$0.73 - 0.0308 < p < 0.73 + 0.0308 \;\Rightarrow\; 0.6992 < p < 0.7608$$

We are 95% confident that between about **69.9% and 76.1%** of all students own a laptop.

**(c) Sample size for a 2% margin of error at 90% confidence** ($z = 1.645$)
$$n = \frac{(1.645)^2(0.73)(0.27)}{(0.02)^2} \approx 1333.39 \;\Rightarrow\; n = 1334$$

Derivation: square $E = z\sqrt{\hat p\hat q/n}$ to get $E^2 = z^2\hat p\hat q/n$, then solve for $n$.

---

## Example 2 - car ownership

500 residents were surveyed and 405 own a car.

$$\hat p = \frac{405}{500} = 0.81, \qquad \hat q = 0.19$$

**(a) 99% confidence interval** ($z = 2.575$, since the left area 0.995 lies between $z = 2.57$ and $2.58$)
$$E = 2.575\sqrt{\frac{0.81 \times 0.19}{500}} = 2.575(0.01754) \approx 0.0452$$
$$0.7648 < p < 0.8552$$

**(b) Sample size for a 3% margin of error at 98% confidence** ($z = 2.33$, left area 0.99)
$$n = \frac{(2.33)^2(0.81)(0.19)}{(0.03)^2} \approx 928.34 \;\Rightarrow\; n = 929$$

---

## Example 3 - working backwards from an interval

A 95% confidence interval for the proportion of homeowners in Texas is $(0.62383,\; 0.67217)$.

**(a) Sample proportion.** It is the **midpoint** of the interval:
$$\hat p = \frac{0.62383 + 0.67217}{2} = 0.648$$

**(b) Error bound.** It is **half the width** of the interval:
$$E = \frac{0.67217 - 0.62383}{2} = 0.02417 \quad(= 0.67217 - 0.648)$$

**(c) How many people were surveyed?**
$$n = \frac{(1.96)^2(0.648)(0.352)}{(0.02417)^2} \approx 1499.95 \;\Rightarrow\; n \approx 1500$$

**(d) How many said yes?**
$$x = n\hat p = 1500(0.648) = 972$$

---

## Key takeaways

- $\hat p = x/n$, $\hat q = 1 - \hat p$. Check $n\hat p\hat q \ge 10$ before using the normal approximation.
- CI = $\hat p \pm z\sqrt{\hat p\hat q/n}$.
- Midpoint of a CI = $\hat p$. Half-width = margin of error.
- Sample size: $n = z^2\hat p\hat q/E^2$, always rounded **up**.
