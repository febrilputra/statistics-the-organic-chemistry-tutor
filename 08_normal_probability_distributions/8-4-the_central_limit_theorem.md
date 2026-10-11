# Lesson 8.4 - The Central Limit Theorem

> **Video:** [Central Limit Theorem - Sampling Distribution of Sample Means](https://www.youtube.com/watch?v=4YLtvNeRIrg) by The Organic Chemistry Tutor
> **Chapter:** [8 - Normal Probability Distributions](https://www.video-tutor.net/normal-probability-distributions.html)

## The idea

1. Take many samples of size $n$ from a population.
2. Compute the mean $\bar x$ of each sample.
3. Plot all those sample means in a histogram.

That histogram is the **sampling distribution of the sample means**, and it is **approximately normal**:

| Population shape | Sampling distribution of $\bar x$ |
|---|---|
| Normal | Normal for **any** $n$ |
| Anything else (uniform, exponential, skewed, irregular, ...) | Approximately normal when $n$ is large enough. **$n \ge 30$** is the usual rule of thumb |

*Example:* in a town of 100,000, take repeated samples of 30 people and record each sample's mean age (41.8, 39.6, 40.5, ...). Those means form a bell curve even if individual ages do not.

---

## Symbols

| Symbol | Meaning |
|---|---|
| $\mu$ | Population mean |
| $\sigma$ | Population standard deviation |
| $\bar x$ | Mean of **one** sample |
| $s$ | Standard deviation of **one** sample |
| $\mu_{\bar x}$ | Mean of the **sampling distribution**: $\mu_{\bar x} = \mu$ |
| $\sigma_{\bar x}$ | SD of the sampling distribution, the **standard error**: $\sigma_{\bar x} = \dfrac{\sigma}{\sqrt n}$ |
| $n$ | Sample size |

**Law of large numbers link:** as $n$ grows, $\bar x$ gets closer to $\mu$. For example, mean ages from samples of 10, 50, 100 and 1,000 people might be 32, 38.5, 35.3 and 36.1, approaching the true 36.

---

## Larger $n$ → narrower curve

$$\sigma_{\bar x} = \frac{\sigma}{\sqrt n}$$

$n$ is in the denominator, so **a larger sample gives a smaller standard error**. The sampling distribution becomes **taller and narrower**: $n = 50$ is narrower than $n = 30$, which is narrower than $n = 10$.

---

## z-scores: individuals vs means vs sums

| Question about... | Distribution | z-score |
|---|---|---|
| **One** value $x$ | $X \sim N(\mu, \sigma)$ | $z = \dfrac{x - \mu}{\sigma}$ |
| The **mean** of $n$ values | $\bar X \sim N\!\left(\mu, \dfrac{\sigma}{\sqrt n}\right)$ | $z = \dfrac{\bar x - \mu}{\sigma/\sqrt n}$ |
| The **sum** of $n$ values | $\sum X \sim N\!\left(n\mu, \sqrt n\,\sigma\right)$ | $z = \dfrac{\sum x - n\mu}{\sqrt n\,\sigma}$ |

Then use the z-table (left area); right area = 1 − left area. To go from a percentile back to a value: $\bar x = \mu + z\,\dfrac{\sigma}{\sqrt n}$.

### Reminders from earlier lessons

- **Uniform** $U(a, b)$: $f(x) = \tfrac{1}{b-a}$, $\mu = \tfrac{a+b}{2}$, $\sigma = \tfrac{b-a}{\sqrt{12}}$, probability = base × height.
- **Exponential**: $f(x) = \lambda e^{-\lambda x}$, $\lambda = 1/\mu$, **$\sigma = \mu$**, $P(X < x) = 1 - e^{-\lambda x}$.

---

## Example 1 - entrance exam scores: normal, $\mu = 74$, $\sigma = 6.8$

**(a) One student scores below 65** ($n = 1$, so use the population distribution)
$$z = \frac{65 - 74}{6.8} \approx -1.32 \;\Rightarrow\; P = 0.09342 \approx 9.34\%$$

**(b) The mean of 50 students is above 75**
$$\sigma_{\bar x} = \frac{6.8}{\sqrt{50}} \approx 0.9617, \qquad z = \frac{75 - 74}{0.9617} \approx 1.04$$
$$P(\bar X > 75) = 1 - 0.85083 = 0.14917 \approx 14.9\%$$

**(c) Distribution of the mean of 50 scores**
$$\bar X \sim N(74,\; 0.9617)$$

**(d) 80th percentile of the mean score**
A left area of 0.80 gives $z \approx 0.84$ (table value 0.79955):
$$\bar x = 74 + 0.84(0.9617) \approx 74.81$$

---

## Example 2 - carbs in a snack bar: uniform from 21 g to 29 g, $n = 100$

**(a) One bar**
$$X \sim U(21, 29), \qquad \mu = \frac{21 + 29}{2} = 25, \qquad \sigma = \frac{29 - 21}{\sqrt{12}} \approx 2.3094$$

**(b) Mean of 100 bars.** By the CLT ($n \ge 30$) it is **normal**, even though one bar is uniform:
$$\bar X \sim N\!\left(25,\; \frac{2.3094}{\sqrt{100}}\right) = N(25,\; 0.23094)$$

**(c) One bar has 24-26 g** (uniform, so base × height)
$$P(24 < X < 26) = (26 - 24) \times \frac18 = 0.25$$

**(d) The mean of 100 bars is between 24.9 g and 25.1 g** (normal)
$$z = \frac{\pm 0.1}{0.23094} \approx \pm 0.43 \;\Rightarrow\; P = 0.66640 - 0.33360 = 0.3328$$

**(e) Distribution of the total carbs in 100 bars**
$$\sum X \sim N\big(n\mu,\; \sqrt n\,\sigma\big) = N\big(100 \cdot 25,\; 10 \cdot 2.3094\big) = N(2500,\; 23.094)$$

**(f) The total is more than 2,540 g**
$$z = \frac{2540 - 2500}{23.094} \approx 1.73 \;\Rightarrow\; P = 1 - 0.95818 = 0.04182 \approx 4.2\%$$

---

## Example 3 - car lifetimes: exponential with mean 7 years, $n = 40$ cars

**(a) Rate and SD (one car)**
$$\lambda = \frac17 \text{ per year}, \qquad \sigma = \mu = 7 \text{ years}$$

**(b) Distribution of the mean lifetime of 40 cars** (CLT: normal)
$$\sigma_{\bar x} = \frac{7}{\sqrt{40}} \approx 1.1068, \qquad \bar X \sim N(7,\; 1.1068)$$

**(c) P(sample mean < 6.5 years)**
$$z = \frac{6.5 - 7}{1.1068} \approx -0.45 \;\Rightarrow\; P = 0.32636 \approx 32.6\%$$

**(d) IQR of the sample mean**

- $Q_1$ (left area 0.25): the table gives $z = -0.67 \to 0.2514$ and $z = -0.68 \to 0.2483$, so use $z \approx -0.675$.
  $$Q_1 = 7 - 0.675(1.1068) \approx 6.253$$
- $Q_3$ (left area 0.75): $z \approx +0.675$
  $$Q_3 = 7 + 0.675(1.1068) \approx 7.747$$
- $$\text{IQR} = 7.747 - 6.253 \approx 1.494 \text{ years}$$

---

## Key takeaways

- Sample means are approximately **normal** for $n \ge 30$, whatever the population's shape (exactly normal if the population is normal).
- $\mu_{\bar x} = \mu$ and $\sigma_{\bar x} = \sigma/\sqrt n$, so a bigger $n$ gives a smaller spread.
- Decide whether the question is about **one** value (use $\sigma$ and the population's own shape), a **mean** (use $\sigma/\sqrt n$, normal), or a **sum** (use $n\mu$ and $\sqrt n\,\sigma$, normal).
