---
layout: post
title: "Talk: A Community Reference Library for Computational Economics at CEF 2026"
author: QuantEcon
excerpt: "QuantEcon proposed a community-owned, cross-toolkit reference library of canonical models at the CEF 2026 pre-conference in Venice."
tag: [workshop]
---

[Matt McKay](https://github.com/mmcky) presented QuantEcon's proposal for a **Community Reference Library for Computational Economics** on June 28, 2026, at a pre-conference meeting on computational toolkits and interoperability, co-sponsored by the Society for Computational Economics and [Econ-ARK](https://econ-ark.org/). The meeting was held at Ca' Foscari University of Venice the day before the Society's annual conference, [CEF 2026](https://comp-econ.com/32nd-cef-conference/), and Matt presented remotely.

The proposal is a community-owned library of the field's canonical models, with the same models implemented by every toolkit in a family and shown side by side. The talk noted that the field has over a dozen mature toolkits, but no easy way to compare them and no shared, cross-toolkit library of canonical models. Each participating project would contribute:

1. **Shared baseline models**, an introductory and an advanced one, coordinated with the other toolkits in its family (heterogeneous-agent, representative-agent DSGE, or agent-based) so results are directly comparable
2. **A hero tutorial** of its own choosing, on a problem where its toolkit shines

The talk suggested two starting baselines for each family, open to discussion: Aiyagari and one-asset HANK models, RBC and three-equation New Keynesian models, and the Boltzmann–Gibbs exchange and Lengnick (2013) agent-based models.

Under the proposal, projects would author and maintain their own content and keep credit and editorial control. QuantEcon would host and publish the library as an executable Jupyter Book, use continuous integration to check that the Python and Julia code runs, and develop supporting infrastructure, including for MATLAB.

The initiative is now part of the Society's [Working Group 1 on Language, Calculus & Formal Semantics](https://llorracc.github.io/workspace-comp-econ-soc/t1-language-calculus-semantics), one of the working groups in the research program it launched at the meeting.

The [slides](https://quantecon.github.io/conference-cef2026/) are available online, and the talk's materials are on [GitHub](https://github.com/QuantEcon/conference-cef2026).
