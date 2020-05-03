---
title: 'About Python Lectures'
permalink: /about-python-lectures/
menu_item: false
---

# About Python Lectures

## History

This page collects three lecture series:

1. [Python Programming for Economics and Finance](https://python-programming.quantecon.org/)
2. [Quantitative Economics with Python](https://python-intro.quantecon.org/) and
3. [Advanced Quantitative Economics with Python](https://python-advanced.quantecon.org/)

Previously all three were combined in a single site but as the number of
lectures grew they became hard to navigate. The single site was split into
three in March 2020.

The breakdown is as the names suggest. The first series focuses on
programming and is a prerequisite for both the second and the third. The
second series is aimed at (very) advanced undergraduate students and beginning
graduate students. The third is for advanced graduate students and
researchers.

While Thomas Sargent and John Stachurski are listed as coauthors, many people
have contributed to the lectures. Credits are give below.

## Objective

The lecture series treats

- algorithms and numerical methods for quantitative economic problems,
- related mathematical and statistical concepts, and
- basics of coding skills and software engineering.

As stated above, the coding language for this lecture series is Python.

Note that there's also a related set of [Julia lectures](https://julia.quantecon.org>)

In terms of the differences,

- Python is a general-purpose language featuring a huge user
  community in the sciences and an outstanding scientific ecosystem.
- Julia is a more recent language with many exciting features.

Both are modern, open-source, high productivity languages with all the
key features needed for high-performance computing.

Julia has the advantage that third party libraries are often written
entirely in Julia itself.

Python has the advantage of being supported by a vast collection of
scientific libraries (and being a highly marketable skill).

## Open Source

All the computing environments we work with are free and open-source.

This means that you, your coauthors and your students can install them
and their libraries on all of your computers without cost or concern
about licenses.

Another advantage of open source libraries is that you can read them and
learn how they work.

For example, let's say you want to know exactly how
[statsmodels](https://github.com/statsmodels/statsmodels) computes
Newey-West covariance matrices.

No problem: You can go ahead and [read the
code](https://github.com/statsmodels/statsmodels/blob/master/statsmodels/stats/sandwich_covariance.py).

While dipping into external code libraries takes a bit of coding
maturity, it's very useful for

1.  helping you understand the details of a particular implementation,
    and
2.  building your programming skills by showing you code written by
    first-rate programmers.

Also, you can modify the library to suit your needs: if the
functionality provided is not exactly what you want, you are free to
change it.

Another, a more philosophical advantage of open-source software is that
it conforms to the [scientific ideal of
reproducibility](https://en.wikipedia.org/wiki/Scientific_method).

## Credits

These lectures have benefited greatly from comments and suggestions from
our colleagues, students and friends. Special thanks are due to our
sponsoring organization the Alfred P. Sloan Foundation and our research
assistants Chase Coleman, Spencer Lyon and Matthew McKay for innumerable
contributions to the code library and functioning of the website.

We also recognize those who co-authored lectures and code:

[Anmol Bhandari](http://www.bhandarianmol.com/)

- Co-authored [Fluctuating Interest Rates Deliver Fiscal Insurance](https://python-advanced.quantecon.org/amss2.html)

[Chase Coleman](http://www.chasegcoleman.com/)

- Co-authored [Additive and Multiplicative Functionals](https://python-advanced.quantecon.org/additive_functionals.html)
- Co-authored [Globalization and Cycles](https://python-advanced.quantecon.org/matsuyama.html)
- Co-authored [Permanent Income II: LQ Techniques](https://python-intro.quantecon.org/perm_income_cons.html)
- Co-authored [Reverse Engineering a la Muth](https://python-advanced.quantecon.org/muth_kalman.html)
- Co-authored code for [Asset Pricing with Incomplete Markets](https://python-intro.quantecon.org/harrison_kreps.html)
- Co-authored code for [Markov Perfect Equilibrium](https://python-intro.quantecon.org/markov_perf.html)
- Co-authored code for [Robust Markov Perfect Equilibrium](https://python-advanced.quantecon.org/rob_markov_perf.html)
- Co-authored code for [Robustness](https://python-advanced.quantecon.org/robustness.html)

[Daniel Csaba](http://danielcsaba.com/)

- Co-authored [Two Modifications of Mean-Variance Portfolio Theory](https://python-advanced.quantecon.org/black_litterman.html)

[David Evans](http://econevans.com/)

- Co-authored [Fluctuating Interest Rates Deliver Fiscal Insurance](https://python-advanced.quantecon.org/amss2.html)

[Sebastian Graves](https://www.sebgraves.com/)

- Co-authored [Cattle Cycles](https://python-advanced.quantecon.org/cattle_cycles.html)
- Co-authored [Competitive Equilibria of a Model of Chang](https://python-advanced.quantecon.org/chang_ramsey.html)
- Co-authored [Credible Government Policies in a Model of Chang](https://python-advanced.quantecon.org/chang_credible.html)
- Co-authored [Growth in Dynamic Linear Economies](https://python-advanced.quantecon.org/growth_in_dles.html)
- Co-authored [How to Pay for a War: Part 1](https://python-advanced.quantecon.org/tax_smoothing_1.html)
- Co-authored [How to Pay for a War: Part 2](https://python-advanced.quantecon.org/tax_smoothing_2.html)
- Co-authored [How to Pay for a War: Part 3](https://python-advanced.quantecon.org/tax_smoothing_3.html)
- Co-authored [IRFs in Hall Models](https://python-advanced.quantecon.org/irfs_in_hall_model.html)
- Co-authored [Lucas Asset Pricing Using DLE](https://python-advanced.quantecon.org/lucas_asset_pricing_dles.html)
- Co-authored [Markov Jump Linear Quadratic Dynamic Programming](https://python-advanced.quantecon.org/markov_jump_lq.html)
- Co-authored [Permanent Income Model using the DLE Class](https://python-advanced.quantecon.org/permanent_income_dles.html)
- Co-authored [Ramsey Plans, Time Inconsistency, Sustainable Plans](https://python-advanced.quantecon.org/calvo.html)
- Co-authored [Rosen Schooling Model](https://python-advanced.quantecon.org/rosen_schooling_model.html)

[Spencer Lyon](http://spencerlyon.com/)

- Co-authored code for [Robustness](https://python-advanced.quantecon.org/robustness.html)

[Matthew McKay](https://github.com/mmcky)

- Co-authored [Parallelization](https://python-programming.quantecon.org/parallelization.html)

[Daisuke Oyama](http://www.oyama.e.u-tokyo.ac.jp/)

- Authored code for [Discrete State Dynamic Programming](https://python-advanced.quantecon.org/discrete_dp.html)

[Zejin Shi](https://github.com/shizejin)

- Co-authored [Information and Consumption Smoothing](https://python-advanced.quantecon.org/cons_news.html)
- Co-authored [Markov Jump Linear Quadratic Dynamic Programming](https://python-advanced.quantecon.org/markov_jump_lq.html)
- Co-authored [Production Smoothing via Inventories](https://python-intro.quantecon.org/lq_inventories.html)

[Balint Szoke](https://www.balintszoke.com/)

- Co-authored [Additive and Multiplicative Functionals](https://python-advanced.quantecon.org/additive_functionals.html)
- Co-authored [Two Modifications of Mean-Variance Portfolio Theory](https://python-advanced.quantecon.org/black_litterman.html)
- Co-authored [Von Neumann Growth Model (and a Generalization)](https://python-advanced.quantecon.org/von_neumann_model.html)
- Co-authored code for [Classical Control with Linear Algebra](https://python-advanced.quantecon.org/lu_tricks.html)
- Co-authored code for [Classical Prediction and Filtering With Linear Algebra](https://python-advanced.quantecon.org/classical_filtering.html)

[Natasha Watkins](https://github.com/natashawatkins)

- Co-authored [Application: The Samuelson Multiplier-Accelerator](https://python-intro.quantecon.org/samuelson.html)
- Co-authored [Linear Regression in Python](https://python-intro.quantecon.org/ols.html)
- Co-authored [Maximum Likelihood Estimation](https://python-intro.quantecon.org/mle.html)
- Co-authored [Pandas for Panel Data](https://python-intro.quantecon.org/pandas_panel.html)

Dongchen Zou

- Co-authored [Robust Markov Perfect Equilibrium](https://python-advanced.quantecon.org/rob_markov_perf.html)

We also thank [Andrij Stachurski](http://drdrij.com/) for his great web
skills, and the many others who have contributed suggestions, bug fixes
or improvements. They include but are not limited to Anmol Bhandari,
Long Bui, Jeong-Hun Choi, David Evans, Shunsuke Hori, Chenghan Hou,
Doc-Jin Jang, Qingyin Ma, Akira Matsushita, Tomohito Okabe, Daisuke
Oyama, David Pugh, Alex Olssen, Nathan Palmer, Bill Tubbs, Natasha
Watkins, Pablo Winant and Yixiao Zhou.
