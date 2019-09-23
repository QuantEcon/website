---
layout: post
title: "Speeding up the Python Lectures"
author: Natasha Watkins
excerpt: QuantEcon has been working to speed up the Python lectures with the help of just-in-time compilation from Numba.
---

QuantEcon has been working to speed up the Python lectures with the help of just-in-time compilation from [Numba](http://numba.pydata.org/). Just-in-time (jit) compilation allows code to be compiled on the fly - a flexible combination of ahead-of-time compilation and interpretation (standard Python is interpreted).

By jitting the lectures, we've seen speed improvements of about 1 to 2 orders of magnitude. A discussion of the benefits of Numba with Python is in [No, Python is Not Too Slow for Computational Economics](http://notes.quantecon.org/submission/5bae5cb538674f000fd2c8e3).

The majority of jitted lectures use fixed point iteration to find the model's solution, some examples include [The Stochastic ](http://lectures.quantecon.org/py/optgrowth.html#)[Optimal Growth](https://lectures.quantecon.org/py/optgrowth.html#) [Model](http://lectures.quantecon.org/py/optgrowth.html#), [The Lucas Asset Model](https://lectures.quantecon.org/py/lucas_model.html#) and [Search With Learning](https://lectures.quantecon.org/py/odu.html#).

Thanks to [Natasha Watkins](https://github.com/natashawatkins) for work on this improvement.

![QuantEcon pre-doc Natasha Watkins](/assets/2017-06-14-13.39.40.jpg)