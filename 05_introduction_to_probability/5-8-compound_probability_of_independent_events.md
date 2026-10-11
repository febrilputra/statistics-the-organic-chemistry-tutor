# Lesson 5.8 - Compound Probability of Independent Events

> **Video:** [Compound Probability of Independent Events - Coins & 52 Playing Cards](https://www.youtube.com/watch?v=EHU6pVSczb4) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Rule

For **independent** events, multiply:

$$P(A \text{ and } B) = P(A) \cdot P(B)$$

---

## Example 1 - coins

**(a) Two heads in two flips**
$$P(HH) = \frac12 \cdot \frac12 = \frac14$$
Check with the sample space $\{HH, HT, TH, TT\}$: 1 of 4 outcomes ✓

**(b) Heads, tails, heads, in that order, in three flips**
$$P(HTH) = \left(\frac12\right)^3 = \frac18$$
Only 1 of the 8 outcomes ($HHH, HHT, HTH, HTT, THH, THT, TTH, TTT$) matches.

**(c) Two tails and one head, in any order**
The matching outcomes are $HTT$, $THT$, $TTH$:
$$P = \frac38$$

> **Does order matter?** In (b) a specific sequence is required, so only one outcome counts. In (c) any arrangement counts, so add up all the matching outcomes.

---

## A standard 52-card deck

| Suit | Color | Cards |
|---|---|---|
| ♦ Diamonds | Red | A, 2-10, J, Q, K (13) |
| ♥ Hearts | Red | 13 |
| ♠ Spades | Black | 13 |
| ♣ Clubs | Black | 13 |

- 4 suits × 13 = **52** cards; **26 red**, **26 black**; no jokers.
- Each rank (e.g. queen) appears **4** times, once per suit.

---

## Example 2 - cards

**(a) P(queen)**
$$\frac{4}{52} = \frac{1}{13} \approx 0.0769 = 7.69\%$$

**(b) P(black card numbered greater than 3 and at most 9)**
The numbers are 4, 5, 6, 7, 8, 9 (6 values), and there are two black suits (♠ and ♣):
$$\frac{6 \times 2}{52} = \frac{12}{52} = \frac{3}{13}$$

**(c) P(red king first, then a diamond), *without* replacement**

This is **dependent**: how many diamonds are left depends on *which* red king was drawn. Split it into two cases and add them (the cases are mutually exclusive):

| Case | First card | Second card | Probability |
|---|---|---|---|
| 1 | King of ♥ ($\tfrac{1}{52}$) | any ♦; all 13 are still there ($\tfrac{13}{51}$) | $\tfrac{1}{52} \cdot \tfrac{13}{51} = \tfrac{1}{204}$ |
| 2 | King of ♦ ($\tfrac{1}{52}$) | any ♦; only 12 are left ($\tfrac{12}{51}$) | $\tfrac{1}{52} \cdot \tfrac{12}{51} = \tfrac{1}{221}$ |

$$P = \frac{1}{204} + \frac{1}{221} = \frac{13}{2652} + \frac{12}{2652} = \frac{25}{2652} \approx 0.0094$$

(Common denominator: $2652 = 4 \cdot 3 \cdot 13 \cdot 17$.)

> Writing $P(\text{red king}) \times P(\text{diamond}) = \tfrac{2}{52} \times \tfrac{13}{51}$ would be **wrong**, because the second probability depends on which king was taken.

---

## Key takeaways

- Independent events: multiply the probabilities. $n$ fair coin flips in a specific order: $(1/2)^n$.
- "In any order" → count all the arrangements that work.
- Without replacement → dependent. If the second probability depends on *which* first outcome happened, split into cases and add.
