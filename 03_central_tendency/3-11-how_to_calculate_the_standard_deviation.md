# Lesson 3.11 - How to Calculate the Standard Deviation

> **Video:** [How To Calculate The Standard Deviation](https://www.youtube.com/watch?v=IaTFpp-uzp0) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

## Formula (sample standard deviation)

$$s = \sqrt{\frac{\sum (x - \bar x)^2}{n - 1}}$$

## Steps

1. Find the **mean** $\bar x$.
2. For each value, find the **deviation** $x - \bar x$.
3. **Square** each deviation. The sign stops mattering, so you can use the distance from the mean.
4. **Add** the squared deviations.
5. **Divide** by $n - 1$.
6. Take the **square root**.

---

## Example 1 - five values

Data: 82, 93, 98, 89, 88

**Mean:** $\bar x = \dfrac{450}{5} = 90$

| $x$ | $x - \bar x$ | $(x - \bar x)^2$ |
|---:|---:|---:|
| 82 | −8 | 64 |
| 93 | 3 | 9 |
| 98 | 8 | 64 |
| 89 | −1 | 1 |
| 88 | −2 | 4 |
| **Sum** | 0 | **142** |

$$s = \sqrt{\frac{142}{5 - 1}} = \sqrt{35.5} \approx 5.958$$

---

## Example 2 - ten values

Data: 76, 84, 69, 92, 58, 89, 73, 97, 85, 77

**Mean:** $\bar x = \dfrac{800}{10} = 80$

**Shortcut:** squaring removes the sign, so just write how far each value is from 80.

| $x$ | Distance from 80 | Squared |
|---:|---:|---:|
| 76 | 4 | 16 |
| 84 | 4 | 16 |
| 69 | 11 | 121 |
| 92 | 12 | 144 |
| 58 | 22 | 484 |
| 89 | 9 | 81 |
| 73 | 7 | 49 |
| 97 | 17 | 289 |
| 85 | 5 | 25 |
| 77 | 3 | 9 |
| **Sum** | | **1234** |

$$s = \sqrt{\frac{1234}{10 - 1}} = \sqrt{137.11} \approx 11.709$$

---

## Key takeaways

- Standard deviation measures the **typical distance of the data from the mean**.
- The sample version divides by **$n - 1$**. The population version ($\sigma$) divides by $N$ and uses $\mu$.
- Check: the deviations $x - \bar x$ always add up to **0**.
