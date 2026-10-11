# Lesson 3.14 - Mean, Median, and Mode of Grouped Data

> **Video:** [Mean, Median, and Mode of Grouped Data & Frequency Distribution Tables](https://www.youtube.com/watch?v=zjHfAhcU6kE) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

## Idea

With **grouped data** you only know how many values fall in each **class interval**, not the individual values. The mean can only be **estimated**. Each class is represented by its **midpoint**:

$$\text{midpoint } m = \frac{\text{lower limit} + \text{upper limit}}{2}$$

$$\bar x \approx \frac{\sum f\,m}{\sum f}$$

- **Modal class:** the interval with the highest frequency.
- **Median class:** the interval containing the middle value, at position $n/2$. Find it with a **cumulative frequency** column.

---

## Example 1 - test grades

| Grade | $f$ | Midpoint $m$ | $f \cdot m$ | Cumulative $f$ |
|---|---:|---:|---:|---:|
| 40-49 | 3 | 44.5 | 133.5 | 3 |
| 50-59 | 5 | 54.5 | 272.5 | 8 |
| 60-69 (D) | 6 | 64.5 | 387.0 | 14 |
| 70-79 (C) | 9 | 74.5 | 670.5 | 23 |
| 80-89 (B) | 8 | 84.5 | 676.0 | 31 |
| 90-100 (A) | 7 | 95.0 | 665.0 | 38 |
| **Total** | **38** | | **2804.5** | |

- Midpoint example: $(40 + 49)/2 = 44.5$. The last class is $(90 + 100)/2 = 95$.

**Mean:**
$$\bar x \approx \frac{2804.5}{38} \approx 73.8$$

This is reasonable: the most common class is 70-79, and the estimate lands there.

**Mode:** the highest frequency is 9, so the modal class is **70-79**.

**Median:** half of 38 is 19. The cumulative counts reach 14 by the end of 60-69 and 23 by the end of 70-79. The 70-79 class holds students 15-23, which includes 19, so the median class is **70-79**.

---

## Example 2 - student weights (lb)

| Weight | $f$ | Midpoint $m$ | $f \cdot m$ | Cumulative $f$ |
|---|---:|---:|---:|---:|
| 120-139 | 6 | 129.5 | 777.0 | 6 |
| 140-159 | 8 | 149.5 | 1196.0 | 14 |
| 160-179 | 12 | 169.5 | 2034.0 | 26 |
| 180-199 | 7 | 189.5 | 1326.5 | 33 |
| 200-220 | 3 | 210.0 | 630.0 | 36 |
| **Total** | **36** | | **5963.5** | |

**Mean:**
$$\bar x \approx \frac{5963.5}{36} \approx 165.7 \text{ lb}$$

The mean is in the 160-179 class but nearer 160, because more of the data lies on the lower (left) side.

**Mode:** the highest frequency is 12, so the modal class is **160-179**.

**Median:** half of 36 is 18. The classes cover students 1-6, 7-14, then **15-26**, so the 18th student is in **160-179**.

---

## Key takeaways

- Grouped data → **estimated** mean: $\sum fm / \sum f$, using class midpoints.
- **Modal class** = highest frequency.
- **Median class** = the class whose cumulative frequency first reaches $n/2$.
- To find the exact median or mode *within* a class, see Lessons 3.16 and 3.17.
