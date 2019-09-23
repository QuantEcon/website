---
layout: post
title: Global PDF restored on for the Python lectures
author: Anju Joon
excerpt: Global PDF and individual PDFs for all the lectures are now available on Quantecon website
---

For the first time in many months, we have a [PDF available](http://lectures.quantecon.org/_downloads/pdf/py/Quantitative%20Economics%20with%20Python.pdf) in book form for the entire collection of Python lectures.  The build procedure uses Sphinx to convert our [RST files](http://github.com/QuantEcon/lecture-source-py/tree/master/source/rst) to Jupyter notebooks, executes them, and then runs pandoc over the results to generate LaTeX.  Custom Python code then builds the result into a single book.  A big thanks to Anju Joon for taking on this huge task and successfully completing it.