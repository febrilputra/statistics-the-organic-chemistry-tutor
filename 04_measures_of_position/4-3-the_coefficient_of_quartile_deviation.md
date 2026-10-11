# Lesson 4.3 - The Coefficient of Quartile Deviation

> **Video:** [How To Calculate the Coefficient of Quartile Deviation](https://www.youtube.com/watch?v=AUrzJeIEBA4) by The Organic Chemistry Tutor
> **Chapter:** [4 - Measures of Position](https://www.video-tutor.net/measures-of-position.html)

## Formulas

**Location of the $k$-th quartile** in the sorted data:

$$\text{position of } Q_k = \frac{k(n + 1)}{4}$$

The formula gives the **position**. Read the **value** from the data.

| Quantity | Formula |
|---|---|
| Interquartile range | $\text{IQR} = Q_3 - Q_1$ |
| **Quartile deviation** (semi-interquartile range) | $\text{QD} = \dfrac{Q_3 - Q_1}{2}$ |
| **Coefficient of quartile deviation** | $\text{CQD} = \dfrac{Q_3 - Q_1}{Q_3 + Q_1}$ |

---

## Example

The data set has $n = 11$ values (already sorted). Its 3rd value is 14 and its 9th value is 35.

**Find the quartiles.**

- $Q_1$: position $\dfrac{1(11 + 1)}{4} = 3$ → 3rd value → $Q_1 = 14$
- $Q_3$: position $\dfrac{3(11 + 1)}{4} = 9$ → 9th value → $Q_3 = 35$

**(a) Interquartile range**
$$\text{IQR} = 35 - 14 = 21$$

**(b) Quartile deviation**
$$\text{QD} = \frac{21}{2} = 10.5$$

**(c) Coefficient of quartile deviation**
$$\text{CQD} = \frac{35 - 14}{35 + 14} = \frac{21}{49} \approx 0.429$$

---

## Key takeaways

- QD = half the IQR. It is a spread measure that ignores the extreme 25% at each end.
- CQD = $(Q_3 - Q_1)/(Q_3 + Q_1)$ has **no units**, so it can compare spread across data sets, like the coefficient of range ($(H-L)/(H+L)$, Lesson 3.4).
