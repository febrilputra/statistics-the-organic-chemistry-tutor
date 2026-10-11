# Lesson 5.1 - Introduction to Probability

> **Video:** [Introduction to Probability, Basic Overview - Sample Space, & Tree Diagrams](https://www.youtube.com/watch?v=SkidyDQuupA) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Probability of an event

$$P(A) = \frac{\text{number of favorable outcomes (outcomes in } A)}{\text{total number of possible outcomes}}$$

This counting formula works when all outcomes are **equally likely**.

### Range of values

$$0 \le P(A) \le 1$$

| $P(A)$ | Meaning |
|---|---|
| 0 | Impossible, it never happens |
| 1 | Certain, it always happens (100%) |
| 0.3 | 30% chance: about 3 times in 10 tries, or 30 in 100 |

*Example:* if 20% of a city's residents drive a blue car, then picking 100 people at random should give **about 20** blue-car drivers, and picking 1,000 should give about 200.

---

## Sample space and tree diagrams

The **sample space** $S$ is the set of **all possible outcomes**.

**One coin:** $S = \{H, T\}$

**Two coins:** use a tree diagram.

```
        H ── HH
     H <
        T ── HT
start
        H ── TH
     T <
        T ── TT
```

$S = \{HH, HT, TH, TT\}$, so 4 outcomes.

**Three coins:**

$S = \{HHH, HHT, HTH, HTT, THH, THT, TTH, TTT\}$, so $2^3 = 8$ outcomes.

> In general, flipping $n$ coins gives $2^n$ equally likely outcomes.

---

## Example 1 - coins

**(a) Two coins: P(at least one head)?**
Favorable: $\{HH, HT, TH\}$, which is 3 of 4 outcomes.
$$P = \frac34 = 0.75 = 75\%$$

**(b) Three coins: P(at least two tails)?**
Favorable: $\{HTT, THT, TTH, TTT\}$, which is 4 of 8.
$$P = \frac48 = \frac12 = 50\%$$

**(c) Three coins: P(exactly one tail)?**
Favorable: $\{HHT, HTH, THH\}$, which is 3 of 8.
$$P = \frac38 = 0.375 = 37.5\%$$

---

## Example 2 - one six-sided die

$S = \{1, 2, 3, 4, 5, 6\}$

| Event | Favorable outcomes | Probability |
|---|---|---|
| (a) a 2 | {2} | $\tfrac16 \approx 0.167$ (16.7%) |
| (b) a 3 or a 5 | {3, 5} | $\tfrac26 = \tfrac13 \approx 33.3\%$ |
| (c) **at most** 4 ($x \le 4$) | {1, 2, 3, 4} | $\tfrac46 = \tfrac23 \approx 66.7\%$ |
| (d) **greater than** 3 ($x > 3$, so 3 is excluded) | {4, 5, 6} | $\tfrac36 = \tfrac12 = 50\%$ |
| (e) at most 5 ($x \le 5$) | {1, 2, 3, 4, 5} | $\tfrac56 \approx 83.3\%$ |

---

## Key takeaways

- $P(A)$ = favorable ÷ total, when the outcomes are equally likely.
- Every probability is between 0 and 1. Multiply by 100 for a percentage.
- List the **sample space**; a **tree diagram** helps for multi-step experiments.
- Read the wording carefully: "at least", "at most", "greater than" (strict), "exactly".
