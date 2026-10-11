# Lesson 10.1 - Hypothesis Testing - Null and Alternative Hypotheses

> **Video:** [Hypothesis Testing - Null and Alternative Hypotheses](https://www.youtube.com/watch?v=wiYJWyfdGg4) by The Organic Chemistry Tutor
> **Chapter:** [10 - Hypothesis Testing - 1 Sample](https://www.video-tutor.net/hypothesis-testing-with-one-sample.html)

## The two hypotheses

| | Null hypothesis $H_0$ | Alternative hypothesis $H_a$ (or $H_1$) |
|---|---|---|
| What it is | The **status quo**: the currently accepted value or claim | The **challenger**: what the researcher is trying to show |
| Sign | Contains the **equality**: $=$, $\le$, $\ge$ | **Strict** inequality: $\ne$, $<$, $>$ |

The researcher tries to gather enough evidence to **reject** $H_0$ in favor of $H_a$.

> **Careful wording:** if the evidence isn't strong enough, we **fail to reject** $H_0$. That doesn't prove $H_0$ is true, or even that it is "likely" true. It only means the data didn't rule it out.

## Steps

1. **Mean or proportion?**
   - "average", "mean" → population mean $\mu$
   - "percent", "proportion", "fraction" → population proportion $p$, written as a decimal (80% → 0.80)
2. **Find the accepted value** (the status quo) and write $H_0$ with the equality.
3. **Find what the researcher suspects** and write $H_a$ with the strict inequality. Together, $H_0$ and $H_a$ cover every possibility.

| Wording | $H_0$ | $H_a$ |
|---|---|---|
| "is different from", "is not" | $=$ | $\ne$ |
| "at least", "no less than" | $\ge$ | $<$ |
| "at most", "no more than" | $\le$ | $>$ |

---

## Examples

**1. Calculator mass.** Company XYZ's calculators average **450 g**. An engineer thinks the average is different and weighs 50 calculators.
$$H_0: \mu = 450 \qquad H_a: \mu \ne 450$$
("Average" means a mean.)

**2. Graduation rate.** Teachers believe **at least 80%** of students graduate. A student disagrees.
$$H_0: p \ge 0.80 \qquad H_a: p < 0.80$$
("Percent" means a proportion. "At least 80%" means 80% or more.)

**3. GPA.** A teacher wants to test whether the mean GPA is **different from 2.7**. Here it is easier to start with $H_a$, the teacher's claim.
$$H_0: \mu = 2.7 \qquad H_a: \mu \ne 2.7$$

**4. Vehicle ownership.** The share of residents who own a vehicle is **no more than 75%**. A researcher disagrees and surveys 100 residents.
$$H_0: p \le 0.75 \qquad H_a: p > 0.75$$
("No more than" means ≤. Surveying 100 residents gives the sample size, which is not part of either hypothesis.)

---

## Key takeaways

- $H_0$ = status quo with the equality ($=$, $\le$, $\ge$). $H_a$ = the claim being tested, with a strict sign ($\ne$, $<$, $>$).
- Hypotheses are about **population parameters** ($\mu$ or $p$), never about sample values like $\bar x$ or $\hat p$.
- Translate the wording carefully: "at least" → $\ge$, "no more than" → $\le$, "different" → $\ne$.
