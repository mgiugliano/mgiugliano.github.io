---
title: Signal strengths in Engineering and HAM Radio
date: 2026-09-06
tags: hobbies, engineering, radio, signals
---

# From an Antenna to engineering conventions

During the last weekend, I spent a fantastic time together with a group of friends from my (ARI) radio club in Trieste, Italy. I joined them on the Carso hills, in Basovizza, not too far from the Italian border with Slovenia. We spent an entire day participating to the Field Day contest which is a sort of competition where amateurs go outdoor and mount temporary antennas and transceivers and try to establish as many contacts possible with other stations. 

During the dinner, a friend posed me a question that I could not answer confidently immediately, despite I am in theory still an engineer at heart! My math and signal theory were rust and I could not give a straight answer.

Today, I have brushed off some of the dust and I did review the basics. I note them down here for the benefit of whoever is reading this post.

## 1. Where the signal actually comes from

At the antenna, in this case a FD4 dipole-like wire antenna mounted at its center on a telescopic mast, the incoming radio waves induce a tiny, rapidly oscillating **voltage**, $v(t)$, at the input of the receiver relayed through the coaxial cable. This is a real, physical, and time-varying quantity.

When engineers and OMs (i.e. "Old Men", a short slang for ham radio operators) reports how strong a received signal is to the other party, they are basically referring to the real physical quantity known as *power*. This is referred to the power at the input stage of the radio, which can be approximated as a simple resistor $R$ (i.e. the input **resistance** of a device which is basically an amplifier). Almost universally devices operating with RF have a $50~\Omega$ equivalent input resistance, so that by the definition of the *power* dissipated by a resistive load, the power of the received signal is

$$
p(t) = v(t) \cdot i(t) = \frac{v(t)^2}{R}
$$

In the previous expression $i(t)$ was written as $v(t)/R$, following the Ohm's law: $v(t)\ =\ R\ i(t)$ Because the $50~\Omega$ convention is shared by RF equipment, coax cables, antennas, etc. there is no ambiguity and we can immediately express the power of the signal, if we know $v(t)$.
By definition, $p(t)$ is measured in $Watt$ (which is the product of $Volt$ and $Ampere$).


## 2. A wiggling signal has no single "power"

Because $v(t)$ oscillates positive and negative, $p(t)$ also fluctuates over time. It should be then better called the **instantaneous power**, and therefore it is not a single value than can be written down on a notepad. To get something usable, engineers (and ham radio enthusiasts) calculate first an average numerical value (over a time interval) and then work with that.

Assume, as a simplification, that we're dealing with a single sinusoidal tone (a pure carrier). So we gave up the description of a generic and complicated waveform $v(t)$. We stick to just a single tone, which we can first write by its definition as a mathematical expression 

$$
v(t) = V_{peak}\sin(2\pi f t)
$$

where $V_{peak}$ is the peak amplitude, $f$ is the oscillating frequency and $t$ is time. When we say that *we want to compute the average power*, we usually mean we want to average the power of that sinusoidal function across one period of oscillation. 

Then:

$$
p(t) = \frac{v(t)^2}{R} = \frac{V_{peak}^2 \sin^2(2\pi f t)}{R}
$$

to be averaged over one full period $T = 1/f$ that is

$$
P_{avg} = \frac{1}{T}\int_0^T \frac{V_{peak}^2 \sin^2(2\pi f t)}{R}\, dt
$$

I do not want to open a parenthesis on Calculus and integrals, but I ignore for a moment the specific value of $V_{peak}$ and of $R$ (which are both constant with respect to time and can be moved out of the sign of integral). In fact we can change variables ($x\ = 2\pi f t$) and we end up with the following (well known) definite integral 

$$
\frac{1}{2\pi}\int_0^{2\pi} \sin^2(x) dx = \frac{1}{2}
$$

This can be done once for all by parts and it is highly related to the expression of the average power, by a simple change of variable.
Then, we can write:

$$
P_{avg} = \frac{V_{peak}^2}{2R}
$$


## 3. Why RMS, and why $\sqrt{2}$

Engineers are simple minded,  unlike physicists. They just want to a formula that *looks* like the plain expression derived for the DC case by the Ohm's law, $P = V^2/R$ even if they are no longer working on the DC regime: it is an AC regime, strictly speaking. For some mysterious reason, they do not want to remember the extra factor of $\tfrac12$ floating around. So they define an effective ("DC-like") constant voltage, called $V_{RMS}$ (root mean square), such that:

