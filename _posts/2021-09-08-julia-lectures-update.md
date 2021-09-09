---
layout: post
title: 'Julia Lectures Updated'
author: QuantEcon
excerpt: The Julia lectures updated to Jupyter Book, with additional software engineering content
---

The [Quantitative Economics with Julia](https://julia.quantecon.org/) lectures have been given a significant update.

Beyond infrastructure updates, the lecture notes now more strongly software engineering concepts, such [source code control and collaboration](https://julia.quantecon.org/software_engineering/version_control.html) and [test-driven development and continuous integration](https://julia.quantecon.org/software_engineering/testing.html).  We see these as essential steps towards **reproducible research**, and the skills are transferable across programming languages.

Some of the key changes:

- Source code and [Jupyter Notebooks](https://github.com/QuantEcon/lecture-julia.notebooks) fully support Julia 1.6, and will soon support Julia 1.7 after its release.
- A significant revamp of the [setup process](https://julia.quantecon.org/getting_started_julia/getting_started.html) now focuses on an early introduction of Git, GitHub and VS Code.
- The lecture on [Julia Tools and Editors](https://julia.quantecon.org/software_engineering/tools_editors.html) lecture has moved to VS Code and provides additional workflows in support of the Git and GitHub.
- The [GitHub, Version Control, and Collaboration](https://julia.quantecon.org/software_engineering/version_control.html) lecture shows workflows for collaboration within VS Code and GitHub.
- All content in the [Packages, Testing, and Continuous Integration](https://julia.quantecon.org/software_engineering/testing.html) lecture now uses GitHub Actions as the continuous integration framework, and shows the VS Code workflows required for **reproducible research** and collaboration.
- The lectures are now  using [Jupyter Book](https://jupyterbook.org/).  Among other things, the move to the markdown format makes open-source contributions and bug fixes [even easier](https://github.com/QuantEcon/lecture-julia.myst#local-development).

We are grateful for support from the [Center for Innovative Data in Economic Research (CIDER)](https://economics.ubc.ca/cider/research-activity/#:~:text=The%20Centre%20for%20Innovative%20Data,on%20economics%20and%20related%20fields.) at the [Vancouver School of Economics at the University of British Columbia](https://economics.ubc.ca/).