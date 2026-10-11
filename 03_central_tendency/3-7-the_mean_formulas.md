# Lesson 3.7 - The Mean Formulas

> **Video:** [Arithmetic Mean, Geometric Mean, Weighted Mean, Harmonic Mean, Root Mean Square Formula](https://www.youtube.com/watch?v=6G6i8vSa8Zs) by The Organic Chemistry Tutor
> **Chapter:** [3 - Central Tendency](https://www.video-tutor.net/central-tendency-and-variation.html)

This lesson covers five kinds of "average", how each relates to a type of sequence, and when to use each.

| Mean | Formula ($n$ values) | Two values $a, b$ |
|---|---|---|
| Arithmetic | $\dfrac{x_1 + \dots + x_n}{n}$ | $\dfrac{a+b}{2}$ |
| Geometric | $(x_1 x_2 \cdots x_n)^{1/n}$ | $\sqrt{ab}$ |
| Weighted | $\dfrac{\sum wx}{\sum w}$ | — |
| Harmonic | $\dfrac{n}{\frac{1}{x_1} + \dots + \frac{1}{x_n}}$ | $\dfrac{2}{\frac1a + \frac1b} = \dfrac{2ab}{a+b}$ |
| Root mean square | $\sqrt{\dfrac{x_1^2 + \dots + x_n^2}{n}}$ | $\sqrt{\dfrac{a^2+b^2}{2}}$ |

---

## 1. Arithmetic mean and arithmetic sequences

An **arithmetic sequence** adds the same **common difference** $d$ each time.

Example: 2, 5, 8, 11, 14, 17, 20 ($d = 3$)

- Mean of all seven terms: $\dfrac{77}{7} = 11$, which is the **middle term** $a_4$.
- The arithmetic mean of two terms equidistant from a middle term gives that middle term:
  - $\dfrac{a_1 + a_3}{2} = \dfrac{2 + 8}{2} = 5 = a_2$
  - $\dfrac{a_1 + a_5}{2} = \dfrac{2 + 14}{2} = 8 = a_3$
  - $\dfrac{a_3 + a_7}{2} = \dfrac{8 + 20}{2} = 14 = a_5$

---

## 2. Geometric mean and geometric sequences

A **geometric sequence** multiplies by the same **common ratio** $r$ each time.

Example: 3, 6, 12, 24, 48, 96, 192 ($r = 2$)

- $\sqrt{a_1 a_3} = \sqrt{3 \cdot 12} = \sqrt{36} = 6 = a_2$
- $\sqrt{a_1 a_5} = \sqrt{3 \cdot 48} = \sqrt{144} = 12 = a_3$
- Geometric mean of all seven terms:
  $$(3 \cdot 6 \cdot 12 \cdot 24 \cdot 48 \cdot 96 \cdot 192)^{1/7} = (4{,}586{,}471{,}424)^{1/7} = 24 = a_4$$
  This is the middle term again.

With $n = 2$, $(x_1x_2)^{1/2}$ is just $\sqrt{ab}$.

---

## 3. Weighted mean

$$\bar x_w = \frac{w_1x_1 + w_2x_2 + \dots + w_nx_n}{w_1 + w_2 + \dots + w_n}$$

Use it when the data points are **not equally important**: center of mass, average atomic mass, concentration of a mixture.

**Example - mixing salt solutions.** 150 mL of 20% NaCl is mixed with 50 mL of 40% NaCl. Here $x$ is the concentration and $w$ is the volume:

$$C = \frac{C_1V_1 + C_2V_2}{V_1 + V_2} = \frac{20(150) + 40(50)}{150 + 50} = \frac{3000 + 2000}{200} = 25\%$$

An equal-weight average would give 30%. There is more of the 20% solution, so the result is pulled toward 20%. With equal volumes (100 mL each), the answer would be exactly 30%.

---

## 4. Harmonic mean and harmonic sequences

The harmonic mean is the **reciprocal of the average of the reciprocals**:

$$H = \left(\frac{\frac{1}{x_1} + \dots + \frac{1}{x_n}}{n}\right)^{-1} = \frac{n}{\sum \frac{1}{x}}$$

A **harmonic sequence** consists of the reciprocals of an arithmetic sequence:

$$\tfrac12, \tfrac15, \tfrac18, \tfrac1{11}, \tfrac1{14}, \tfrac1{17}, \tfrac1{20}$$

(The denominators 2, 5, 8, ... form an arithmetic sequence.)

- $\dfrac{2}{\frac{1}{h_1} + \frac{1}{h_3}} = \dfrac{2}{2 + 8} = \dfrac{1}{5} = h_2$
- $\dfrac{2}{\frac{1}{h_2} + \frac{1}{h_6}} = \dfrac{2}{5 + 17} = \dfrac{1}{11} = h_4$
- All seven terms: $\dfrac{7}{2 + 5 + 8 + 11 + 14 + 17 + 20} = \dfrac{7}{77} = \dfrac{1}{11} = h_4$

### Application - average speed for equal distances

A car drives **400 mi** from A to B at **80 mph**, then returns **400 mi** at **50 mph**. What is its average speed?

**Physics method (total distance ÷ total time):**

- Time out: $\dfrac{400}{80} = 5$ h. Time back: $\dfrac{400}{50} = 8$ h.
- $\bar v = \dfrac{800}{13} \approx 61.54$ mph

**Weighted-mean method (weights = time spent at each speed):**

$$\bar v = \frac{80(5) + 50(8)}{5 + 8} = \frac{800}{13} \approx 61.54 \text{ mph}$$

Or using time fractions: $80\left(\tfrac{5}{13}\right) + 50\left(\tfrac{8}{13}\right) = 80(0.3846) + 50(0.6154) \approx 61.54$ mph. The car spends about 38.5% of the time at 80 mph and about 61.5% at 50 mph.

**Harmonic-mean method:**

$$\bar v = \frac{2}{\frac{1}{80} + \frac{1}{50}} = \frac{2(80)(50)}{80 + 50} = \frac{8000}{130} = \frac{800}{13} \approx 61.54 \text{ mph}$$

The arithmetic mean (65 mph) is **wrong** here. The car spends **more time** at the slower speed, so the true average is closer to 50.

> When **equal distances** are covered at different speeds, the average speed is the **harmonic mean** of the speeds.

---

## 5. Root mean square (RMS)

"Root" = square root, "square" = square the values:

$$x_{\text{RMS}} = \sqrt{\frac{x_1^2 + x_2^2 + \dots + x_n^2}{n}}$$

**Example.** 5, 8, 12, 16, 21

$$\sqrt{\frac{25 + 64 + 144 + 256 + 441}{5}} = \sqrt{\frac{930}{5}} = \sqrt{186} \approx 13.64$$

---

## 6. Comparing the four means

**Example.** $a = 10$, $b = 20$

| Mean | Calculation | Value |
|---|---|---:|
| Harmonic $H$ | $\dfrac{2(10)(20)}{30} = \dfrac{40}{3}$ | 13.33 |
| Geometric $G$ | $\sqrt{200} = 10\sqrt2$ | 14.14 |
| Arithmetic $A$ | $\dfrac{30}{2}$ | 15 |
| RMS $R$ | $\sqrt{\dfrac{100 + 400}{2}} = \sqrt{250} = 5\sqrt{10}$ | 15.81 |

$$H \le G \le A \le R$$

**Relationships between the three classical means:**

$$G = \sqrt{A \cdot H}, \qquad H = \frac{G^2}{A}, \qquad A = \frac{G^2}{H}$$

Check: $\sqrt{15 \cdot \tfrac{40}{3}} = \sqrt{200} = 10\sqrt2 = G$ ✓

If you know any two of $A$, $G$, $H$, you can find the third.

---

## Key takeaways

- **Arithmetic mean:** equal weights. It gives the middle term of an arithmetic sequence.
- **Geometric mean:** multiply, then take the $n$-th root. It gives the middle term of a geometric sequence.
- **Weighted mean:** use when the values carry different importance (volume, time, credits).
- **Harmonic mean:** average of rates over **equal distances** (or equal amounts). It gives the middle term of a harmonic sequence.
- **RMS:** square, average, then square root. It is the largest of the four.
- $H \le G \le A \le R$ and $G^2 = A \cdot H$.
