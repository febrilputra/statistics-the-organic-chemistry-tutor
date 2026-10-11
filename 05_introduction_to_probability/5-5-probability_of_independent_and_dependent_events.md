# Lesson 5.5 - Probability of Independent and Dependent Events

> **Video:** [Probability - Independent and Dependent Events](https://www.youtube.com/watch?v=lWAdPyvm400) by The Organic Chemistry Tutor
> **Chapter:** [5 - Introduction to Probability](https://www.video-tutor.net/introduction-to-probability.html)

## Definitions

- **Independent events:** the outcome of one does **not** change the probability of the other.
  $$P(A \text{ then } B) = P(A) \cdot P(B)$$
- **Dependent events:** the first outcome **changes** the probability of the second.
  $$P(A \text{ then } B) = P(A) \cdot P(B \mid A)$$

| Drawing marbles... | Type | Why |
|---|---|---|
| **with replacement** | Independent | The marble goes back, so the bag is unchanged |
| **without replacement** | Dependent | The bag has one fewer marble (and maybe one fewer of a color) |

---

## Example - a bag of marbles

| Red | Blue | Green | Yellow | **Total** |
|---:|---:|---:|---:|---:|
| 8 | 7 | 6 | 4 | **25** |

**(a) P(red)**
$$\frac{8}{25} = 0.32 = 32\%$$

**(b) Blue, then green, *with* replacement** (independent)
$$\frac{7}{25} \cdot \frac{6}{25} = \frac{42}{625} = 0.0672 = 6.72\%$$
The blue marble is put back, so there are still 25 marbles and 6 green ones on the second draw.

**(c) Yellow, then red, *without* replacement** (dependent)
$$\frac{4}{25} \cdot \frac{8}{24} = \frac{4}{25} \cdot \frac{1}{3} = \frac{4}{75} \approx 0.0533 = 5.33\%$$
After the yellow marble is removed, only **24** marbles are left (still 8 red).

**(d) Two blue, *with* replacement**
$$\frac{7}{25} \cdot \frac{7}{25} = \frac{49}{625} = 0.0784 = 7.84\%$$

**(e) Two green, *without* replacement**
$$\frac{6}{25} \cdot \frac{5}{24} = \frac{30}{600} = \frac{1}{20} = 0.05 = 5\%$$
After one green marble is removed, there are **5 green** out of **24**.

### Why (b) is independent and (c) is dependent

- In (b), $P(\text{green on draw 2}) = \tfrac{6}{25}$, which is exactly $P(\text{green})$ on its own. The first draw had no effect.
- In (c), $P(\text{red on draw 2}) = \tfrac{8}{24}$ instead of $\tfrac{8}{25}$. The first draw changed it.

---

## Key takeaways

- **With replacement → independent:** multiply the unchanged probabilities.
- **Without replacement → dependent:** after each draw, reduce the total and (if needed) the count of the color drawn.
- "First … then …" problems use the **multiplication rule**.
