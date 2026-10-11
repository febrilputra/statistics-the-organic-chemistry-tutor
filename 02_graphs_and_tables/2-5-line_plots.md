# Lesson 2.5 - Line Plots

> **Video:** [A Beginner's Guide To Line Plots](https://www.youtube.com/watch?v=JnoBjHz2dtw) by The Organic Chemistry Tutor
> **Chapter:** [2 - Graphs and Tables](https://www.video-tutor.net/graphs-and-tables.html)

## Idea

A **line plot** is the same idea as a dot plot. Draw a number line and put an **X** above a value each time it appears in the data.

---

## Example 1 - drawing a line plot

The data contains: three 0s, five 1s, two 2s, one 3, four 4s, two 5s.

1. Sort the values: 0 0 0 1 1 1 1 1 2 2 3 4 4 4 4 5 5
2. Draw a number line from 0 to 5.
3. Stack one X per value.

```
       X
       X        X
    X  X        X
    X  X  X     X  X
    X  X  X  X  X  X
----+--+--+--+--+--+--
    0  1  2  3  4  5
```

---

## Example 2 - reading a line plot

A survey asked everyone in a 55-and-older community how many cars they own. The line plot shows:

| Cars owned ($x$) | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Number of people (X's) | 7 | 8 | 6 | 5 | 3 | 4 | 3 | 2 | 1 |

**(a) How many people own exactly one car?** Count the X's above 1 → **8**.

**(b) How many own *at least* two cars ($x \ge 2$)?** Add everything from 2 upward:
$$6 + 5 + 3 + 4 + 3 + 2 + 1 = 24$$

**(c) How many own *at most* three cars ($x \le 3$)?** Add 0 through 3, including 3:
$$7 + 8 + 6 + 5 = 26$$

**(d) How many own four or five cars?** $3 + 4 = 7$

**(e) How many people live in the community?** Assuming everyone answered, add all the X's:
$$7 + 8 + 6 + 5 + 3 + 4 + 3 + 2 + 1 = 39$$

**(f) How many cars are there in total?** Multiply each number of cars by how many people own that many, then add:

| $x$ | People | Cars = $x \times$ people |
|---:|---:|---:|
| 0 | 7 | 0 |
| 1 | 8 | 8 |
| 2 | 6 | 12 |
| 3 | 5 | 15 |
| 4 | 3 | 12 |
| 5 | 4 | 20 |
| 6 | 3 | 18 |
| 7 | 2 | 14 |
| 8 | 1 | 8 |
| **Total** | **39** | **107** |

There are **107 cars** in the community.

---

## Key takeaways

- One X per data value. The height of a column is the frequency.
- **"At least $k$"** means $x \ge k$. **"At most $k$"** means $x \le k$. Both **include** $k$.
- Total number of people = total number of X's.
- Total amount (cars) = $\sum (\text{value} \times \text{frequency})$, the same idea as computing a mean from a frequency table.
