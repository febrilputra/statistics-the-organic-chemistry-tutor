# Lesson 9.3 - How to Calculate the Sample Size

> **Video:** [How To Calculate The Sample Size Given The Confidence Level & Margin of Error](https://www.youtube.com/watch?v=nkkxu09K3ZA) by The Organic Chemistry Tutor
> **Chapter:** [9 - Confidence Intervals](https://www.video-tutor.net/confidence-intervals.html)

## Formulas

**For a mean.** Start from the margin of error:

$$E = z\,\frac{\sigma}{\sqrt n} \;\xrightarrow{\text{square both sides}}\; E^2 = \frac{z^2\sigma^2}{n} \;\Rightarrow\; \boxed{n = \frac{z^2\sigma^2}{E^2}}$$

**For a proportion:**

$$\boxed{n = \frac{z^2\,\hat p\,(1 - \hat p)}{E^2}}$$

If $\hat p$ is unknown, use **$\hat p = 0.5$**. That makes $\hat p(1 - \hat p)$ as large as possible, so the resulting $n$ is big enough whatever the true proportion is.

Always **round $n$ up** to the next whole number.

---

## Example 1 - working backwards to the class size

The mean test score was 84 with standard deviation $\sigma = 15$. The margin of error at 95% confidence was $E = 5.367$. How many students were sampled?

$$n = \frac{(1.96)^2(15)^2}{(5.367)^2} \approx 30.0 \;\Rightarrow\; n = 30 \text{ students}$$

(The mean, 84, isn't needed.)

---

## Example 2 - planning a survey on a proportion

Sally wants to estimate the proportion of high-school students planning to go to college, with **95%** confidence and a **5%** margin of error ($E = 0.05$). She has no prior estimate of $\hat p$.

**Which $\hat p$ makes $\hat p(1 - \hat p)$ largest?**

| $\hat p$ | $1 - \hat p$ | Product |
|---:|---:|---:|
| 1.0 | 0.0 | 0.00 |
| 0.7 | 0.3 | 0.21 |
| 0.6 | 0.4 | 0.24 |
| **0.5** | **0.5** | **0.25** (largest) |

$$n = \frac{(1.96)^2(0.5)(0.5)}{(0.05)^2} = \frac{0.9604}{0.0025} = 384.16 \;\Rightarrow\; n = 385$$

Round **up**: 384 students would not quite reach the 5% margin.

---

## Key takeaways

- Mean: $n = z^2\sigma^2/E^2$. Proportion: $n = z^2\hat p(1-\hat p)/E^2$.
- With no estimate of $\hat p$, use 0.5. This gives the largest, safest $n$.
- Always round **up**.
- A smaller margin of error or a higher confidence level requires a larger sample.
