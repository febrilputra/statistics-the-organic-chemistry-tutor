# Lesson 5.11 - Bayes' Theorem of Probability with Tree Diagrams

> **Video:** [Bayes' Theorem of Probability With Tree Diagrams & Venn Diagrams](https://www.youtube.com/watch?v=OByl4RJxnKA) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Deriving Bayes' theorem

Start from two conditional probabilities:

$$P(A \mid B) = \frac{P(A \cap B)}{P(B)}, \qquad P(B \mid A) = \frac{P(A \cap B)}{P(A)}$$

Both give the same joint probability:

$$P(A \mid B)\,P(B) = P(A \cap B) = P(B \mid A)\,P(A)$$

Divide by $P(B)$:

$$\boxed{P(A \mid B) = \frac{P(B \mid A)\,P(A)}{P(B)}}$$

Bayes' theorem gives a conditional probability when you know the **reverse** one, $P(B \mid A)$.

---

## Example 1 - slips of paper (checking the formula)

A bottle holds slips numbered 1-9, each equally likely to be drawn.
$A = \{1, 2, 3, 4, 5\}$, $\;B = \{4, 5, 6, 7, 8, 9\}$, $\;A \cap B = \{4, 5\}$

Venn regions: $A$ only = {1, 2, 3}; both = {4, 5}; $B$ only = {6, 7, 8, 9}.

- $P(A) = \tfrac59$, $\;P(B) = \tfrac69$
- $P(B \mid A)$: of $A$'s 5 numbers, 2 are in $B$, so $\tfrac25$

**Using Bayes:**
$$P(A \mid B) = \frac{\frac25 \cdot \frac59}{\frac69} = \frac{2/9}{6/9} = \frac26 = \frac13$$

**Check with the direct formula:**
$$P(A \mid B) = \frac{P(A \cap B)}{P(B)} = \frac{2/9}{6/9} = \frac13 \;✓$$

---

## Example 2 - medical screening

- 12% of men develop prostate cancer: $P(C) = 0.12$
- With cancer, the test is positive 95% of the time: $P(+ \mid C) = 0.95$
- Without cancer, there is a 6% false-positive rate: $P(+ \mid C') = 0.06$

**Find $P(C \mid +)$**, the chance of having cancer given a positive test.

### Step 1 - tree diagram

```
                 0.95  positive   →  0.12 × 0.95 = 0.1140
        C  <
 0.12 /          0.05  negative   →  0.12 × 0.05 = 0.0060
start
 0.88 \          0.06  positive   →  0.88 × 0.06 = 0.0528
        C' <
                 0.94  negative   →  0.88 × 0.94 = 0.8272
```

### Step 2 - total probability of a positive test

A positive result happens through either branch, so add them:

$$P(+) = P(C)P(+ \mid C) + P(C')P(+ \mid C') = 0.1140 + 0.0528 = 0.1668$$

### Step 3 - Bayes

$$P(C \mid +) = \frac{P(+ \mid C)\,P(C)}{P(+)} = \frac{0.95 \times 0.12}{0.1668} = \frac{0.114}{0.1668} \approx 0.683$$

A man with a positive test has about a **68.3%** chance of having cancer, so about **31.7%** of positive results are false alarms ($1 - 0.683$).

### Same answer with counts (imagine 10,000 men)

| | Positive | Negative | Total |
|---|---:|---:|---:|
| Cancer (12%) | 1,140 | 60 | 1,200 |
| No cancer (88%) | 528 | 8,272 | 8,800 |
| **Total** | **1,668** | 8,332 | 10,000 |

$$P(C \mid +) = \frac{1140}{1140 + 528} = \frac{1140}{1668} \approx 0.683 \;✓$$

The choice of 10,000 doesn't matter, because only the ratio counts.

---

## Key takeaways

- $P(A \mid B) = \dfrac{P(B \mid A)P(A)}{P(B)}$, which turns a known conditional probability around.
- The denominator often has to be built from a tree: $P(B) = P(B \mid A)P(A) + P(B \mid A')P(A')$.
- A positive test does **not** guarantee the condition. Rare conditions plus false positives can produce many false alarms.
- Converting to counts (e.g. 10,000 people) is an easy way to check the answer.
