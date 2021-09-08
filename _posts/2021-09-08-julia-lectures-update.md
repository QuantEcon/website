---
layout: post
title: 'Julia Lectures Updated'
author: QuantEcon
excerpt: The Julia lectures updated to Jupyter Book, with additional software engineering content
---

The [Quantitative Economics with Julia](https://julia.quantecon.org/) lectures have been given a significant update.

Beyond infrastructure updates, the lecture notes now more strongly software engineering concepts, such [source code control and collaboration](https://quantecon.github.io/lecture-julia.myst/software_engineering/version_control.html) and [test-driven development and continuous integration](https://quantecon.github.io/lecture-julia.myst/software_engineering/testing.html).  We see these as essential steps towards **reproducible research**, and the skills are transferable across programming languages.

Some of the key changes:

- Source code and [Jupyter Notebooks](https://github.com/QuantEcon/lecture-julia.notebooks) fully support Julia 1.6, and will soon support Julia 1.7 after its release.
- A significant revamp of the [setup process](https://quantecon.github.io/lecture-julia.myst/getting_started_julia/julia_by_example.html) now focuses on an early introduction of Git, GitHub and VS Code.
- The lecture on [Julia Tools and Editors](https://julia.quantecon.org/software_engineering/tools_editors.html) has moved to VS Code and provides additional workflows in support of the Git and GitHub.
- The [GitHub, Version Control, and Collaboration](https://quantecon.github.io/lecture-julia.myst/software_engineering/version_control.html) lecture shows workflows for collaboration within VS Code and GitHub.
- All content in the [Packages, Testing, and Continuous Integration](https://quantecon.github.io/lecture-julia.myst/software_engineering/testing.html) now uses GitHub Actions as the continuous integration framework, and shows the VS Code workflows required for **reproducible research** and collaboration.
- The lectures are now  using the [Jupyter Book](https://jupyterbook.org/).  Among other things, the move to the markdown format makes open-source contributions and bug fixes [even easier](https://github.com/QuantEcon/lecture-julia.myst#local-development).
