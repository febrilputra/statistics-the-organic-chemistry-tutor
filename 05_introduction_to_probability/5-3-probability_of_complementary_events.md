# Lesson 5.3 - Probability of Complementary Events

> **Video:** [Probability of Complementary Events & Sample Space](https://www.youtube.com/watch?v=0T-CaQCiSf4) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Setup - rolling one six-sided die

- Sample space $S = \{1, 2, 3, 4, 5, 6\}$
- $A$ = numbers **at most 4** = $\{1, 2, 3, 4\}$
- $B = \{3, 4, 5\}$

---

## 1. $P(A \text{ and } B)$ - intersection

$A \cap B = \{3, 4\}$ (the outcomes in **both** sets)

$$P(A \text{ and } B) = \frac26 = \frac13 \approx 0.33$$

## 2. $P(A \text{ or } B)$ - union

$A \cup B = \{1, 2, 3, 4, 5\}$ (the outcomes in **either** set; only 6 is missing)

$$P(A \text{ or } B) = \frac56 \approx 0.833 = 83.3\%$$

## 3. $P(A')$ - complement

The **complement** $A'$ is everything in $S$ that is **not** in $A$: $A' = \{5, 6\}$

$$P(A') = \frac26 = \frac13$$

## 4. $P(A)$ and the complement rule

$$P(A) = \frac46 = \frac23$$

$$P(A) + P(A') = \frac23 + \frac13 = 1$$

An event and its complement together cover the whole sample space, so their probabilities add to 1:

$$\boxed{P(A') = 1 - P(A)}$$

---

## Example - marbles

The probability of drawing a **red** marble from a bag is 35%. What is the probability of drawing a marble that is **not red**?

$$P(\text{not red}) = 1 - 0.35 = 0.65 = 65\%$$

---

## Key takeaways

- Intersection ($A$ and $B$) = outcomes in **both**. Union ($A$ or $B$) = outcomes in **at least one**.
- Complement $A'$ = outcomes **not** in $A$.
- $P(A) + P(A') = 1$, so $P(A') = 1 - P(A)$. This is often the fastest route, especially for "at least one" problems.
