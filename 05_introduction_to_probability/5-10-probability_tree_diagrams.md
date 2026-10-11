# Lesson 5.10 - Probability Tree Diagrams

> **Video:** [Probability Tree Diagrams](https://www.youtube.com/watch?v=w4wKXVwtGac) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## How a tree diagram works

- Each **branch** shows one possible outcome of a step, labeled with its probability.
- Branches leaving the same point **add up to 1**.
- **Along a path ("and")** → **multiply** the probabilities.
- **Combining paths ("or")** → **add** the path probabilities.
- All the final path probabilities add up to 1.

---

## Problem 1 - with replacement (independent)

A bag holds **8 red** and **12 blue** marbles (20 total). Two marbles are drawn **with replacement**.

$P(R) = \tfrac{8}{20} = \tfrac25$, $\;P(B) = \tfrac{12}{20} = \tfrac35$. These stay the same on every draw.

```
                 2/5   R  →  RR : 2/5 · 2/5 = 4/25
         R  <
   2/5 /         3/5   B  →  RB : 2/5 · 3/5 = 6/25
 start
   3/5 \         2/5   R  →  BR : 3/5 · 2/5 = 6/25
         B  <
                 3/5   B  →  BB : 3/5 · 3/5 = 9/25
```

Check: $4 + 6 + 6 + 9 = 25$, so the total is $25/25 = 1$ ✓

**(a) P(two blue)** $= \tfrac{9}{25} = 0.36 = 36\%$

**(b) P(at least one red)**: paths RR, RB, BR
$$\frac{4 + 6 + 6}{25} = \frac{16}{25} = 0.64$$
**Complement shortcut:** "at least one red" = "not both blue":
$$1 - P(BB) = 1 - 0.36 = 0.64 \;✓$$

**(c) P(red first, then blue)**: only RB
$$\frac{6}{25} = 0.24 = 24\%$$

**(d) P(one red and one blue), in any order**: RB or BR
$$\frac{6}{25} + \frac{6}{25} = \frac{12}{25} = 0.48 = 48\%$$

> (c) and (d) differ: "red **then** blue" fixes the order, while "a red **and** a blue" allows either order.

---

## Problem 2 - without replacement (dependent)

A bag holds **5 red** and **10 blue** marbles (15 total). Sally draws two **without replacement**, so the second-draw probabilities depend on the first draw.

```
                  4/14 = 2/7   R   →  RR : 1/3 · 2/7   = 2/21
          R  <                          (4 R, 10 B left)
   1/3  /         10/14 = 5/7  B   →  RB : 1/3 · 5/7   = 5/21
 start
   2/3  \         5/14         R   →  BR : 2/3 · 5/14  = 5/21
          B  <                          (5 R, 9 B left)
                  9/14         B   →  BB : 2/3 · 9/14  = 3/7
```

**(a) P(two red)**
$$\frac13 \cdot \frac27 = \frac{2}{21} \approx 0.095 = 9.5\%$$

**(b) P(one red and one blue), in any order**
$$P(RB) + P(BR) = \frac{5}{21} + \frac{5}{21} = \frac{10}{21} \approx 0.476 = 47.6\%$$

---

## Problem 3 - three draws with replacement

**3 blue**, **7 red** (10 total). Megan draws 3 **with replacement**: $P(R) = 0.7$, $P(B) = 0.3$ every time.

There are $2^3 = 8$ outcomes: RRR, RRB, RBR, RBB, BRR, BRB, BBR, BBB.

**(a) P(at least one red)**: every outcome except BBB
$$1 - P(BBB) = 1 - (0.3)^3 = 1 - 0.027 = 0.973 = 97.3\%$$

**(b) P(at most two blue)**: 0, 1 or 2 blue, again everything except BBB
$$1 - 0.027 = 0.973$$
"At least one red" and "at most two blue" describe the **same** event.

**(c) P(no red)** = P(BBB)
$$(0.3)^3 = 0.027 = 2.7\%$$

**(d) P(exactly two blue)**: RBB, BRB, BBR
$$3 \times (0.7)(0.3)(0.3) = 3 \times 0.063 = 0.189 = 18.9\%$$

---

## Problem 4 - percentages on a tree

There are **5,000** cars in a neighborhood. **40%** are black and **60%** are white. **75%** of the black cars are sedans (the rest SUVs). **20%** of the white cars are SUVs (the rest sedans).

```
                          0.75  sedan   1,500
          black  2,000 <
   0.40 /                 0.25  SUV       500
 5,000
   0.60 \                 0.80  sedan   2,400
          white  3,000 <
                          0.20  SUV       600
```

**(a) P(black sedan)**
$$\frac{1500}{5000} = 0.30, \quad\text{or along the path: } 0.40 \times 0.75 = 0.30 = 30\%$$

**(b) Number of white SUVs**
$$5000 \times 0.60 \times 0.20 = 600$$

---

## Key takeaways

- Multiply **along** a branch; add **across** branches.
- **With replacement:** the branch probabilities repeat. **Without replacement:** update both the counts and the total after each draw.
- "At least one …" is usually easiest as $1 - P(\text{none})$.
- Watch for "in that order" (one path) versus "in any order" (several paths).
