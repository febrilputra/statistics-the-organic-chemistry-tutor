# Lesson 8.5 - The Standard Error of the Mean

> **Video:** [Standard Error of the Mean](https://www.youtube.com/watch?v=UuHqq09nTAk) by The Organic Chemistry Tutor
> **Chapter:** [8 - Normal Probability Distributions](https://www.video-tutor.net/normal-probability-distributions.html)

## Formula

The **standard error of the mean (SE)** is the standard deviation of the sampling distribution of $\bar x$. It measures how much sample means vary from sample to sample.

| You know | Standard error |
|---|---|
| The **sample** SD $s$ | $\text{SE} = \dfrac{s}{\sqrt n}$ |
| The **population** SD $\sigma$ | $\sigma_{\bar x} = \dfrac{\sigma}{\sqrt n}$ |

---

## Example 1 - from sample data

The ages of 5 randomly selected college students are 18, 21, 19, 20, 26.

**(a) Sample standard deviation**

Mean: $\bar x = \dfrac{104}{5} = 20.8$

| $x$ | $x - 20.8$ | squared |
|---:|---:|---:|
| 18 | −2.8 | 7.84 |
| 21 | 0.2 | 0.04 |
| 19 | −1.8 | 3.24 |
| 20 | −0.8 | 0.64 |
| 26 | 5.2 | 27.04 |
| **Sum** | | **38.80** |

$$s = \sqrt{\frac{38.8}{5 - 1}} = \sqrt{9.7} \approx 3.114$$

**(b) Standard error**
$$\text{SE} = \frac{3.114}{\sqrt5} \approx 1.393$$

---

## Example 2 - from the population SD

At a university, student ages have mean 20.5 and **population** SD $\sigma = 0.8$.

**(a) Samples of $n = 25$**
$$\sigma_{\bar x} = \frac{0.8}{\sqrt{25}} = \frac{0.8}{5} = 0.16$$

**(b) Samples of $n = 100$**
$$\sigma_{\bar x} = \frac{0.8}{\sqrt{100}} = \frac{0.8}{10} = 0.08$$

**Quadrupling $n$ halves the standard error**, because $\sqrt 4 = 2$.

---

## What it looks like

Plot the means of many samples to get the **sampling distribution of the mean**, a bell curve centered at $\mu$.

- With $n = 25$ it is wider and shorter.
- With $n = 50$ (or 100) it is **narrower and taller**.

A smaller SE means the sample means cluster more tightly around $\mu$, so any one sample mean is a **more accurate** estimate.

---

## Key takeaways

- SE = SD ÷ $\sqrt n$. Use $s$ from a sample or $\sigma$ from the population.
- The SD describes spread among **individual values**. The SE describes spread among **sample means**.
- SE ∝ $1/\sqrt n$: a larger sample gives a smaller SE and a more precise estimate.
