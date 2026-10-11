# Lesson 7.3 - Probability of a Uniform Distribution

> **Video:** [Continuous Probability Uniform Distribution Problems](https://www.youtube.com/watch?v=KfunVw-0AH0) by The Organic Chemistry Tutor
> **Chapter:** [7 - Continuous Distributions](https://www.video-tutor.net/continuous-probability-distributions.html)

## Formulas (uniform on $[a, b]$)

The graph is a **rectangle** with total area 1:

$$\text{area} = \text{base} \times \text{height} = (b - a)\,f(x) = 1 \;\Rightarrow\; f(x) = \frac{1}{b - a}, \quad a \le x \le b$$

| Quantity | Formula |
|---|---|
| Probability of an interval | **base × height** $= \dfrac{\text{interval width}}{b - a}$ |
| Mean = median | $\dfrac{a + b}{2}$ |
| Variance | $\dfrac{(b - a)^2}{12}$ |
| Standard deviation | $\dfrac{b - a}{\sqrt{12}}$ |
| $k$-th percentile value $K$ | $\dfrac{k}{100} = \dfrac{K - a}{b - a} \;\Rightarrow\; K = a + \dfrac{k}{100}(b - a)$ |

**Special cases:**

- $P(X = c) = 0$ for any single value (a line has no width).
- $P(X > b) = P(X < a) = 0$ (the height is zero outside $[a, b]$).

---

## Example 1 - waiting for a train (0 to 40 minutes)

The wait time is uniformly distributed on $[0, 40]$.

**(a) PDF**
$$f(x) = \frac{1}{40 - 0} = \frac{1}{40}, \qquad 0 \le x \le 40$$

**(b) Graph:** a flat line at height $\tfrac{1}{40}$ from $x = 0$ to $x = 40$, which forms a rectangle.

**(c) Wait less than 8 minutes**
$$P(X < 8) = 8 \times \frac{1}{40} = \frac{8}{40} = \frac15 = 0.20 = 20\%$$

**(d) Wait more than 30 minutes**
$$P(X > 30) = (40 - 30) \times \frac{1}{40} = \frac{10}{40} = 0.25 = 25\%$$

**(e) Assorted probabilities**

- Wait between 10 and 26 minutes:
  $$P(10 < X < 26) = \frac{26 - 10}{40} = \frac{16}{40} = \frac25 = 0.40 = 40\%$$
- $P(X = 20) = 0$, a single value.
- $P(X > 45) = 0$, outside the range.

**(f) Mean and standard deviation**
$$\mu = \frac{0 + 40}{2} = 20, \qquad \sigma = \frac{40}{\sqrt{12}} \approx 11.55$$

**(g) 85th percentile**

The area to the left of $K$ must be 0.85:
$$0.85 = (K - 0) \cdot \frac{1}{40} \;\Rightarrow\; K = 0.85 \times 40 = 34 \text{ minutes}$$

This is reasonable: the 75th percentile is 30, so the 85th must lie between 30 and 40.

---

## Example 2 - time to finish a chemistry test (20 to 45 minutes)

**(a) PDF**
$$f(x) = \frac{1}{45 - 20} = \frac{1}{25}, \qquad 20 \le x \le 45$$

**(b) Graph:** a rectangle of height $\tfrac{1}{25}$ from 20 to 45.

**(c) More than 36 minutes**
$$P(X > 36) = \frac{45 - 36}{25} = \frac{9}{25} = 0.36 = 36\%$$

**(d) Between 26 and 35 minutes**
$$P(26 < X < 35) = \frac{35 - 26}{25} = \frac{9}{25} = 0.36$$
The width is the same as in (c), so the probability is the same.

**(e) Mean (= median), variance, standard deviation**
$$\mu = \frac{20 + 45}{2} = 32.5, \qquad \sigma^2 = \frac{25^2}{12} = \frac{625}{12} \approx 52.08, \qquad \sigma \approx 7.217$$

**(f) Third quartile ($Q_3$ = 75th percentile)**
$$0.75 = (K - 20)\cdot\frac{1}{25} \;\Rightarrow\; K - 20 = 18.75 \;\Rightarrow\; K = 38.75 \text{ minutes}$$
Check: halfway between the median 32.5 and the maximum 45 is $(32.5 + 45)/2 = 38.75$ ✓

**(g) Conditional: more than 40 minutes, given more than 30 minutes**

$$P(X > 40 \mid X > 30) = \frac{P(X > 40 \text{ and } X > 30)}{P(X > 30)} = \frac{P(X > 40)}{P(X > 30)}$$

If $X > 40$, then $X > 30$ is automatically true, so the intersection is just $X > 40$.

$$= \frac{(45 - 40)\cdot\frac{1}{25}}{(45 - 30)\cdot\frac{1}{25}} = \frac{5}{15} = \frac13 \approx 33.3\%$$

The heights cancel, so a conditional uniform probability is just a **ratio of widths**.

---

## Key takeaways

- Uniform probability = **width of the interval ÷ total width**.
- A single point, or anything outside $[a, b]$, has probability 0.
- Percentile: solve $\dfrac{k}{100} = \dfrac{K - a}{b - a}$ for $K$.
- Mean = median = $(a + b)/2$, and $\sigma = (b - a)/\sqrt{12}$.
