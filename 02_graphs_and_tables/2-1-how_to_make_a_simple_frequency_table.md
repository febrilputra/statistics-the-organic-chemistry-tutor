# Lesson 2.1 - How to Make a Simple Frequency Table

> **Video:** [How To Make a Simple Frequency Table](https://www.youtube.com/watch?v=lyRbCwDDnJo) by The Organic Chemistry Tutor
> **Chapter:** [2 - Graphs and Tables](https://www.video-tutor.net/graphs-and-tables.html)

## What is a frequency table?

A **frequency table** has two columns:

| V (value) | f (frequency) |
|---|---|
| each different value in the data | how many times that value occurs |

**How to build one:**

1. Find the **lowest** value and count how many times it appears.
2. Move to the **next** value up and count again.
3. Repeat until you reach the highest value. Skip values that do not appear.

---

## Using a frequency table to find the mean, median, mode, and range

| Measure | How to read it from the table |
|---|---|
| **Range** | highest value − lowest value |
| **Mode** | the value with the **largest frequency** (two tied → **bimodal**) |
| **Median** | the middle value; count in from both ends using the frequencies |
| **Mean** | $\bar x = \dfrac{\sum (V \cdot f)}{\sum f}$; multiply each value by its frequency, add, and divide by $n = \sum f$ |

---

## Example 1

The data contains these values and counts:

| V | f | V · f |
|---:|---:|---:|
| 3 | 2 | 6 |
| 4 | 3 | 12 |
| 5 | 5 | 25 |
| 7 | 1 | 7 |
| 8 | 5 | 40 |

- **Range:** $8 - 3 = 5$
- **Mode:** 5 and 8 both have the highest frequency (5) → **bimodal**, modes 5 and 8.

**Now add one more 5.** The frequency of 5 becomes **6**:

| V | f | V · f |
|---:|---:|---:|
| 3 | 2 | 6 |
| 4 | 3 | 12 |
| 5 | **6** | **30** |
| 7 | 1 | 7 |
| 8 | 5 | 40 |
| **Total** | **17** | **95** |

- **Range:** still $8 - 3 = 5$.
- **Mode:** now only **5** has the highest frequency → **unimodal**, mode = 5.
- **Median:** $n = 17$, so the median is the 9th value. Counting up: positions 1-2 are 3s, 3-5 are 4s, 6-11 are 5s. The 9th value is **5**.
  - Check by writing it out: 3 3 4 4 4 5 5 5 **5** 5 5 7 8 8 8 8 8
- **Mean:** $\bar x = \dfrac{95}{17} \approx 5.59$

---

## Example 2 (practice)

| V | f | V · f |
|---:|---:|---:|
| 2 | 4 | 8 |
| 4 | 3 | 12 |
| 5 | 2 | 10 |
| 6 | 1 | 6 |
| 8 | 4 | 32 |
| 9 | 5 | 45 |
| **Total** | **19** | **113** |

- **Range:** $9 - 2 = 7$
- **Mode:** 9 (frequency 5, the largest)
- **Median:** $n = 19$, so the median is the 10th value. Running counts: 4 (2s), 7 (4s), 9 (5s), **10** (6). The 10th value is **6**.
  - Written out: 2 2 2 2 4 4 4 5 5 **6** 8 8 8 8 9 9 9 9 9
- **Mean:** $\bar x = \dfrac{113}{19} \approx 5.95$

---

## Key takeaways

- A frequency table lists each **value** and its **frequency**.
- $n$ = the **sum of the frequency column**.
- Total of all data = $\sum (V \cdot f)$, so **mean** = $\sum (V \cdot f) / n$.
- **Mode** = value with the highest frequency. **Range** = highest − lowest.
- **Median** = the value at position $(n+1)/2$ when $n$ is odd, or the average of the two middle values when $n$ is even. Use running totals of $f$ to find it.
