---
layout: post
title: "New Julia Lecture: Differentiable Simulations with Enzyme"
author: QuantEcon
excerpt: A new lecture on differentiable simulations has been added to the Julia lecture series, along with Julia 1.12 support and reorganized content across several topics.
tag: [lectures]
---

We're pleased to announce a new lecture on [Quantitative Economics with Julia](https://julia.quantecon.org/): **[Differentiable Dynamics](https://julia.quantecon.org/differentiable_economics/differentiable_dynamics.html)**.

This lecture demonstrates how to use [Enzyme.jl](https://github.com/EnzymeAD/Enzyme.jl) for automatic differentiation of dynamic economic simulations. The code is more advanced than typical lectures — Enzyme requires non-allocating, functional-style code — but this is necessary to unlock high-performance differentiation of simulation models.

For readers looking for a gentler introduction to Enzyme, see the [Introduction to Enzyme](https://julia.quantecon.org/more_julia/auto_differentiation.html#introduction-to-enzyme) section in the auto-differentiation lecture.

**Other Updates in This Release**

- **Julia 1.12 support** with updated packages across all lectures
- **Reorganized interpolation and integration** lectures for improved flow
- **Refactored Finite Markov chains** lecture with clearer exposition
- **Updated software engineering and testing** content

These updates were developed by [Jesse Perla](https://github.com/jlperla) and [Farhad Shahryarpoor](https://github.com/FarhadShahryarpoor).
