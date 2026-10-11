# Lesson 4.1 - Quartiles, Deciles, and Percentiles

> **Video:** [Quartiles, Deciles, & Percentiles With Cumulative Relative Frequency](https://www.youtube.com/watch?v=40o82o3uNfk) by The Organic Chemistry Tutor
> **Chapter:** [4 - Measures of Position](https://www.video-tutor.net/measures-of-position.html)

## What they are

| Measure | Splits the sorted data into | Memory aid |
|---|---|---|
| **Quartiles** $Q_1, Q_2, Q_3$ | **4** equal parts | 4 quarters = 1 dollar |
| **Deciles** $D_1, \dots, D_9$ | **10** equal parts | "deci" = one tenth (10 decimeters = 1 meter) |
| **Percentiles** $P_1, \dots, P_{99}$ | **100** equal parts | per-**cent** |

They line up with each other:

```
Percentile:  0   10   20   25   30   40   50   60   70   75   80   90  100
Decile:      D0  D1   D2        D3   D4   D5   D6   D7        D8   D9  D10
Quartile:    min           Q1             Q2                  Q3          max
```

- $Q_1 = P_{25}$, $\quad Q_2 = D_5 = P_{50} = $ median, $\quad Q_3 = P_{75}$
- $D_k = P_{10k}$, so $D_4 = P_{40}$ and $D_9 = P_{90}$.

### What does a percentile mean?

The **70th percentile** is a value such that **70%** of the data is **at or below** it and **30%** is **at or above** it.

*Example:* if your SAT score is at the 70th percentile, you scored as well as or better than 70% of test-takers, and 30% scored as well as or better than you.

---

## Method 1 - quartiles as medians of halves

- $Q_2$ = median of the whole data set.
- $Q_1$ = median of the **lower half**; $Q_3$ = median of the **upper half**. When $n$ is odd, the median is left out of both halves.

**Example (odd $n = 11$):** 2, 3, 5, 7, 8, **10**, 11, 13, 15, 16, 19

- $Q_2 = 10$
- Lower half 2, 3, **5**, 7, 8 → $Q_1 = 5$
- Upper half 11, 13, **15**, 16, 19 → $Q_3 = 15$

---

## Method 2 - the percentile location formula

The **position** of the $k$-th percentile in the sorted list is

$$L_k = \frac{k}{100}(n + 1)$$

- If $L_k$ is a whole number, the percentile is the value at that position.
- If $L_k$ falls between two positions, the video **averages the two neighboring values**.

**Same data ($n = 11$):**

| Percentile | Location | Value |
|---|---|---|
| $P_{25} = Q_1$ | $\tfrac{25}{100}(12) = 3$ → 3rd value | 5 |
| $P_{50} = Q_2$ | $\tfrac{50}{100}(12) = 6$ → 6th value | 10 |
| $P_{75} = Q_3$ | $\tfrac{75}{100}(12) = 9$ → 9th value | 15 |

Both methods agree.

### Example with even $n = 16$

The video uses a list of 16 numbers shown on screen. The positions that matter are:

| Position | 4 | 5 | 6 | 8 | 9 | 10 | 11 | 12 | 13 |
|---|---|---|---|---|---|---|---|---|---|
| Value | 9 | 11 | 12 | 15 | 16 | 16 | 17 | 19 | 20 |

- **Medians of halves:** $Q_2 = \dfrac{15 + 16}{2} = 15.5$, $\;Q_1 = \dfrac{9 + 11}{2} = 10$, $\;Q_3 = \dfrac{19 + 20}{2} = 19.5$
- **Formula for $Q_1$:** $L_{25} = \tfrac14(17) = 4.25$, between the 4th and 5th values → $\dfrac{9 + 11}{2} = 10$ ✓
- **Formula for $Q_3$:** $L_{75} = \tfrac34(17) = 12.75$, between the 12th and 13th values → $\dfrac{19 + 20}{2} = 19.5$ ✓
- **6th decile ($P_{60}$):** $L_{60} = 0.6(17) = 10.2$, between the 10th (16) and 11th (17) values → $\dfrac{16 + 17}{2} = 16.5$

> **About $D_6$:** the location 10.2 is much closer to position 10 than to 11, so the video suggests the true answer should be closer to 16. **Linear interpolation** makes this precise: $16 + 0.2(17 - 16) = 16.2$. With small $n$ these estimates are rough, and they become more accurate as $n$ grows.

---

## Going backwards - which percentile is a given value?

$$\text{percentile of value } v = \frac{x + 0.5\,y}{n} \times 100$$

- $x$ = number of values **less than** $v$
- $y$ = number of times $v$ appears
- $n$ = total number of values

**Using the same 16-number list:**

- **Value 12:** 5 values are below it and 12 appears once.
  $$\frac{5 + 0.5(1)}{16} \times 100 = 34.375 \approx 34\text{th percentile}$$
  This makes sense: 12 lies between $Q_1$ (25th) and $Q_2$ (50th).
- **Value 16:** 8 values are below it and 16 appears twice.
  $$\frac{8 + 0.5(2)}{16} \times 100 = 56.25 \approx 56\text{th percentile}$$

---

## Percentiles from a cumulative relative frequency table

**Data (20 values):**

| Value | $f$ | RF | CRF |
|---:|---:|---:|---:|
| 2 | 2 | 0.10 | 0.10 |
| 3 | 4 | 0.20 | 0.30 |
| 4 | 3 | 0.15 | 0.45 |
| 6 | 2 | 0.10 | 0.55 |
| 7 | 1 | 0.05 | 0.60 |
| 9 | 5 | 0.25 | 0.85 |
| 10 | 2 | 0.10 | 0.95 |
| 12 | 1 | 0.05 | 1.00 |
| **Total** | **20** | **1.00** | |

**Rules:**

- If the percentile falls **strictly between** two CRF values, take the value of the **higher** row.
- If it equals a CRF value **exactly**, average that row's value with the next row's value.

| Decile | Percentile | Where it falls | Value |
|---|---|---|---|
| $D_4$ | 40th | between 0.30 and 0.45 | **4** |
| $D_7$ | 70th | between 0.60 and 0.85 | **9** |
| $D_3$ | 30th | exactly 0.30 → average 3 and 4 | **3.5** |
| $D_6$ | 60th | exactly 0.60 → average 7 and 9 | **8** |

**Check by listing the data in pairs** (20 values ÷ 10 deciles = 2 values per decile):

```
2 2 | 3 3 | 3 3 | 4 4 | 4 6 | 6 7 | 9 9 | 9 9 | 9 10 | 10 12
   D1    D2    D3    D4    D5    D6    D7    D8     D9
```

- $D_3$ sits between a 3 and a 4 → 3.5
- $D_4$ sits between two 4s → 4
- $D_6$ sits between a 7 and a 9 → 8
- $D_7$ sits between two 9s → 9

---

## Key takeaways

- Quartiles split the data into 4 parts, deciles into 10, percentiles into 100. $Q_2 = D_5 = P_{50}$ = median.
- Location of $P_k$: $\dfrac{k}{100}(n+1)$. If it is not a whole number, use the neighboring values (average them, or interpolate).
- Percentile of a value: $\dfrac{x + 0.5y}{n} \times 100$.
- From a CRF table: strictly between two rows → higher value; exactly on a row → average with the next value.
- Different textbooks and software use slightly different percentile rules. Small differences are normal.
