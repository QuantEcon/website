---
title: Docstrings and Documentations
permalink: /wiki-py-docstrings/
menu_item: false
---
# Docstrings and Documentations

## Summary

For a detailed description of the `numpydoc` standard, see [numpy’s actual description](https://github.com/numpy/numpy/blob/master/doc/HOWTO_DOCUMENT.rst.txt#user-content-documenting-classes) of the style. This should be read by each developer to make sure we understand exactly what is required and what other options we have while documenting. Here is a summary of the key components of that document:

`numpydoc` style docstrings are written in [restructured text](http://docutils.sourceforge.net/rst.html). They are composed of a short description of the object followed by a few required and optional sections. For functions and methods, these sections are:

**Required**

1.  Parameters
2.  Returns

**Optional**

1.  Raises
2.  See Also
3.  Notes
4.  References
5.  Examples

The sections for a class are the same, except instead of a `Returns` section there is an `Attribute` section that defines all attributes of the class.

## What is a docstring?

A _docstring_ is a string that starts on the first new line immediately after the declaration of a function or a class. Like the body of the function or class, the docstring must be indented 4 spaces. Typically, a docstring is contained within a block string, set off by tripe quotes “”” as shown below:

    def func(a, b):
        """
        This is a docstring for a function
        """"

    class MyNewClass(object):
        """
        This is a docstring for this class.
        """

## What are docstrings used for?

Docstrings provide a way for developers to document their code inline. This is very useful for many reasons, among which are:

1.  Writing “”” docstrings (where “”” means following the numpydoc standard desribed below) force developers to provide a concise explanation of what the code is supposed to do. This leads to code that is more focused, efficient, and clear.
2.  A good docstring serves as the starting point for other developers who work on code someone else has written (or for the original author who comes back to the code after initially writing it). If the intent of the code is clearly defined in the docstring, then all who work on this code later know exactly what the purpose of the code is.
3.  As hinted at above, docstrings are the code printed at the interpreter when users ask for `help` on a particular object.

## `numpydoc` style docstrings

`numpydoc` style docstrings are written using [restructured text](http://docutils.sourceforge.net/rst.html) (aka rst: the markup used in sphinx documents), using a special structure. While any restructured text is valid in a numpydoc style docstring, the only required restructured text element is knowing how to define a section. In our docstrings, we will denote sections using the following syntax:

    Section name
    ------------

The key elements are a line containing only the name of the section followed be another line containing only minus signs (`-`) underneath each character of the section name.

### Documenting functions and methods

Using this syntax, a `numpydoc` style docstring for a **function** or **method** is made up of the following elements:

1.  A short description of what the function or class does
2.  A section named `Parameters` that explains the object’s input parameters
3.  A section named `Returns` that explains that function’s output
4.  Any of the following “optional sections”; (in any order):
    1.  `Examples`: This section is optional, but strongly recommended and encouraged within QuantEcon (it may be required at some time in the future). Within the section we would include one or more examples for how to use the obejct.
    2.  `Notes`: This section provides additional details that help the user or fellow developer understand the function, but were not included in the short description at the beginning. This might include a description of the algorithm or mathematics underlying the function.
    3.  `References`: If any journal articles, books, or other publications _or_ 3rd party code were consulted when writing the function, this should be documented in this section.
    4.  `Raises`: if the function/class might raise an exception when called, the exception along with cases under which the exception is raised should be documented.
    5.  `See Also`: if the function/class is related to another object, we should specify this relation in a `See Also` section.

Below is an example of such a docstring

    def func(a, b, c=3):
        """
        Short description of what the function accomplishes

        Parameters
        ----------
        a : scalar(float)
            Explanation of what a is used for within the function

        b : array_like(float)
            Explanation of what a is used for within the function

        c : scalar(int), optional(default=3)
            Explanation of what c is used for within the function

        Returns
        -------
        ret1 : type of ret1
            Explanation of the first object returned

        ret2 : type of ret2
            Explanation of the second object returned

        Notes
        -----
        Any implementation notes that help understand how/why the function
        was written the way it was. This section is optional.

        References
        ----------
        In this section we include any references to papers/articles/other
        reading material or other code that we referenced when writing the
        function

        Examples
        --------
        >>> a = 130; b = [10, 20, 30]
        >>> func(a, b)
        &lt;function output copied and pasted&gt;

        Raises
        ------
        ValueError
            If  any parameters are equal to `None.`

        """

There are a few additional points to mention here:

*   When listing parameters and return types, we start by providing the variable name, then space-colon-space, then the type of the object. Additionaly, if the parameter is optional, we say this. I also like to give the default value in parenthsis after the word optional (see the line for the parameter `c` above)
*   We should make sure that each line in a docstring is no longer than 72 characters (as specified in the official python style guide, [PEP8](http://legacy.python.org/dev/peps/pep-0008/))
*   The examples section should feel just like a copy/paste from an interactive python session where the example’s code was executed.
*   There should be a blank line at the end of the docstring.
*   When documenting a method, do not include `self` in the list of parameters.

### Documenting classes

The `numpydoc` standard for documenting classes is very similar. The key components are (this all goes the first line of the docstring that is below the line containing the `class` keyword)

1.  A short description of what the class does
2.  A `Parameters` section that describes the parameters for the class’s `__init__` function
3.  An `Attributes` section that describes all the attributes of the class. This replaces the `Returns` section we saw above for functions and methods.
4.  Any of the optional sections outlined above in addition to an optional section describing the `Methods`that are implemented specifically for this class.

**Remark** There is often overlap between the parameter list and the attribute list. To avoid repetition attributes already discussed in the parameter list can be entered in the attributes list in the form `a, b, c : seeParameters`. An example is given below.

## Examples

Below I will provide some examples. These are copied and pasted from the source of some code we are already using, or will soon be using from within QuantEcon. For additional examples, see these two references:

*   [Example 1](http://sphinxcontrib-napoleon.readthedocs.org/en/latest/example_numpy.html)
*   [Example 2](https://github.com/numpy/numpy/blob/master/doc/example.py)

### Function example

    def poly_inds(d, mu, inds=None):
        """
        Build indices specifying all the Cartesian products of Chebychev
        polynomials needed to build Smolyak polynomial

        Parameters
        ----------
        d : scalar(int)
            The number of dimensions in grid / polynomial

        mu : scalar(int)
            The parameter mu defining the density of the grid

        inds : list(list(int)), optional(default=None)
            The Smolyak indices for parameters d and mu. Should be computed
            by calling `smol_inds(d, mu)`. If None is given, the indices
            are computed using this function call

        Returns
        -------
        phi_inds : array_like(int, ndim=2)
            A two dimensional array of integers where each row specifies a
            new set of indices needed to define a Smolyak basis polynomial

        Notes
        -----
        This function uses smol_inds and phi_chain. The output of this
        function is used by build_B to construct the B matrix

        """

### Class example

    class SmolyakGrid(object):
        """
        This class currently takes a dimension and a degree of polynomial
        and builds the Smolyak Sparse grid.  We base this on the work by
        Judd, Maliar, Maliar, and Valero (2013).

        Parameters
        ----------
        d : scalar(int)
            The number of dimensions in the grid

        mu : scalar(int) or array_like(int, ndim=1, length=d)
            The &quot;density&quot; parameter for the grid

        Attributes
        ----------
        d, mu : see Parameters

        lb : array_like(float, ndim=2)
            This is an array of the lower bounds for each dimension

        ub : array_like(float, ndim=2)
            This is an array of the upper bounds for each dimension

        cube_grid : array_like(float, ndim=2)
            The Smolyak sparse grid on the domain :math:`[-1, 1]^d`

        grid: : array_like(float, ndim=2)
            The sparse grid, transformed to the user-specified bounds for
            the domain

        inds : list(list(int))
            This is a lists of lists that contains all of the indices

        B : array_like(float, ndim=2)
            This is the B matrix that is used to do lagrange interpolation

        B_L : array_like(float, ndim=2)
            Lower triangle matrix of the decomposition of B

        B_U : array_like(float, ndim=2)
            Upper triangle matrix of the decomposition of B

        Examples
        --------
        >>> s = SmolyakGrid(3, 2)
        >>> s
        Smolyak Grid:
            d: 3
            mu: 2
            npoints: 25
            B: 0.65% non-zero
        >>> ag = SmolyakGrid(3, [1, 2, 3])
        >>> ag
        Anisotropic Smolyak Grid:
            d: 3
            mu: 1 x 2 x 3
            npoints: 51
            B: 0.68% non-zero

        """

    Method example
    --------------
    def interpolate(self, pts, interp=True, deriv=False):
        """
        Basic Lagrange interpolation, with optional first derivatives
        (gradient)

        Parameters
        ----------
        pts : array_like(float, ndim=2)
            A 2d array of points on which to evaluate the function. Each
            row is assumed to be a new d-dimensional point. Therefore, pts
            must have the same number of columns as ``si.SGrid.d``

        interp : bool, optional(default=false)
            Whether or not to compute the actual interpolation values at pts

        deriv : bool, optional(default=false)
            Whether or not to compute the gradient of the function at each
            of the points. This will have the same dimensions as pts, where
            each column represents the partial derivative with respect to
            a new dimension.

        Returns
        -------
        rets : list(array(float))
            A list of arrays containing the objects asked for. There are 2
            possible objects that can be computed in this function. They will,
            if they are called for, always be in the following order:

            1\. Interpolation values at pts
            2\. Gradient at pts

            If the user only asks for one of these objects, it is returned
            directly as an array and not in a list.

        References
        ----------
        This is a stripped down port of ``dolo.SmolyakBasic.interpolate``

        """
