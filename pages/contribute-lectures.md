---
title: Contributing to QuantEcon Lectures
permalink: /contribute-lectures/
menu_item: false
---
# Contributing to QuantEcon Lectures

The QuantEcon Lectures are built using [Jupyter Book](https://jupyterbook.org/) and written in [MyST Markdown](https://myst-parser.readthedocs.io/). Each lecture series has its own repository:

* [Python Programming for Economics and Finance](https://github.com/QuantEcon/lecture-python-programming)
* [Quantitative Economics with Python](https://github.com/QuantEcon/lecture-python)
* [Advanced Quantitative Economics with Python](https://github.com/QuantEcon/lecture-python-advanced)
* [Quantitative Economics with Julia](https://github.com/QuantEcon/lecture-julia.myst)

## How to Contribute

We welcome contributions to the QuantEcon lectures! The best way to contribute is:

1. **Fork the repository** you want to contribute to
2. **Create a branch** for your changes
3. **Make your edits** to the MyST Markdown files
4. **Submit a pull request** with a clear description of your changes

For detailed contribution guidelines, please see the README file in each repository.

## Building Lectures Locally

All lecture source files are written in MyST Markdown (`.md` files). To build the lectures locally:

1. Clone the repository
2. Create a conda environment using the provided `environment.yml`
3. Run `jupyter-book build lectures`

Detailed build instructions are available in each repository's README.

## Style Guide - Writing Conventions

If you wish to contribute to any lecture series, please follow these guidelines to maintain consistency.

### Mathematical Notation

Matrices always use square brackets. Use `\begin{bmatrix} ... \end{bmatrix}`

Sequences use curly brackets, such as `\{ x_t \}_{t=0}^{\infty}`

Use standard LaTeX math environments. Dollar signs (`$...$` for inline, `$$...$$` for display) work in MyST Markdown.

"Independent and identically distributed" is abbreviated to "IID".

### Emphasis and Definitions

Use **bold** for definitions and _italic_ for emphasis. For example,

* A **closed set** is a set whose complement is open.
* All consumers have _identical_ endowments.

### Titles and Headings

* Capitalize all words in titles
  > Example: "How it Works: Data, Variables and Names"

### Adding References

Citations use the `{cite}` role in MyST Markdown:

```markdown
{cite}`StokeyLucas1989`, chapter 2
```

To add a new reference, add a BibTeX entry to the `references.bib` file in the lecture repository.

### Helpful Links

* [QuantEcon Style Guide](https://manual.quantecon.org/intro.html)
* [MyST Markdown Guide](https://myst-parser.readthedocs.io/en/latest/)
* [Jupyter Book Documentation](https://jupyterbook.org/en/stable/)
