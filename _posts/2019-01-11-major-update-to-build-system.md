---
layout: post
title: "Major Update to Build System"
author: Natasha Watkins
excerpt: The new build system allows easier editing of QuantEcon lectures, with output being automatically generated from lecture code.
---

Over the past year, the QuantEcon team has been working on a major update to the QuantEcon lecture build system. For a reader, the changes are not obvious -- lectures are still styled to appear as Jupyter notebooks, and feature integrated testing implemented [at the end of 2018](https://quantecon.org/news-item/code-testing-lecture-site).

Under the hood, the lecture build system has changed substantially, and it is now easier to maintain and update lectures. Output cells are automatically generated from code, meaning that updates to packages used in the lectures will be reflected on the site. We intend  to improve on this foundation through advances in Continuous Integration testing, coverage statistics for error tracking, and migrating execution control to the [sphinxcontrib-jupyter package](https://github.com/QuantEcon/sphinxcontrib-jupyter).

We have continued to work on [Jupinx](https://medium.com/quantecon-blog/introducing-jupinx-60ba9fc12f4f), our tool to [generate Jupyter noteboook from RST files](https://quantecon.org/news-item/download-lectures-as-jupyter-notebooks). Notebooks with full lecture content are now available for download on each lecture page.

QuantEcon is thankful to [Matt McKay](https://github.com/mmcky) for his hard work on this update.