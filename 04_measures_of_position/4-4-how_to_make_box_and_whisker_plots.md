# Lesson 4.4 - How to Make Box and Whisker Plots

> **Video:** [How To Make Box and Whisker Plots](https://www.youtube.com/watch?v=mhaGAaL6Abw) by The Organic Chemistry Tutor
> **Chapter:** [4 - Measures of Position](https://www.video-tutor.net/measures-of-position.html)

## The five-number summary

A box-and-whisker plot (box plot) is built from five values:

1. **Minimum** (smallest value that is not an outlier)
2. $Q_1$
3. $Q_2$ (median)
4. $Q_3$
5. **Maximum** (largest value that is not an outlier)

## Steps

1. Sort the data.
2. Find $Q_2$, then $Q_1$ and $Q_3$.
3. Compute $\text{IQR} = Q_3 - Q_1$ and the fences $Q_1 - 1.5\,\text{IQR}$ and $Q_3 + 1.5\,\text{IQR}$.
4. Values outside the fences are **outliers**. They are plotted as **separate points**, not as part of the whiskers.
5. Draw a number line. Draw a **box** from $Q_1$ to $Q_3$ with a line at $Q_2$, and **whiskers** out to the minimum and maximum non-outliers.

---

## Example 1 - no outliers

Data: 11, 22, 20, 14, 29, 8, 35, 27, 13, 49, 10, 24, 17

Sorted ($n = 13$): 8, 10, 11, 13, 14, 17, **20**, 22, 24, 27, 29, 35, 49

- $Q_2 = 20$
- Lower half 8, 10, 11, 13, 14, 17 → $Q_1 = \dfrac{11 + 13}{2} = 12$
- Upper half 22, 24, 27, 29, 35, 49 → $Q_3 = \dfrac{27 + 29}{2} = 28$
- $\text{IQR} = 28 - 12 = 16$
- Fences: $12 - 1.5(16) = -12$ and $28 + 1.5(16) = 52$

Both 8 and 49 are inside $[-12, 52]$, so there are **no outliers**. Minimum = 8, maximum = 49.

```
            +-------|-------+
        |---|       |       |--------------------|
            +-------|-------+
+---------+---------+---------+---------+---------+
0         10        20        30        40        50
         min=8  Q1=12  Q2=20  Q3=28              max=49
```

---

## Example 2 - with an outlier

Data: 18, 34, 76, 29, 15, 41, 46, 25, 54, 38, 20, 32, 43, 22

Sorted ($n = 14$): 15, 18, 20, **22**, 25, 29, 32 ‖ 34, 38, 41, **43**, 46, 54, 76

- $Q_2 = \dfrac{32 + 34}{2} = 33$
- Lower half (7 values) → middle value $Q_1 = 22$
- Upper half (7 values) → middle value $Q_3 = 43$
- $\text{IQR} = 43 - 22 = 21$
- Fences: $22 - 1.5(21) = -9.5$ and $43 + 1.5(21) = 74.5$

**76 > 74.5, so 76 is an outlier.** The right whisker stops at the largest non-outlier, **54**, and 76 is drawn as a separate point (`*`).

```
                      +----------|---------+
               |------|          |         |----------|                     *
                      +----------|---------+
+---------+---------+---------+---------+---------+---------+---------+---------+
0         10        20        30        40        50        60        70        80
             min=15  Q1=22    Q2=33    Q3=43     max=54              outlier=76
```

---

## Key takeaways

- Box = $Q_1$ to $Q_3$ (the IQR), with a line at the median $Q_2$.
- Whiskers reach the most extreme values that are **not** outliers.
- Outliers (beyond $Q_1 - 1.5\,\text{IQR}$ or $Q_3 + 1.5\,\text{IQR}$) are shown as individual points.
