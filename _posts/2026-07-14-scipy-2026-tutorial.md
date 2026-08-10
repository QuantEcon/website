---
layout: post
title: "Tutorial: Computational Methods for Simulation at SciPy 2026"
author: Matt McKay
excerpt: "QuantEcon delivered a four-hour tutorial on accelerating simulations with NumPy and JAX at SciPy 2026 in Minneapolis."
tag: [workshop]
---

Google Engineer [Smit Lunagariya](https://smit-create.github.io/intro.html), a QuantEcon Ambassador, delivered a four-hour tutorial on **Computational Methods for Simulation using JAX and NumPy** at [SciPy 2026](https://www.scipy2026.scipy.org/), held at the University of Minnesota in Minneapolis, on July 14, 2026.

The tutorial uses Thomas Schelling's segregation model as its running example — a classic demonstration of how mild individual preferences can lead to extreme aggregate outcomes — and works through how to turn readable but slow Python code into a high-performance simulation:

1. **The basic model** — the dynamics of segregation implemented with Python classes
2. **NumPy implementation** — rewriting the model with arrays and functions for clarity and speed
3. **JAX implementation** — translating the model to JAX syntax and concepts
4. **Further parallelization** — exploiting modern parallel hardware such as GPUs

The techniques carry over to other settings that rely on large-scale simulation, including urban planning and epidemiology.

The materials were prepared by [John Stachurski](https://johnstachurski.net/), [Thomas J. Sargent](http://www.tomsargent.com/), [Smit Lunagariya](https://smit-create.github.io/intro.html), and [Matt McKay](https://github.com/mmcky).

All tutorial materials are freely available [online](https://quantecon.github.io/scipy_tutorial_2026/) and on [GitHub](https://github.com/QuantEcon/scipy_tutorial_2026), including notebooks that can be run on Google Colab with no local setup.
