# Lesson 6.2 - Finding the Probability of a Binomial Distribution

> **Video:** [Finding The Probability of a Binomial Distribution Plus Mean & Standard Deviation](https://www.youtube.com/watch?v=3PWKQiLK41M) by The Organic Chemistry Tutor
> **Chapter:** [6 - Discrete Probability Distributions](https://www.video-tutor.net/discrete-probability-distributions.html)

## Formula

$$P(X = x) = {}_nC_x\, p^x\, q^{\,n-x}, \qquad {}_nC_x = \frac{n!}{(n - x)!\,x!}$$

| Symbol | Meaning |
|---|---|
| $n$ | number of trials |
| $x$ | number of successes you want (**exactly** $x$) |
| $p$ | probability of success on one trial |
| $q = 1 - p$ | probability of failure on one trial |

**Mean and standard deviation:** $\mu = np$, $\quad \sigma = \sqrt{npq}$

**Conditions:** a fixed number of trials, each trial is success or failure, the trials are independent, and $p$ is the same on every trial.

---

## Example 1 - rolling a die

A die is rolled **12** times. What is the probability of getting a **4 exactly five times**?

- $n = 12$, $x = 5$, $p = \tfrac16$ (one face out of six), $q = \tfrac56$

**Combination by hand:**
$${}_{12}C_5 = \frac{12!}{7!\,5!} = \frac{12 \cdot 11 \cdot 10 \cdot 9 \cdot 8}{5 \cdot 4 \cdot 3 \cdot 2 \cdot 1} = 11 \cdot 9 \cdot 8 = 792$$

**Probability:**
$$P(X = 5) = 792 \left(\tfrac16\right)^5 \left(\tfrac56\right)^7 \approx 0.0284 = 2.84\%$$

---

## Example 2 - guessing on a multiple-choice test

A test has **20** questions, each with 4 choices (A-D) and one correct answer. A student guesses on every question. What is the probability of **exactly 6** correct?

- $n = 20$, $x = 6$, $p = \tfrac14 = 0.25$, $q = 0.75$

$${}_{20}C_6 = \frac{20!}{14!\,6!} = \frac{20 \cdot 19 \cdot 18 \cdot 17 \cdot 16 \cdot 15}{6!} = 38{,}760$$

$$P(X = 6) = 38{,}760\,(0.25)^6(0.75)^{14} \approx 0.1686 = 16.86\%$$

(With 5 answer choices instead, $p = 0.20$ and $q = 0.80$.)

---

## Example 3 - students taking algebra

25% of students at a school take algebra. **30** students are chosen at random.

- $n = 30$, $p = 0.25$, $q = 0.75$

**(a) P(exactly 7 take algebra)**
$$P(X = 7) = {}_{30}C_7\,(0.25)^7(0.75)^{23} = 2{,}035{,}800\,(0.25)^7(0.75)^{23} \approx 0.1663 = 16.6\%$$

**(b) P(fewer than 5 take algebra)**, so $X < 5$, meaning $X = 0, 1, 2, 3, 4$ (5 is not included):

| $x$ | $P(X = x) = {}_{30}C_x (0.25)^x (0.75)^{30-x}$ |
|---:|---:|
| 0 | 0.000179 |
| 1 | 0.001786 |
| 2 | 0.008631 |
| 3 | 0.026853 |
| 4 | 0.060420 |
| **Sum** | **0.09787** ≈ **9.79%** |

> **Correction:** the video adds only $x = 1$ to $4$ and gets 9.77%. "Fewer than 5" also includes **$x = 0$** (no algebra students at all), which adds 0.00018, so the correct total is about **9.79%**. The difference is tiny here, but leaving out $x = 0$ is a common mistake.

For large $n$, adding many terms gets tedious. A normal approximation, or the complement rule with a calculator's binomial CDF, is faster.

**(c) Mean and standard deviation**
$$\mu = np = 30(0.25) = 7.5$$
$$\sigma = \sqrt{npq} = \sqrt{30(0.25)(0.75)} = \sqrt{5.625} \approx 2.37$$

---

## Key takeaways

- Identify $n$, $x$, $p$ and $q$ first, then substitute into ${}_nC_x p^x q^{n-x}$.
- "Exactly $x$" → one term. "Fewer than / at most / at least" → **add several terms**, and remember $x = 0$ when it applies.
- $\mu = np$ and $\sigma = \sqrt{npq}$.
