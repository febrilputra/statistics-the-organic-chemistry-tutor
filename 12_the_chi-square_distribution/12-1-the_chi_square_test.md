# Lesson 12.1 - The Chi Square Test

> **Video:** [Chi Square Test](https://www.youtube.com/watch?v=HKDqlYSLt68) by The Organic Chemistry Tutor
> **Chapter:** [12 - The Chi-Square Distribution](https://www.video-tutor.net/chi-square-distributions.html)

## The goodness-of-fit test

Does the **observed** distribution of counts across categories match an **expected** distribution?

$$\chi^2 = \sum \frac{(O - E)^2}{E}$$

- $O$ = observed count, $E$ = expected count, for each category
- **Degrees of freedom** = $k - 1$, where $k$ = number of categories
- It is always a **right-tailed** test: a large $\chi^2$ means the observed counts are far from the expected ones

**The chi-square distribution** is **not symmetric**; it is skewed to the right. The critical value $\chi^2_\alpha$ cuts off area $\alpha$ in the right tail:

- calculated $\chi^2$ > critical value → **rejection region** → reject $H_0$
- calculated $\chi^2$ ≤ critical value → **do-not-reject region**

---

## Example - which weekday has the most absences?

A principal expects absences to be spread **equally** over the 5-day school week. 100 teachers were asked which day had the most absences. Test at $\alpha = 0.05$.

| Day | Mon | Tue | Wed | Thu | Fri | Total |
|---|---:|---:|---:|---:|---:|---:|
| Observed $O$ | 23 | 16 | 14 | 19 | 28 | 100 |
| Expected $E$ | 20 | 20 | 20 | 20 | 20 | 100 |

**Hypotheses:**

- $H_0$: absences happen with **equal frequencies** (a uniform distribution)
- $H_a$: absences do **not** happen with equal frequencies

**Critical value:** df $= 5 - 1 = 4$. In the χ² table with right-tail area 0.05: $\chi^2_{0.05,\,4} = 9.49$.

**Test statistic:**

| Day | $O - E$ | $(O - E)^2$ | $(O - E)^2 / E$ |
|---|---:|---:|---:|
| Mon | 3 | 9 | 0.45 |
| Tue | −4 | 16 | 0.80 |
| Wed | −6 | 36 | 1.80 |
| Thu | −1 | 1 | 0.05 |
| Fri | 8 | 64 | 3.20 |
| **Sum** | | **126** | **6.30** |

$$\chi^2 = \frac{126}{20} = 6.3$$

$6.3 < 9.49$, which is in the do-not-reject region. **Fail to reject $H_0$.** The variation between days is not large enough to say that absences are unevenly spread across the week.

---

## Key takeaways

- $\chi^2 = \sum (O - E)^2/E$ measures how far the observed counts are from the expected ones.
- Goodness of fit: df = number of categories − 1. It is always right-tailed.
- Large $\chi^2$ (beyond the critical value) → reject $H_0$ (the data don't fit the expected distribution).
