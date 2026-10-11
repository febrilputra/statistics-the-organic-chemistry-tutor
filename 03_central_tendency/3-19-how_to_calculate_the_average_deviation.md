# Lesson 3.19 - How to Calculate the Average Deviation

> **Video:** [How To Calculate the Average Deviation](https://www.youtube.com/watch?v=VoZYDR8GFpk) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

## Formula

The **average deviation** (signed, with **no** absolute value) is

$$A = \frac{\sum (x - \bar x)}{n}$$

Compare it with the **mean absolute deviation** (Lesson 3.18), which uses $|x - \bar x|$.

---

## Example

Data: 8, 12, 15, 18, 19, 23, 31

**Mean:** $\bar x = \dfrac{126}{7} = 18$

**Deviations:**

| $x$ | 8 | 12 | 15 | 18 | 19 | 23 | 31 |
|---|---:|---:|---:|---:|---:|---:|---:|
| $x - 18$ | −10 | −6 | −3 | 0 | 1 | 5 | 13 |

$$A = \frac{-10 - 6 - 3 + 0 + 1 + 5 + 13}{7} = \frac{0}{7} = 0$$

The positives and negatives cancel: $-6$ with $1 + 5$, and $-10 - 3 = -13$ with $+13$.

---

## Why is it always zero?

$$\sum (x - \bar x) = \sum x - n\bar x = \sum x - \sum x = 0$$

This holds for **every** data set: the mean is exactly the balance point of the data. So the signed average deviation **cannot** measure spread, which is why statistics uses:

- the **mean absolute deviation**, which uses absolute values, and
- the **variance / standard deviation**, which square the deviations.

---

## Key takeaways

- Average (signed) deviation = $\sum (x - \bar x)/n$, and it is **always 0**.
- It is a useful check: if your deviations don't add to 0, the mean is wrong.
- To measure spread, use the MAD or the standard deviation instead.
