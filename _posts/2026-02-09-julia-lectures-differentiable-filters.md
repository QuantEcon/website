---
layout: post
title: "New Julia Lecture: Differentiable Filters and Enzyme Updates"
author: QuantEcon
excerpt: A new lecture on differentiable Kalman and particle filters has been added to the Julia series, featuring high-performance coding patterns for both forward-mode and reverse-mode automatic differentiation with Enzyme.
tag: [lectures]
---

A new lecture has been added to [Quantitative Economics with Julia](https://julia.quantecon.org/): **[Differentiable Filters](https://julia.quantecon.org/differentiable_economics/differentiable_filters.html)**.

This lecture covers differentiating through Kalman and particle filters using both forward-mode and reverse-mode automatic differentiation. It documents specific coding patterns needed to get high performance while remaining compatible with [Enzyme](https://github.com/EnzymeAD/Enzyme.jl).

A key challenge addressed in the lecture is that small, static immutable matrices call for a completely functional coding style, while large matrices require everything to be done in-place. Getting the same code to work efficiently in both cases requires careful design. Much of this is driven by Enzyme's requirement for non-allocating code — which, fortunately, is usually aligned with highest performance anyway.

This release also updates the lectures to support the official Enzyme.jl release (moving from pre-release to stable).

These updates were developed by [Jesse Perla](https://github.com/jlperla).
