# QuantEcon Style Guide - Writing Conventions

## Table of Contents

1. [Mathematical Notation](#mathematical-notation)
2. [Emphasis and Definitions](#emphasis-and-definitions)
3. [Titles and Headings](#titles-and-headings)
4. [Adding References](#adding-references)

## Mathematical Notation

Matrices always use square brackets. Use `\begin{bmatrix} ... \end{bmatrix}`

Sequences use curly brackets, such as `\{ x_t \}_{t=0}^{\infty}`

The use of align environments can be done using the `\begin{algined} ... \end{aligned}` as it is not a full math environment and works within the equation wrapping of sphinx.

"Independent and identically distributed" is abbreviated to "IID".

The headings should not use math-environment.

Labels must be written in all small alphabetical letters. Any special character should be avoided in labels except "dash" i.e "-"

All the cite key must use the default google scholar bibtex conventions.

## Emphasis and Definitions

Use **bold** for definitions and _italic_ for emphasis. For example,

* A **closed set** is a set whose complement is open.
* All consumers have _identical_ endowments.

## Titles and Headings

* Capitalization of all words for all titles.
  > Example “How it Works: Data, Variables and Names”

## Adding References

### Adding a Citation to a Lecture

To add a reference to the text of a QuantEcon lecture you need to 
use the `:cite:<bibtex-label>` directive.

For example

```rst
:cite:`StokeyLucas1989`, chapter 2
```

is rendered rendered in HTML and LaTex as:

> [SLP89], chapter 2

### Adding a new reference

To add a new reference to the project, a bibtex entry needs to be added to the project `bibtex` file.

*Python:* https://github.com/QuantEcon/lecture-source-py/blob/master/source/_static/quant-econ.bib
*Julia:* https://github.com/QuantEcon/lecture-source-jl/blob/master/source/_static/quant-econ.bib
