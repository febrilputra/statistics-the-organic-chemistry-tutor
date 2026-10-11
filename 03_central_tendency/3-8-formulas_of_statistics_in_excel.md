# Lesson 3.8 - Formulas of Statistics in Excel

> **Video:** [Statistics - Excel](https://www.youtube.com/watch?v=aRR86imVsxM) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

The video applies Excel's built-in functions to a column of **19 test scores** in cells `A2:A20`, ranging from 52 to 99. Every function has the same pattern: type `=`, the function name, then select the data range.

---

## Basic summary functions

| What you want | Excel formula | Result in the video |
|---|---|---|
| Sum | `=SUM(A2:A20)` | — |
| Number of values $n$ | `=COUNT(A2:A20)` | 19 |
| Mean | `=AVERAGE(A2:A20)`, or `=SUM(...)/COUNT(...)` | — |
| Median | `=MEDIAN(A2:A20)` | 84 |
| Mode | `=MODE(A2:A20)` (or `=MODE.SNGL`) | 86 (the only score that appears twice) |
| Minimum | `=MIN(A2:A20)` | 52 |
| Maximum | `=MAX(A2:A20)` | 99 |
| Range | `=MAX(A2:A20)-MIN(A2:A20)` | 47 |

`MIN` and `MAX` are especially useful with large data sets (thousands of rows) where you can't spot the extremes by eye.

---

## Spread: standard deviation and variance

| What you want | Sample (usual choice) | Population |
|---|---|---|
| Standard deviation | `=STDEV.S(A2:A20)` → 12.46 | `=STDEV.P(A2:A20)` |
| Variance | `=VAR.S(A2:A20)` | `=VAR.P(A2:A20)` |

Variance = SD², so if the SD is in cell `E10`, then `=E10^2` gives the same value as `VAR.S`.

---

## Quartiles

`=QUARTILE(A2:A20, k)`, where `k` is 0-4. Newer versions also have `QUARTILE.INC` (same as `QUARTILE`) and `QUARTILE.EXC`, which give slightly different answers.

| `k` | Meaning | Equivalent | Video result |
|---:|---|---|---|
| 0 | 0th percentile | minimum | 52 |
| 1 | $Q_1$, 25th percentile | | 75 |
| 2 | $Q_2$, 50th percentile | median | 84 |
| 3 | $Q_3$, 75th percentile | | 88.5 |
| 4 | 100th percentile | maximum | 99 |

---

## Percentiles

`=PERCENTILE(A2:A20, p)` (or `PERCENTILE.INC`). Enter $p$ as a **decimal**: the 25th percentile is `0.25`, **not** `25`.

| Percentile | Formula | Same as |
|---|---|---|
| 0th | `=PERCENTILE(A2:A20, 0)` | minimum, `QUARTILE(...,0)` |
| 25th | `=PERCENTILE(A2:A20, 0.25)` | $Q_1$ |
| 40th | `=PERCENTILE(A2:A20, 0.40)` | |
| 50th | `=PERCENTILE(A2:A20, 0.5)` | median, $Q_2$ |
| 75th | `=PERCENTILE(A2:A20, 0.75)` | $Q_3$ |
| 90th | `=PERCENTILE(A2:A20, 0.9)` | (94.4 in the video) |
| 100th | `=PERCENTILE(A2:A20, 1)` | maximum |

---

## Deciles

**Deciles** split the data into **10** equal parts ("deci" = one tenth), just as quartiles split it into 4. Excel has no decile function, so use `PERCENTILE`:

| Decile | Formula |
|---|---|
| $D_0$ | `=PERCENTILE(A2:A20, 0)` (minimum) |
| $D_1$ | `=PERCENTILE(A2:A20, 0.1)` |
| $D_5$ | `=PERCENTILE(A2:A20, 0.5)` (median) |
| $D_7$ | `=PERCENTILE(A2:A20, 0.7)` |
| $D_{10}$ | `=PERCENTILE(A2:A20, 1)` (maximum) |

In general, decile $k$ is `PERCENTILE(range, k/10)`.

---

## Key takeaways

- `SUM`, `COUNT`, `AVERAGE`, `MEDIAN`, `MODE`, `MIN`, `MAX` cover the basics.
- Use `STDEV.S` / `VAR.S` for **samples** and `STDEV.P` / `VAR.P` for **populations**.
- `QUARTILE(range, 0…4)`, `PERCENTILE(range, decimal)`. Deciles = `PERCENTILE(range, k/10)`.
- Excel's quartile and percentile rules can differ slightly from hand methods, because there are several conventions.
