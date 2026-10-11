# Lesson 2.3 - Cumulative Relative Frequency Table

> **Video:** [How To Make a Cumulative Relative Frequency Table](https://www.youtube.com/watch?v=6hJGa4Zp62M) by The Organic Chemistry Tutor
> **Chapter:** [2 - Graphs and Tables](https://www.video-tutor.net/graphs-and-tables.html)

## Idea

**Cumulative relative frequency (CRF)** is a **running total** of the relative frequencies. For each value, it gives the fraction of the data that is **less than or equal to** that value.

$$\text{CRF}_k = \text{RF}_1 + \text{RF}_2 + \dots + \text{RF}_k$$

## Steps

1. Columns: **V** (value), **f** (frequency), **RF** (relative frequency), **CRF** (cumulative relative frequency).
2. Fill in V and f, then find $n = \sum f$.
3. RF = $f / n$. Check that the RF column adds to 1.
4. CRF: start with the first RF, then keep adding the next RF.
5. **Check:** the last CRF must be **1.00**.

---

## Example

The data has 25 values with these counts (there are no 4s or 7s):

| V | f | RF = f / 25 | CRF |
|---:|---:|---:|---:|
| 2 | 5 | 0.20 | 0.20 |
| 3 | 8 | 0.32 | 0.20 + 0.32 = **0.52** |
| 5 | 4 | 0.16 | 0.52 + 0.16 = **0.68** |
| 6 | 3 | 0.12 | 0.68 + 0.12 = **0.80** |
| 8 | 2 | 0.08 | 0.80 + 0.08 = **0.88** |
| 9 | 3 | 0.12 | 0.88 + 0.12 = **1.00** |
| **Total** | **25** | **1.00** | |

**Reading the CRF column:**

- 0.52 at V = 3 → 52% of the values are 3 or less.
- 0.80 at V = 6 → 80% of the values are 6 or less.

---

## Key takeaways

- CRF = running sum of RF. It never decreases and always ends at **1**.
- CRF answers "what fraction of the data is **at or below** this value?"
- That makes the CRF column useful for **percentiles and quartiles** (see Lesson 1.1 and Chapter 4).
