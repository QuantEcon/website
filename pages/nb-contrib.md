---
title: Contributing a Jupyter Notebook
permalink: nb-contrib
menu_item: false
---
# Contributing a Jupyter Notebook

## Submissions

To submit your [notebook](http://jupyter.org/) as a candidate for inclusion in the [notebook gallery](/notebooks), please add it to [nbviewer](http://nbviewer.jupyter.org/) and send us a link via [contact@quantecon.org](mailto:contact%40quantecon.org). Below is a simple style guide to document how the repository is organised and what is the best way to construct your submission.

Once your Jupyter notebook has been reviewed and approved for inclusion (via nbviewer) - we will ask you to put together a **pull request** to the QuantEcon.notebooks [repo](https://github.com/QuantEcon/QuantEcon.notebooks). If you are unfamiliar with **git** then feel free to let us know at [contact@quantecon.org](mailto:contact%40quantecon.org).

## Style Guide

The organization of the repository is simple by design.

QuantEcon.notebooks:

<pre>./ipynb files
./dependencies/
        Support files required for notebooks and data files (i.e. *.py, *.csv etc.)
</pre>

While we don’t want to impose any restrictions on your creativity when constructing your notebook, we have built some basic infrastructure to make working with dependencies a little easier.

Submission of single document (self contained notebooks) is straight forward. All that is required is that you submit a PR with the `ipynb` file to the root level of the repo.

### Notebooks with Dependencies

There are two primary circumstances that typically render Jupyter notebooks dependent on support files:

> 1.  Support code that is contained in a separate `.py` file
> 2.  Data files

The most convenient method is to have these support files in the same directory as the Jupyter notebook to allow for the direct import of code or data that is contained in these files. However when submitting your notebook we ask that you follow this convention to keep the repo organized and tidy.

Once you are happy with the notebook

**Step #1:** Place any dependency files in the `dependencies/` folder.

**Step #2:** Add the following import statement to the top of your Jupyter notebook to fetch these documents from GitHub. This ensures the notebook will run anywhere that the notebook is placed.

<pre>from quantecon import fetch_nb_dependencies
fetch_nb_dependencies(["filenames"])
</pre>

If you place your dependencies in a folder within `dependencies/` then you can pass a Dictionary to `fetch_nb_dependencies({"dir" : ["filenames"]})`

<pre>from quantecon import fetch_nb_dependencies
fetch_nb_dependencies({"dir" : ["filenames"]})
</pre>

Note

This requires QuantEcon.py version 0.3+

This simple method from the QuantEcon package fetches the request file from the `QuantEcon.notebooks`master branch and writes a copy into the same folder as the Jupyter notebook.

The documentation for this method can be found [here](https://quanteconpy.readthedocs.org/en/latest/util/notebooks.html)

## Resources

1.  [GitHub Pull Requests Article](https://help.github.com/articles/using-pull-requests/)