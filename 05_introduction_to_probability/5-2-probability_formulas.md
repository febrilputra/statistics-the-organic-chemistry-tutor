# Lesson 5.2 - Probability Formulas

> **Video:** [Probability Formulas, Symbols & Notations - Marginal, Joint, & Conditional Probabilities](https://www.youtube.com/watch?v=bddckR734aM) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

This lesson collects the main probability formulas and symbols in one place. All examples use this setup:

- Sample space $S = \{1, 2, 3, 4, 5, 6, 7, 8, 9\}$
- $A = \{1, 2, 3, 4\}$, $\quad B = \{6, 7, 8\}$, $\quad C = \{1, 7, 8, 9\}$

---

## 1. Marginal probability - a single event

The probability of **one** event, regardless of any others:

$$P(A) = \frac{\text{favorable outcomes}}{\text{total outcomes}}$$

- $P(A) = \tfrac49 \approx 0.444$ (44.4%)
- $P(B) = \tfrac39 = \tfrac13 \approx 0.333$ (33.3%)
- $P(C) = \tfrac49 \approx 0.444$ (44.4%)

---

## 2. Union and intersection symbols

| Symbol | Name | Meaning | Example |
|---|---|---|---|
| $A \cup B$ | Union | Everything in $A$ **or** $B$ (or both), listed once | $B \cup C = \{1, 6, 7, 8, 9\}$ |
| $A \cap B$ | Intersection | Only what is in **both** $A$ **and** $B$ | $B \cap C = \{7, 8\}$ |

$A \cap B = \varnothing$ (no shared elements), so $A$ and $B$ are **mutually exclusive**.

---

## 3. Union probability - "A or B" (addition rule)

$$P(A \text{ or } B) = P(A \cup B) = P(A) + P(B) - P(A \text{ and } B)$$

The subtraction stops the overlap from being counted **twice**.

**Mutually exclusive events** can't happen together, so $P(A \text{ and } B) = 0$:

$$P(A \text{ or } B) = P(A) + P(B)$$

**Example - $A$ or $B$ (mutually exclusive):** $A \cup B = \{1, 2, 3, 4, 6, 7, 8\}$

$$P(A \cup B) = \frac79 \approx 0.778 \quad\left(= \tfrac49 + \tfrac39\right)$$

**Example - $B$ or $C$ (they overlap at 7 and 8):**

$$P(B \cup C) = \frac39 + \frac49 - \frac29 = \frac59$$

Check by listing: $B \cup C = \{1, 6, 7, 8, 9\}$ has 5 elements → $\tfrac59$ ✓. Without subtracting $\tfrac29$, the 7 and 8 would be counted twice.

**Venn diagrams:**

```
  A and B (mutually exclusive)          B and C (overlapping)
   ┌───────┐   ┌───────┐              ┌───────┬───┬───────┐
   │1 2 3 4│   │ 6 7 8 │              │   6   │7 8│ 1  9  │
   └───────┘   └───────┘              └───────┴───┴───────┘
       A           B                      B only  B∩C  C only
```

> **Word cue:** "**or**" → **addition** rule. "**and**" → **multiplication** rule.

---

## 4. Joint probability - "A and B" (multiplication rule)

The probability that $A$ and $B$ both happen:

$$P(A \text{ and } B) = P(A \cap B) = P(A \mid B)\,P(B) = P(B \mid A)\,P(A)$$

**Independent events** (one does not affect the other): $P(A \mid B) = P(A)$ and $P(B \mid A) = P(B)$, so

$$P(A \text{ and } B) = P(A)\,P(B)$$

### Independent or dependent?

| Situation | Type | Why |
|---|---|---|
| Draw a red marble, **put it back**, then draw a blue one | **Independent** | Replacing the marble restores the bag |
| Draw a red marble, **keep it**, then draw a blue one | **Dependent** | The bag now has one fewer marble, so the second probability changes |
| Toss a coin twice | **Independent** | The first toss doesn't affect the second |

### Notation warning: $P(A \text{ and } B)$ vs $P(AB)$

- $P(A \text{ and } B) = P(B \text{ and } A)$: both happen, no order implied.
- Some books write $P(AB)$ for "**$A$ first, then $B$**" and $P(BA)$ for "**$B$ first, then $A$**". These are **not always equal**.
- Read the context: are the events **simultaneous**, or does one come **before** the other?

---

## 5. Conditional probability - "A given B"

$P(A \mid B)$ is the probability of $A$ **given that $B$ has already happened**:

$$P(A \mid B) = \frac{P(A \text{ and } B)}{P(B)}, \qquad P(B \mid A) = \frac{P(A \cap B)}{P(A)}$$

Conditional = joint ÷ marginal.

---

## 6. Bayes' theorem

Replacing $P(A \text{ and } B)$ with $P(B \mid A)\,P(A)$ from the multiplication rule gives

$$P(A \mid B) = \frac{P(B \mid A)\,P(A)}{P(B)}$$

It is the conditional probability formula with the joint probability rewritten.

---

## 7. Negation (complement) probability

$$P(A') = P(\text{not } A) = 1 - P(A)$$

(Also written $A^c$, $\bar A$ or $\sim A$.)

- $P(A') = 1 - \tfrac49 = \tfrac59$. Check: $S$ has 5 elements outside $A$ (5, 6, 7, 8, 9) ✓
- If $P(B) = 0.35$, then $P(B') = 1 - 0.35 = 0.65$, a 65% chance that $B$ does not occur.

This works because the total probability of all outcomes is 1.

---

## Formula summary

| Type | Formula |
|---|---|
| Marginal | $P(A) = \dfrac{\text{favorable}}{\text{total}}$ |
| Union (or) | $P(A \cup B) = P(A) + P(B) - P(A \cap B)$ |
| Union, mutually exclusive | $P(A \cup B) = P(A) + P(B)$ |
| Joint (and) | $P(A \cap B) = P(A \mid B)P(B) = P(B \mid A)P(A)$ |
| Joint, independent | $P(A \cap B) = P(A)P(B)$ |
| Conditional | $P(A \mid B) = \dfrac{P(A \cap B)}{P(B)}$ |
| Bayes | $P(A \mid B) = \dfrac{P(B \mid A)P(A)}{P(B)}$ |
| Complement | $P(A') = 1 - P(A)$ |
