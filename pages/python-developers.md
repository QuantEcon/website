---
title: "Contribute to QuantEcon.py"
permalink: /python-developers/
menu_item: false
---
# Contribute to QuantEcon.py


If you’d like to contribute to [QuantEcon.py](quantecon-py.md), a good place to start is the [project issue tracker](http://github.com/QuantEcon/QuantEcon.py/issues). Those who are new to Python programming should look out for the [![](https://lh6.googleusercontent.com/f5iu-YzQUQJrRiq7Fznofq_Xikw_QvuGYZ8FaZYN9jnE9QR7zvh7QUbYB0K3GdrFtleaY_OAjWC-yMipbVls7loByc7Ea6FErfSHGgL0PRjyFW7866Wp7VZWDGiov4Liytot4HXX)](https://github.com/QuantEcon/QuantEcon.py/labels/beginner) tag, indicating [tasks](https://github.com/QuantEcon/QuantEcon.py/labels/beginner) that are a good entry point to contributing.

## Set up a Conda development environment

One of the advantages of the [Anaconda Python environment](https://www.anaconda.com/distribution/) is that it is cheap to set up (and discard) Python environments for development versions of packages and populate them with your favorite scientific tools. For example, if you’re working on QuantEcon.py you might find it useful to set up an environment (containing NumPy, SciPy, etc.) that uses your development version rather than the default ones. This facilitates contributing to QuantEcon.py without worrying about corrupting the Python environment on which your other work depends.

See [creating a Conda development environment](wiki-py-conda-dev-env.md)

## Write tests

All functions and methods contributed to QuantEcon.py should be paired with tests to verify that they are functioning correctly.

See [unit testing in QuantEcon](wiki-py-unit-testing.md)

## Write documentation

We try to maintain a simple and consistent format for inline documentation, known in the Python world as docstrings. The format we use is known as [numpydoc](https://github.com/numpy/numpy/blob/master/doc/HOWTO_DOCUMENT.rst.txt). It was developed by the numpy and scipy teams and is used in many popular packages. Adhering to this standard helps us

*   Provide a sense of consistency throughout the library

*   Give users instant access to necessary information at the interpreter prompt (either via the built-in Python function help(object_name) or the Jupyter object_name?)

*   Easily generate a reference manual using sphinx’s autodoc and apidoc

See [docstrings and documentation](wiki-py-docstrings.md)

Instructions to compile a local version of the documentation can be found [here](https://github.com/QuantEcon/QuantEcon.py/tree/master/docs). This can be useful if you would like to check how your docstrings render in html prior to submitting a pull request.

## Package structure

The current structure of QuantEcon.py is relatively flat. The majority of methods are available at the top level namespace for easy access. The Python API is defined by the __init__.py files within the quantecon package.

## The QuantEcon.py API

As QuantEcon.py evolves, the structure will naturally move towards having more sub-packages. Every effort should be made to maintain the current API, however if you are submitting a pull request (PR) that results in a necessary change to the current API, this should be highlighted and discussed in the PR on GitHub.

## Further questions

We encourage you to reach out to the [QuantEcon team](https://quantecon.org/team) on the [Discourse forum](http://discourse.quantecon.org/) if you have any further questions.
