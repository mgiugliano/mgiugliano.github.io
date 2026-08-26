---
title: "Your Post Title Here"
date: 2026-08-26
tags: neuroscience, modelling
---

Write your opening paragraph here — this is the lede that pulls readers in.

## A section heading

Regular prose goes here. You can **bold**, *italicize*, and [link to things](https://example.com).

## Adding an image

Drop the image file into `static/images/` (see `static/images/README.md`),
then reference it with a domain-absolute path so it resolves correctly no
matter how deep the page lives:

![Caption describing the image](/static/images/your-file.jpg)

## Writing equations

Math is powered by MathJax, which only loads on pages that actually contain
equations — ordinary posts pay no cost for it. Standard LaTeX syntax works.

Inline, e.g. the membrane time constant $\tau_m = R_m C_m$, sits right in a
sentence.

Display style, e.g. the leaky integrate-and-fire model:

$$
C_m \frac{dV}{dt} = -\frac{V - V_{rest}}{R_m} + I(t)
$$

## Code, if you need it

```python
def spike_times(v, threshold):
    return [t for t, x in enumerate(v) if x > threshold]
```