$$
\frac{V_{RMS}^2}{R} = P_{avg} = \frac{V_{peak}^2}{2R}
$$

Instead of dealing with $V_{peak}$ from now on, they just work with $V_{RMS}$ regardless of the frequency $f$ and they treat it as if it was a DC current.

Solving, we get

$$
V_{RMS}^2 = \frac{V_{peak}^2}{2} \quad\Rightarrow\quad V_{RMS} = \frac{V_{peak}}{\sqrt{2}}
$$

$V_{RMS}$ is therefore a purely mathematical operation on a given time-varying waveform: square it, average it, take the square root, called "root‑mean‑square". It has of course the *same physical units* as the original signal (volts stay volts, but you could apply this also to other signals, such as currents and in that case amps stay amps). The resistance $R$ only re-enters afterward, when you actually want to convert that RMS voltage into a power.

So the full chain, cleanly separated:

1. $v(t) \to V_{RMS}$ — a voltage, via the RMS operation (no $R$ involved).
2. $V_{RMS} \to P_{avg} = V_{RMS}^2 / R$ — a power, once you commit to a reference $R$ (50 Ω in RF work).


## 4. From watts to decibels: dBm and dBW

Up to this point, everything is rigorous, except in my humble opinion the definition of $V_{RMS}$ sounds like an arbitrary choice (and it is!) despite being mnemonically useful. These are all arbitrary conventions and choices, where there is very little to understand. 

Let's go back to the initial problem. In the case of RF communications, one operator might want to classify incoming received signals as *weak*, *strong*, *very strong*, etc. in a more rigorous way. Challenged with the same task, a physicist would have probably stopped here, using $p(t)$ or maybe better $P_{avg}$. They would have been perfectly happy expressing this as a single number (since $R\ =\ 50~\Omega$) and express it in Watt,

However, the received voltages $v(t)$ from an antenna span an enormous dynamic range, from picoVolt to kiloVolt. And a very similar situation would have occurred for expressing the power in Watt, from picowatt to kilowatt. Absolute power in watts is unwieldy. Imagine having to say to the other party on the radio: I receive you with a power of $0.0000034 Watt$ ($3.4~\mu W$). It is already quite messy and difficult to have the other person understand our call sign, forget about spelling "micro Watt", "milli Watt", half "pico Watt", etc. 

There is another annoyance: gains/losses through amplifiers, cables, and filters multiply rather than add. While this perfectly fits with the intuition (i.e., an amplifier makes a signal *10 times stronger* or *that kind of coax cable attenuates the signal by 50%*), going from micro Watt to the consequences of a chain of multiplicative gains or attenuations requires to have a calculator handy, as very few people can make mental arithmetics with too many decimal digits.

Engineers then introduced the (arbitrary!) concept of **decibel**, which uses the *logarithmic scale* instead of the usual linear one. This means that the labels on the axis of a cartesian plot are no longer equally spaced when going from $10~mW$, $20~mW$, $30~mW$, etc. There is some sort of compression.
The decibel fixes also the problem of *multiplicative* gains/attenuations that becomes *addition/subtractions& instead of *multiplications/divisions*.

But the most important concept behind decibel is that they are quantities conveyed with respect to a conventional value, that has been chosen as a reference.
This is not too different from when we say "a couple of degrees below freezing".

$$
P_{dBm} = 10 \log_{10}\left(\frac{P_{mW}}{1\ \text{mW}}\right)
$$

This is **dBm**: decibels relative to one milliwatt. Its cousin, **dBW**, uses instead one watt as the reference instead:

$$
P_{dBW} = 10 \log_{10}\left(\frac{P_{W}}{1\ \text{W}}\right)
$$

Since $1\ \text{W} = 1000\ \text{mW}$, the two are related by a fixed offset:

$$
P_{dBm} = P_{dBW} + 30
$$

Correct nomenclature note: it's **dBm** and **dBW** — not "dBmW."

The **factor of 10** (rather than 20) is used here because we're taking the ratio of two *powers* directly.

For instance, if the power is *10 times* the reference value (i.e., that sits at the denominator), then with this convention the converted power is 10.
If it is *100 times* the reference value, the conventions says 20. If it's *0.1 times* then the convention says -10, or  *0.01 times* then the convention says -20. $0~dBm$ of course correspond exactly to the reference $1~mW$.




