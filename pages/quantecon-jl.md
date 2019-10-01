---
title: "QuantEcon.jl"
permalink: quantecon-jl
menu_item: false
---
# QuantEcon.jl

A high performance, open source Julia code library for economics

    using QuantEcon
    aiyagari_ddp = DiscreteDP(R, Q, beta)
    results = solve(aiyagari_ddp, PFI)

<ul class="library-links">
	<li>
		<p><a href="https://github.com/QuantEcon/QuantEcon.jl"><img alt=" " src="/assets/img/library-button-code.png"></a></p>
		<p><a href="https://github.com/QuantEcon/QuantEcon.jl">Code</a></p>
	</li>
	<li>
		<p><a href="http://quantecon.github.io/QuantEcon.jl/latest/"><img alt=" " src="/assets/img/library-button-documentation.png"></a></p>
		<p><a href="http://quantecon.github.io/QuantEcon.jl/latest/">Documentation</a></p>
	</li>
	<li>
		<p><a href="/julia-developers"><img alt=" " src="/assets/img/library-button-contribute.png"></a></p>
		<p><a href="/julia-developers">Contribute</a></p>
	</li>
	<li>
		<p><a href="https://github.com/QuantEcon/QuantEcon.jl/issues" target="_blank"><img alt=" " src="/assets/img/library-button-issue.png"></a></p>
		<p><a href="https://github.com/QuantEcon/QuantEcon.jl/issues" target="_blank">Report an Issue</a></p>
	</li>
</ul>

## Installation

To install the Julia QuantEcon package [QuantEcon.jl](https://github.com/QuantEcon/QuantEcon.jl/) open the Julia package manager (Pkg) and type

    add QuantEcon

This installs the `QuantEcon` package through the Julia package manager (via git) to the default Julia library location `~/.julia/packages/QuantEcon`.

## Usage

Once installed the `QuantEcon` package can be used in Julia via the `using` keyword such as

    using QuantEcon

More detailed instructions on setting up a `Julia` environment can be found on [this page](https://lectures.quantecon.org/jl/getting_started.html).

## Useful Links

*   [Code library on GitHub](https://github.com/QuantEcon/QuantEcon.jl)
*   [Documentation](http://quantecon.github.io/QuantEcon.jl/)
*   [Report an Issue](https://github.com/QuantEcon/QuantEcon.jl/issues)

QuantEcon.jl is supported financially by the [Alfred P. Sloan Foundation](http://www.sloan.org/) and is part of the [QuantEcon organization](/).
