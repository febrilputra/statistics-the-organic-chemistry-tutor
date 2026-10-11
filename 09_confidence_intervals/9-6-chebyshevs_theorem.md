# Lesson 9.6 - Chebyshev's Theorem

> **Video:** [Chebyshev's Theorem](https://www.youtube.com/watch?v=ZXq0ygaZuwg) by The Organic Chemistry Tutor
> **Chapter:** [9 - Confidence Intervals](https://www.video-tutor.net/confidence-intervals.html)

## Statement

For **any** distribution, whatever its shape, the proportion of data within $k$ standard deviations of the mean is **at least**

$$1 - \frac{1}{k^2}, \qquad k > 1$$

- It gives a **minimum**, not an exact value. The true proportion can be higher.
- It works for **all** distributions, not only normal ones.
- In the video the formula is spoken as "1 over 1 minus k squared". The correct form is **$1 - 1/k^2$**.

## Chebyshev vs the empirical rule

| Within | Empirical rule (normal only) | Chebyshev (any distribution, minimum) |
|---|---:|---:|
| $1\sigma$ | 68% | — ($k$ must be $> 1$) |
| $2\sigma$ | 95% | $1 - \tfrac14 = 75\%$ |
| $3\sigma$ | 99.7% | $1 - \tfrac19 \approx 88.9\%$ |
| $4\sigma$ | ≈ 99.99% | $1 - \tfrac1{16} = 93.75\%$ |

## Finding $k$

If an interval is centered on the mean, $\mu \pm k\sigma$, then

$$k = \frac{x - \mu}{\sigma}$$

using the upper end $x$ (the lower end gives the same $k$).

---

## Example - weights in city XYZ

Mean weight $\mu = 170$ lb, $\sigma = 10$ lb, distribution shape unknown.

**(a) Minimum percentage of people weighing between 145 and 195 lb**

Both ends are 25 lb from the mean, so
$$k = \frac{195 - 170}{10} = 2.5$$
$$1 - \frac{1}{2.5^2} = 1 - \frac{1}{6.25} = 0.84$$

**At least 84%** of residents weigh between 145 and 195 lb. The real figure could be 86%, 89%, 95%, ...

**(b) The city has 200,000 residents. What is the minimum number weighing between 140 and 200 lb?**

Both ends are 30 lb from the mean, so
$$k = \frac{200 - 170}{10} = 3, \qquad 1 - \frac19 = \frac89 \approx 0.889$$

$$\frac89 \times 200{,}000 \approx 177{,}778 \text{ people}$$

(The video rounds to 0.889 first and gets 177,800.)

So $P(140 \le X \le 200) \ge 0.889$, and **at least about 177,800** residents weigh between 140 and 200 lb.

---

## Key takeaways

- Chebyshev: at least $1 - 1/k^2$ of any data set lies within $k$ SDs of the mean ($k > 1$).
- Use it when the distribution is **unknown or not normal**. Use the empirical rule only for normal data.
- $k = (x - \mu)/\sigma$ for an interval centered on the mean.
- Answers are **lower bounds**: say "at least".
