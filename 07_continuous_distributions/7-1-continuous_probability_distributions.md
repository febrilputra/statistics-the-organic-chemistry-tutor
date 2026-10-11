# Lesson 7.1 - Continuous Probability Distributions

> **Video:** [Continuous Probability Distributions - Basic Introduction](https://www.youtube.com/watch?v=QxqxdQ_g2uw) by The Organic Chemistry Tutor
> **Chapter:** [7 - Continuous Distributions](https://www.video-tutor.net/continuous-probability-distributions.html)

## Continuous random variables

A **continuous** random variable $X$ can take **any** value in a range, such as 2, 3.5 or 4.68. A **discrete** one is restricted to specific values, such as 1, 2, 3, ...

The curve of a continuous distribution is its **probability density function (PDF)**, $f(x)$. Its height above the x-axis at $x$ is $f(x)$.

## The key rules

1. **$f(x) \ge 0$** everywhere: the curve never dips below the x-axis.
2. **Total area under the curve = 1.**
3. **Probability = area under the curve** over the interval you want:
   - $P(X < a)$ = area to the **left** of $a$
   - $P(b < X < c)$ = area **between** $b$ and $c$
   - $P(X > d)$ = area to the **right** of $d$
4. **A single value has zero probability:** $P(X = b) = 0$. A vertical line has height but no width, so its area is 0.
5. Therefore $<$ and $\le$ give the **same** probability:
   $$P(X < a) = P(X \le a), \qquad P(b < X < c) = P(b \le X \le c)$$

The **normal distribution** (bell curve) is the most important example. It is covered in Chapter 8.

---

## Uniform distribution

$f(x)$ is **constant** between $a$ and $b$, so the graph is a rectangle with area 1.

**Example:** a uniform distribution from $a = 2$ to $b = 6$ has base $= 4$, so the height must be $\tfrac14$ for the area to equal $4 \times \tfrac14 = 1$.

| PDF | Mean | Standard deviation |
|---|---|---|
| $f(x) = \dfrac{1}{b - a}$ for $a \le x \le b$ | $\mu = \dfrac{a + b}{2}$ | $\sigma = \dfrac{b - a}{\sqrt{12}}$ |

---

## Exponential distribution

The curve starts at height $\lambda$ on the y-axis and **decays** as $x$ increases.

| PDF | Rate | Left area | Right area |
|---|---|---|---|
| $f(x) = \lambda e^{-\lambda x}$ | $\lambda = \dfrac1\mu$ | $P(X < x) = 1 - e^{-\lambda x}$ | $P(X > x) = e^{-\lambda x}$ |

---

## Key takeaways

- Continuous distributions are described by a PDF $f(x) \ge 0$ with a total area of 1.
- **Probability = area under the curve.**
- $P(X = \text{one exact value}) = 0$, so "$<$" and "$\le$" are interchangeable.
- Uniform: a flat rectangle at height $1/(b-a)$. Exponential: a decaying curve with $\lambda = 1/\mu$.
