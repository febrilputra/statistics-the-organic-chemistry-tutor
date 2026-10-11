# Lesson 3.10 - Averages and Uncertainty Calculations

> **Video:** [Averages and Uncertainty Calculations](https://www.youtube.com/watch?v=CSJewgNUZKw) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

## Idea

Report a set of measurements as **mean ± uncertainty**, where the uncertainty here is **half the range**:

$$u = \frac{\text{max} - \text{min}}{2}, \qquad \text{result} = \bar x \pm u$$

On a number line, the mean sits in the middle. Going up by $u$ reaches roughly the top of the data, and going down by $u$ reaches roughly the bottom, so $\bar x \pm u$ spans about the whole range.

The uncertainty is usually **rounded to one significant figure**.

> This "half the range" rule is a quick estimate common in lab courses. Later chapters use the standard deviation and the standard error as more formal measures of uncertainty.

---

## Example 1 - test scores

Scores: 79, 84, 91, 86, 95, 77, 88, 96

- Mean: $\bar x = \dfrac{696}{8} = 87$
- Uncertainty: $u = \dfrac{96 - 77}{2} = \dfrac{19}{2} = 9.5 \approx 10$ (1 significant figure)

$$\text{score} = 87 \pm 10$$

Check: $87 - 10 = 77$ and $87 + 10 = 97$, so every score lies inside this interval.

---

## Example 2 - velocity measured once per second

Velocities: 46, 48, 47, 48, 51, 53, 55, 52, 50, 46

- Mean: $\bar x = \dfrac{496}{10} = 49.6$
- Uncertainty: $u = \dfrac{55 - 46}{2} = 4.5 \approx 5$

$$v = 49.6 \pm 5$$

This gives the interval 44.6 to 54.6. The maximum 55 sits just outside it, so the summary is close but not perfect.

> **Significant-figure note:** many lab manuals also round the mean to the same decimal place as the uncertainty, giving $50 \pm 5$.

---

## Key takeaways

- Mean = sum ÷ count. Uncertainty (quick method) = range ÷ 2.
- Round the uncertainty to **one significant figure**.
- Write the result as $\bar x \pm u$. The interval should cover nearly all the data.
