---
title: "QuantEcon.py"
permalink: /quantecon-py/
menu_item: false
---
# QuantEcon.py

A high performance, open source Python code library for economics

    from quantecon.markov import DiscreteDP
    aiyagari_ddp = DiscreteDP(R, Q, beta)
    results = aiyagari_ddp.solve(method='policy_iteration')

<ul class="library-links">
	<li>
		<p><a href="https://github.com/QuantEcon/QuantEcon.py"><img alt=" " src="/assets/img/library-button-code.png"></a></p>
		<p><a href="https://github.com/QuantEcon/QuantEcon.py">Code</a></p>
	</li>
	<li>
		<p><a href="http://quanteconpy.readthedocs.org/en/latest/"><img alt=" " src="/assets/img/library-button-documentation.png"></a></p>
		<p><a href="http://quanteconpy.readthedocs.org/en/latest/">Documentation</a></p>
	</li>
	<li>
		<p><a href="/python-developers"><img alt=" " src="/assets/img/library-button-contribute.png"></a></p>
		<p><a href="/python-developers">Contribute</a></p>
	</li>
	<li>
		<p><a href="https://github.com/QuantEcon/QuantEcon.py/issues" target="_blank"><img alt=" " src="/assets/img/library-button-issue.png"></a></p>
		<p><a href="https://github.com/QuantEcon/QuantEcon.py/issues" target="_blank">Report an Issue</a></p>
	</li>
</ul>

## Installation

Before installing `quantecon` we recommend you install the [Anaconda](https://www.anaconda.com/download/) Python distribution, which includes a full suite of scientific python tools.

Next you can install quantecon by opening a terminal prompt and typing

    pip install quantecon

## Usage

Once `quantecon` has been installed you should be able to import it as follows:

    import quantecon as qe

You can check the version by running

    print(qe.__version__)

If your version is below what’s available on [PyPI](https://pypi.python.org/pypi/quantecon/) then it is time to upgrade. This can be done by running

    pip install --upgrade quantecon

## Downloading the `quantecon` Repository

An alternative is to download the sourcecode of the `quantecon` package and install it manually from [the github repository](https://github.com/QuantEcon/QuantEcon.py/). For example, if you have git installed type

    git clone https://github.com/QuantEcon/QuantEcon.py

Once you have downloaded the source files then the package can be installed by running

	cd QuantEcon.py
    pip install ./

(To learn the basics about setting up Git see [this link](https://help.github.com/articles/set-up-git/).)

## Examples and Sample Code

Many examples of QuantEcon.py in action can be found at [Quantitative Economics](https://lectures.quantecon.org/). 

QuantEcon.py is supported financially by the [Alfred P. Sloan Foundation](http://www.sloan.org/) and is part of the [QuantEcon organization (A NumFOCUS fiscally sponsored project)](/).
