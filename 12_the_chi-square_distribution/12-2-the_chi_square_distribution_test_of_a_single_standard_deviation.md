# Lesson 12.2 - The Chi Square Distribution Test of a Single Standard Deviation

> **Video:** [Chi Square Distribution Test of a Single Variance or Standard Deviation](https://www.youtube.com/watch?v=O6a76Dnn104) by The Organic Chemistry Tutor
> **Chapter:** [12 - The Chi-Square Distribution](https://www.video-tutor.net/chi-square-distributions.html)

## Test statistic

To test a claim about a population **variance** $\sigma^2$ (or standard deviation $\sigma$):

$$\chi^2 = \frac{(n - 1)\,s^2}{\sigma_0^2}, \qquad \text{df} = n - 1$$

- $s^2$ = sample variance
- $\sigma_0^2$ = the variance claimed in $H_0$

| $H_a$ | Test | Rejection region |
|---|---|---|
| $\sigma^2 < \sigma_0^2$ | Left-tailed | $\chi^2 <$ critical value, with area $\alpha$ on the left (look up right-tail area $1 - \alpha$) |
| $\sigma^2 > \sigma_0^2$ | Right-tailed | $\chi^2 >$ critical value, with right-tail area $\alpha$ |
| $\sigma^2 \ne \sigma_0^2$ | Two-tailed | both tails, $\alpha/2$ each |

---

## Example - is the spread of exam scores smaller?

The math department's exam scores have $\sigma = 8.6$. A professor thinks it is **less**. A sample of 20 scores has $s = 6.9$. Test at $\alpha = 0.05$.

**Known values:** $\sigma_0^2 = 8.6^2$, $\;s^2 = 6.9^2$, $\;n = 20$, $\;\text{df} = 19$

**Hypotheses:**
$$H_0: \sigma^2 = 8.6^2 \qquad H_a: \sigma^2 < 8.6^2 \quad\text{(left-tailed)}$$

**Critical value:** the left-tail area is 0.05, so the right-tail area is 0.95. With df = 19 the table gives $\chi^2 = 10.117$. Reject $H_0$ only if the calculated $\chi^2$ is **less than 10.117**.

**Test statistic:**
$$\chi^2 = \frac{19 \times 6.9^2}{8.6^2} = \frac{19 \times 47.61}{73.96} \approx 12.23$$

$12.23 > 10.117$, which is in the do-not-reject region. **Fail to reject $H_0$.** At the 5% level the sample does not provide enough evidence that the standard deviation is less than 8.6.

---

## Key takeaways

- Testing a variance or SD: $\chi^2 = (n - 1)s^2/\sigma_0^2$ with df $= n - 1$.
- χ² tables list **right-tail areas**. For a left-tailed test, look up $1 - \alpha$.
- Left-tailed: reject only when $\chi^2$ is **below** the critical value.
