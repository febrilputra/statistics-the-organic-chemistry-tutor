# Lesson 5.6 - Probability of Mutually Exclusive Events with Venn Diagrams

> **Video:** [Probability of Mutually Exclusive Events With Venn Diagrams](https://www.youtube.com/watch?v=X6usGgwXFyU) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Definition

Events $A$ and $B$ are **mutually exclusive** if they **cannot happen at the same time**, meaning they share **no outcomes**:

$$A \cap B = \varnothing \quad\Longleftrightarrow\quad P(A \text{ and } B) = 0$$

**Venn diagram:** mutually exclusive events are drawn as **separate, non-overlapping** circles. Events that are not mutually exclusive are drawn as **overlapping** circles.

---

## Testing for mutual exclusivity

One die, $S = \{1, 2, 3, 4, 5, 6\}$:

- $A = \{1, 2, 3\}$, $\;B = \{5, 6\}$, $\;C = \{3, 4, 5\}$

| Pair | Intersection | $P(\text{both})$ | Mutually exclusive? |
|---|---|---|---|
| $A$, $B$ | $\varnothing$ | 0 | **Yes** |
| $A$, $C$ | {3} | 1/6 | No |
| $B$, $C$ | {5} | 1/6 | No |

> **Rule:** if $P(A \text{ and } B) = 0$, they are mutually exclusive. If it is anything other than 0, they are not.

---

## The addition rule

**General (always works):**
$$P(A \text{ or } B) = P(A) + P(B) - P(A \text{ and } B)$$

**Mutually exclusive (the last term is 0):**
$$P(A \text{ or } B) = P(A) + P(B)$$

---

## Example 1 - overlapping events

$A = \{1, 2, 3, 4\}$, $\;B = \{3, 4, 5\}$. They share 3 and 4, so they are **not** mutually exclusive.

Venn diagram regions: $A$ only = {1, 2}, both = {3, 4}, $B$ only = {5}, outside both = {6}.

$$P(A \text{ or } B) = \frac46 + \frac36 - \frac26 = \frac56$$

Without subtracting $\tfrac26$ you would get $\tfrac76$, which is more than 1 and therefore impossible. The subtraction removes the double-counted 3 and 4.

**Check:** $A \cup B = \{1, 2, 3, 4, 5\}$, which is 5 of 6 outcomes ✓

---

## Example 2 - mutually exclusive events

$B = \{3, 4, 5\}$, $\;C = \{6\}$. They share nothing, so they are mutually exclusive and the circles don't overlap.

$$P(B \text{ or } C) = \frac36 + \frac16 - 0 = \frac46 = \frac23$$

---

## Key takeaways

- Mutually exclusive = no shared outcomes = $P(A \cap B) = 0$ = non-overlapping circles.
- Use $P(A) + P(B) - P(A \cap B)$ in general. For mutually exclusive events it simplifies to $P(A) + P(B)$.
- A probability above 1 is a sign that an overlap was counted twice.