## 5. Voltage-referenced decibels: dBV and dBµV

If you want to express a *voltage* ratio directly (common in audio electronics and RF field-strength meters) rather than going through power, you use:

$$
V_{dBV} = 20 \log_{10}\left(\frac{V_{RMS}}{1\ \text{V}}\right)
$$

Here the multiplier is **20, not 10** — because power goes as voltage *squared*, so squaring inside the log is equivalent to doubling the multiplier outside:

$$
10\log_{10}\left(\frac{V^2}{V_{ref}^2}\right) = 20\log_{10}\left(\frac{V}{V_{ref}}\right)
$$

**dBµV** (referenced to one microvolt) is the RF-world cousin of dBV, commonly seen on signal generators and field-strength meters.

Again, not that much to understand but only reasonable conventions to accept.


## 6. The ham radio S-meter: an old label on the same underlying scale

Now the "beefy" part of the question of my friend. The S-meter reading on modern radios (S0–S9, then "S9 + N dB") is not using a separate physical quantity but rather an historically fixed, coarse mapping onto the same dBm scale described above.

By long-standing convention:

- **S9 ≈ −73 dBm**
- Each S-unit step ≈ **6 dB**
- So **S1 ≈ −73 − (8 × 6) = −121 dBm**

Therefore, *S9* corresponds approximately to $50~nW$ and *S1* to $0.08~pW$, which is six orders of magnitude smaller. Radios are doing an incredible job, but it is immensely remarkable that antennas can pick up these minuscule fluctuations! 

Above S9, rather than inventing S10, S11, etc., operators simply switch to "S9 plus so many dB" — e.g., "S9+20" means roughly $-73 + 20 = -53\ \text{dBm}$.

**Why −73 dBm for S9, specifically?** There's no deep physical reason. It was chosen historically as a practical "strong, full-scale" reference point for analogue S-meters. The 6 dB/unit spacing was instead picked because it corresponds roughly to a doubling of voltage, which is a convenient, perceptually sensible step for meter calibration. It is therefore purely convention, not first principles.

So the honest answer to the original question on *why do hams say "5 by 9" instead of just quoting dB?* is that **it's the same dBm physics underneath** and  S-units are simply an older, coarser, historically fixed label painted on top of it. Fields that never adopted that historical layer just speak in dB directly.


## 7. A different kind of number: signal-to-noise ratio (FT8/WSJT)

Digital modes like **FT8**, reported via **WSJT-X** software, report a completely different quantity: **signal-to-noise ratio (SNR)** in dB, *not* absolute power. Note that being a ratio, it has no physical units!

$$
SNR_{dB} = 10\log_{10}\left(\frac{P_{signal}}{P_{noise}}\right)
$$

To get $P_{noise}$, the software measures the average power in a chunk of spectrum near, but not on top of, the signal's tone, treats that as the noise floor, and compares the signal's power against it, normalized to a standard reference bandwidth. This lets operators compare reports meaningfully across different radios, antennas, and band conditions, since it factors out absolute gain differences.

## 8. The acoustics analogy: sound pressure level

The same 10-vs-20 logic reappears in psychoacoustics and hearing-safety limits. **Sound pressure** is an amplitude quantity (like voltage), while **sound intensity** (acoustic power) goes as pressure squared (like electrical power). So sound pressure level uses:

$$
L_p = 20\log_{10}\left(\frac{p_{RMS}}{p_0}\right), \qquad p_0 = 20\ \mu\text{Pa}
$$

with $p_0 = 20\ \mu\text{Pa}$ being roughly the quietest sound a healthy human ear can detect at 1 kHz. This is the exact same amplitude-vs-power reasoning that gives dBV its factor of 20 rather than 10.

## 9. In closing

A decibel is **never an absolute unit** but rather a logarithmic *ratio* between two quantities of the same kind. What changes from context to context is only:

- **the reference** (1 mW, 1 W, 1 V, 1 µV, 20 µPa, or a locally measured noise floor), and
- **the multiplier** (10 for power ratios, 20 for amplitude ratios, since power ∝ amplitude²).

Everything else, like S-meters, FT8 reports, audio levels, hearing-safety limits, is the same handful of ideas, wearing different historical "mask".

