# Lesson 12.3 - Tests of Independence Using Chi-Square Distribution

> **Video:** [Test of Independence Using Chi-Square Distribution](https://www.youtube.com/watch?v=y5nxiL6civU) by The Organic Chemistry Tutor
> **Chapter:** [12 - The Chi-Square Distribution](https://www.video-tutor.net/chi-square-distributions.html)

## The idea

A **test of independence** checks whether two categorical variables in a **contingency table** are related.

| | Formula |
|---|---|
| $H_0$ | the variables are **independent** |
| $H_a$ | the variables are **dependent** (related) |
| Expected count for each cell | $E = \dfrac{\text{row total} \times \text{column total}}{\text{grand total}}$ |
| Test statistic | $\chi^2 = \sum \dfrac{(O - E)^2}{E}$ over **all** cells |
| Degrees of freedom | $(r - 1)(c - 1)$, where $r$ = rows and $c$ = columns |

It is a **right-tailed** test: reject $H_0$ if $\chi^2$ exceeds the critical value.

---

## Example - study time vs type of student

Is the number of hours spent studying each day related to whether a student is a freshman or a senior? $\alpha = 0.05$.

### Step 1 - complete the observed table

| | 0-2 h | 2-4 h | 4-6 h | **Row total** |
|---|---:|---:|---:|---:|
| Freshmen | 76 | 143 | 91 | **310** |
| Seniors | 147 | 109 | 64 | **320** |
| **Column total** | **223** | **252** | **155** | **630** |

### Step 2 - hypotheses and critical value

- $H_0$: study hours are **independent** of student type
- $H_a$: study hours **depend** on student type
- df $= (2 - 1)(3 - 1) = 2$, right-tail area 0.05: $\chi^2_{\text{crit}} = 5.99$

### Step 3 - expected counts

Example: $E_{1,1} = \dfrac{310 \times 223}{630} \approx 109.7$

| | 0-2 h | 2-4 h | 4-6 h |
|---|---:|---:|---:|
| Freshmen | 109.7 (≈110) | 124.0 | 76.3 (≈76) |
| Seniors | 113.3 (≈113) | 128.0 | 78.7 (≈79) |

The rounded values still match every row and column total (e.g. 110 + 124 + 76 = 310).

### Step 4 - test statistic (with the video's rounded expected counts)

| Cell | $O$ | $E$ | $(O - E)^2/E$ |
|---|---:|---:|---:|
| Freshmen, 0-2 | 76 | 110 | 10.51 |
| Freshmen, 2-4 | 143 | 124 | 2.91 |
| Freshmen, 4-6 | 91 | 76 | 2.96 |
| Seniors, 0-2 | 147 | 113 | 10.23 |
| Seniors, 2-4 | 109 | 128 | 2.82 |
| Seniors, 4-6 | 64 | 79 | 2.85 |
| **Total** | | | **≈ 32.3** |

> **Note:** expected counts don't have to be whole numbers. Using the unrounded values (109.73, 124.0, 76.27, 113.27, 128.0, 78.73) gives $\chi^2 \approx 31.7$. The conclusion is the same.

### Step 5 - decision

$32.3 > 5.99$, which is in the rejection region. **Reject $H_0$.** There is strong evidence that study time **depends** on student type. In the data, seniors are much more likely than freshmen to study only 0-2 hours a day.

---

## Key takeaways

- Expected count = (row total × column total) ÷ grand total.
- $\chi^2 = \sum (O - E)^2/E$ over every cell, with df $= (r-1)(c-1)$.
- Right-tailed: a large $\chi^2$ → reject independence → the variables are related.
