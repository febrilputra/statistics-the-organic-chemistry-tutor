# Lesson 3.3 - How to Calculate the Median Using a Formula

> **Video:** [How To Calculate The Median Using a Formula](https://www.youtube.com/watch?v=xkDrB6LQFP0) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

## The formulas

First **sort the data** in ascending order. Let $a_k$ be the $k$-th value in the sorted list.

**When $n$ is odd:**

$$\text{median} = a_{\frac{n+1}{2}}$$

**When $n$ is even:**

$$\text{median} = \frac{a_{\frac{n}{2}} + a_{\frac{n}{2}+1}}{2}$$

This is the average of the two middle terms.

The formula tells you **which position** holds the median, which is handy when $n$ is large.

---

## Example 1 - odd $n$

Data: 7, 14, 5, 19, 26, 42, 13

Sorted: 5, 7, 13, **14**, 19, 26, 42 ($n = 7$)

$$\frac{n+1}{2} = \frac{8}{2} = 4 \;\Rightarrow\; \text{median} = a_4 = 14$$

## Example 2 - even $n$

Data: 8, 21, 14, 36, 17, 2, 56, 41

Sorted: 2, 8, 14, **17, 21**, 36, 41, 56 ($n = 8$)

$$\frac{n}{2} = 4, \quad \frac{n}{2} + 1 = 5 \;\Rightarrow\; \text{median} = \frac{a_4 + a_5}{2} = \frac{17 + 21}{2} = 19$$

---

## Key takeaways

- Always sort first. The formula gives a **position**, not a value.
- Odd $n$: one middle term at position $(n+1)/2$.
- Even $n$: average the terms at positions $n/2$ and $n/2 + 1$.
