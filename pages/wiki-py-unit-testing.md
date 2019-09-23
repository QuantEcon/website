---
title: Unit Testing in QuantEcon
permalink: wiki-py-unit-testing
menu_item: false
---
# Unit Testing in QuantEcon

## Summary

The QuantEcon package uses [Nose](https://nose.readthedocs.org/en/latest/) to manage tests. We adhere to some conventions to facilitate ease of maintenance and management of test cases. The main conventions are as follows:

*   Tests live in Python files, which in turn live in `quantecon/tests/`
*   These test files should be prepended with `test_` followed by module name (e.g., tests for `asset_pricing.py` should be found in `quantecon/tests/test_asset_pricing.py`).
*   Test files may contain either traditional Python `unittest` classes or the simpler `deftest_function()` style tests made available by Nose.

If you use Nose style test functions, please refer to the test name conventions discussed below so that nose can identify them as tests.

## Test Fundamentals

The basic premise of testing in Python is to write functions that make assertions. An assertion checks a given logical condition. If the condition is met, then the program continues onto the next line. If not, the assertion will trigger an Exception and issue an `AssertionError`. Here’s a simple example:

    def test_equal(a,b):
        """
        # Communicate what this Test Does In the DocString #
        This tests for equality between two arguments a and b
        """
        assert a==b, "Test failed: Arguments are not equal."

Running TestsIf `a=2` and `b=1` then this test would fail and raise an `AssertionError` with the the message string after the comma.

Nose parses Python files in the QuantEcon repository and collects all tests (i.e., all functions that satisfy the test naming convention discussed below). It then runs them one by one and provides you with a report of which passed and which failed.

To run the test suite, you need to type `nosetests` at the command line, or `nosetests -v` for a more verbose report.

### Test Function Names

Perhaps the easiest way to write basic tests is using Nose test functions. When `nose` parses the repository looking for tests it will search for the following regular expression: `?:^|[\\b_\\.-])[Tt]est`. What this means is that your function name must contain `test` or `Test` either at a word boundary after an underscore or hyphen. Examples:

*   `test_somethinghere`
*   `somethinghere_test`
*   `TestSomethingHere`

When naming your test function or class, remember to use PEP8 convention, as reading files that are similarly formated is less tiresome. Also make sure your clearly indicate what part of a module (be it a function or class etc.) that your test suite is testing.

### Assertion Methods

While it’s fine to construct your own logic and messaging using `assert` statements as above, note that there are also many helpful pre-existing assertion methods available in other packages, such as

1.  [unittest](https://docs.python.org/2/library/unittest.html#assert-methods)
2.  [numpy.testing](http://docs.scipy.org/doc/numpy/reference/routines.testing.html)
3.  [pandas.util](https://github.com/pydata/pandas/blob/master/pandas/util/testing.py)

These packages are used throughout QuantEcon, so it is safe to retrieved functions and methods from them directly using import statements such as:

    from numpy.testing import assert_allclose

Next StepsThis particular function is useful in testing if an array matches a known solution, allowing for a degree of tolerance through the `rtol=` relative tolerance or `atol=` absolute tolerance keyword arguments.

To learn more, you can either read on below or browse some of the files in `quantecon/tests/` and learn from these examples.

### Example 1: A Basic Test

Now let’s now look at an extended example, concerning a basic test for the `mc_compute_startionary `function from the `mc_tools.py` module.

We will use a known matrix and compute it’s stationary distribution.

$$ \begin{split}P := \left( \begin{array}{cc} 0.4 & 0.6 \\ 0.2 & 0.8 \end{array} \right)\end{split} $$

We know that the unique stationary distribution should be (0.25, 0.75)

Now let’s write a test case in the file: `tests/test_mc_tools.py` and have a look at the results.

    # Check required infrastructure is imported
    import numpy as np
    from numpy.testing import assert_array_equal

    # Check that the test_mc_tools.py file has imported the relevant function we wish to test: mc_compute_stationary
    from quantecon import mc_compute_stationary

    def test_mc_compute_stationary_pmatrix():
        """
        Test for a Known Solution
        Module:     mc_tools.py
        Function:   mc_compute_stationary
        """"
        P = np.array([[0.4,0.6], [0.2,0.8]])
        P_known = np.array([0.25, 0.75])
        computed = mc_compute_stationary(P)
        assert_array_equal(computed, P_known)

    ---------------------------------------------------------------------------
    AssertionError                            Traceback (most recent call last)
    #Traceback details are presented here

    AssertionError:
    Arrays are not equal

    (mismatch 50.0%)
    x: array([ 0.25,  0.75])
    y: array([ 0.25,  0.75])

This test actually fails! Why? This is because computed results and perfect analytical results are often very close but not quite equal. Let’s take a look at what the variable `computed` looks like in this case (by returning it and having a look using IPython):Running this test returns

    In [1]: computed
    Out[1]: array([ 0.25,  0.75])
    In [2]: computed[0]
    Out[2]: 0.24999999999999994
    In [3]: computed[1]
    Out[3]: 0.75
    In [4]: computed == known
    Out[4]: array([False,  True], dtype=bool)

Updating the test to make use of `assert_allclose` will produce the expected result due to the small difference in relative values.As you can see the test results really are the same and numerical exactness in computing the results in this case is an issue. That’s why numpy.testing also has asserts such as `assert_allclose` where you can set a relative tolerance and absolute tolerance through the keyword arguments `rtol=` and `atol=` (default values: rtol=1e-07, atol=0)

    # Check required infrastructure is imported
    import numpy as np
    from numpy.testing import assert_allclose

    # Check that the test_mc_tools.py file has imported the relevant function we wish to test: mc_compute_stationary
    from quantecon import mc_compute_stationary

    def test_mc_compute_stationary_pmatrix():
        """
        Test mc_compute_stationary for a Known Solution of Matrix P
        Module:     mc_tools.py
        Function:   mc_compute_stationary
        """"
        P = np.array([[0.4,0.6], [0.2,0.8]])
        P_known = np.array([0.25, 0.75])
        computed = mc_compute_stationary(P)
        assert_allclose(computed, P_known)

### Making this test more General

Other considerations to testing include making useful test functions that can generalise. For example, to make this test a bit more usable with a larger set of P Matrices, you may want to update the test function by allowing arguments which might accept a tuple of data and the known solution `test_set_1 = (P, know)`. Now others can also make use of this test if they want to add another (or special case) P Matrix and associated known solution by looping over a list of tuples. A simple update to this test would then look like:

    def test_mc_compute_stationary_pmatrix():
        testset1 = (np.array([[0.4,0.6], [0.2,0.8]]), np.array([0.25, 0.75]))
        check_mc_compute_stationary_pmatrix(testset1)

    def check_mc_compute_stationary_pmatrix(testset):
        """
        Test mc_compute_stationary for a Known Solution of Matrix P
        Module:     mc_tools.py
        Function:   mc_compute_stationary

        Arguments
        ---------
        [1] test_set    :   tuple(np.array(P), np.array(known_solution))
        """

        (P, known) = testset
        computed = mc_compute_stationary(P)
        assert_allclose(computed, known)

## Example 2: An Extended Example

<span>As a more extended example, we will make use of </span>`mc_tools.py`<span> and write some tests for the </span>`mc_compute_stationary`<span> function that requires some setup prior to running a test. This test is constructed from an example written by </span>[https://github.com/oyamad/test_mc_compute_stationary](https://github.com/oyamad/test_mc_compute_stationary)<span> and compares three different approaches to demonstrate some benefits to using classes to organise the tests. As you will see in this example one big advantage to using classes is that you can specify </span>`setUp`<span> and </span>`tearDown`<span> functions which ensure each test is run in a consistent environment and state.</span>

So let’s setup our test file (assuming it didn’t already exist) which we would call `test_mc_tools.py` and place it in the `tests/` directory:

    """
    Tests for mc_tools.py

    Functions
    ---------
        mc_compute_stationary
    """

    from __future__ import division

    import numpy as np
    import unittest

    # Tests: mc_compute_stationary #
    ################################

    from ..mc_tools import mc_compute_stationary    # An example of using relative references within a package

    def KMRMarkovMatrixSequential(N, p, epsilon):
        """
        Generate the Markov matrix for the KMR model with *sequential* move

        N: number of players
        p: level of p-dominance for action 1
           = the value of p such that action 1 is the BR for (1-q, q) for any q > p,
             where q (1-q, resp.) is the prob that the opponent plays action 1 (0, resp.)
        epsilon: mutation probability

        References:
            KMRMarkovMatrixSequential is contributed from https://github.com/oyamad
        """

        P = np.zeros((N+1, N+1), dtype=float)
        P[0, 0], P[0, 1] = 1 - epsilon * (1/2), epsilon * (1/2)
        for n in range(1, N):
            P[n, n-1] = \ (n/N) * (epsilon * (1/2) + (1 - epsilon) * (((n-1)/(N-1) &lt; p) + ((n-1)/(N-1) == p) * (1/2)))
            P[n, n+1] = \ ((N-n)/N) * (epsilon * (1/2) + (1 - epsilon) * ((n/(N-1) > p) + (n/(N-1) == p) * (1/2)))
            P[n, n] = 1 - P[n, n-1] - P[n, n+1]
        P[N, N-1], P[N, N] = epsilon * (1/2), 1 - epsilon * (1/2)
        return P

Sometimes Supporting Test Functions may be required for Generating Markov Matrices such as the KMR Model. However more often then not these `support` functions can be imported from the project. This can make it clearer regarding what is actually acting as `input` into the test cases.

**Note:** In production code - there should also be tests for the above function to ensure it is producing expected results given N, p, and epsilon.

### Using `unittest.TestCase` Framework

`unittest.TestCase` is a class provided by the python `unittest` module. By constructing a class instance using inheritance of the `TestCase` class, we inherit a number of useful methods. However it does specify some conventions that need to be used to make it all work. A test setup method needs to be located in a method called: `def setUp(self)` and a test teardown methods needs to be located in a method called: `deftearDown(self)`. Specifying these methods ensures a common setup is performed prior to running each test. This relocates code from each test function and reduces the chances of error.

Some benefits to inheriting `unittest.TestCase` includes the inbuilt support for some assert methods like `self.assertEqual()` etc.

    # Construct a Class
    class TestMcComputeStationaryKMRMarkovMatrix(unittest.TestCase):
        """"
        Test Suite for mc_compute_stationary using KMR Markov Matrix [using unittest.TestCase]
        """"

        # Starting Values #

        N = 27
        epsilon = 1e-2
        p = 1/3
        TOL = 1e-2

        def setUp(self):
            self.P = KMRMarkovMatrixSequential(self.N, self.p, self.epsilon)
            self.v = mc_compute_stationary(self.P)

        def test_markov_matrix(self):
            for i in range(len(self.P)):
                self.assertEqual(sum(self.P[i, :]), 1)

        def test_sum_one(self):
            self.assertTrue(np.allclose(sum(self.v), 1, atol=self.TOL))

        def test_nonnegative(self):
            self.assertEqual(np.prod(self.v >= 0-self.TOL), 1)

        def test_left_eigen_vec(self):
            self.assertTrue(np.allclose(np.dot(self.v, self.P), self.v, atol=self.TOL))

        def tearDown(self):
            pass

### Using `nose` test functions

<span>This example can also be written as nose </span>`test_`<span> functions. The required setup can be done in a </span>`setup_func()`<span> and then importing a </span>`with_setup`<span> decorator from </span>`nose.tools`<span>. This decorator will then run the setup function before every test is performed. Nose also allows you to specify </span>`teardown_`<span> functions as a second argument to </span>`with_setup`<span>.</span>

    from nose.tools import with_setup

    N = 27
    epsilon = 1e-2
    p = 1/3
    TOL = 1e-2

    def setup_func():
        """
        Setup a KMRMarkovMatrix and Compute Stationary Values
        """

        global P                                            # Not Usually Recommended
        P = KMRMarkovMatrixSequential(N, p, epsilon)
        global v                                            # Not Usually Recommended
        v = mc_compute_stationary(P)

        @with_setup(setup_func)
        def test_markov_matrix():
        for i in range(len(P)):
            assert sum(P[i, :]) == 1, "sum(P[i,:]) %s != 1" % sum(P[i, :])

        @with_setup(setup_func)
        def test_sum_one():
            assert np.allclose(sum(v), 1, atol=TOL) == True, "np.allclose(sum(v), 1, atol=%s) != True" % TOL

        @with_setup(setup_func)
        def test_nonnegative():
            assert np.prod(v >= 0-TOL) == 1, "np.prod(v >= 0-TOL) %s != 1" % np.prod(v >= 0-TOL)

        @with_setup(setup_func)
        def test_left_eigen_vec():
            assert np.allclose(np.dot(v, P), v, atol=TOL) == True, "np.allclose(np.dot(v, P), v, atol=%s) != True" % TOL

### Using `nose` class based structures

<span>Nose can also parse classes. As discussed in the </span>`unittest`<span> section in more complex test suites classes are useful for bringing structure to the code. While it is not a requirement to use </span>`unittest.TestCase`<span> in QuantEcon if you do choose to write tests in a class structure it can be helpful for cross readership to adopt the standard </span>`setUp()`<span> and </span>`tearDown()`<span> methods as used in </span>`unittest.TestCase`<span>. The main benefit of using Class structures is to collect your tests into one logical space and allow easy parameter passing without resorting to </span>`global`<span> variables etc.</span>

    class TestMcComputeStationaryKMRMarkovMatrix():
        """
        Test Suite for mc_compute_stationary using KMR Markov Matrix [suitable for nose]
        """
        # Starting Values #

        N = 27
        epsilon = 1e-2
        p = 1/3
        TOL = 1e-2

        def setUp(self):
            """
                Setup a KMRMarkovMatrix and Compute Stationary Values
            """
            self.P = KMRMarkovMatrixSequential(self.N, self.p, self.epsilon)
            self.v = mc_compute_stationary(self.P)

        def test_markov_matrix(self):
            for i in range(len(self.P)):
                assert sum(self.P[i, :]) == 1, "sum(P[i,:]) %s != 1" % sum(self.P[i, :])

        def test_sum_one(self):
            assert np.allclose(sum(self.v), 1, atol=self.TOL) == True, "np.allclose(sum(v), 1, atol=%s) != True" % self.TOL

        def test_nonnegative(self):
            assert np.prod(self.v >= 0-self.TOL) == 1, "np.prod(v >= 0-TOL) %s != 1" % np.prod(self.v >= 0-self.TOL)

        def test_left_eigen_vec(self):
            assert np.allclose(np.dot(self.v, self.P), self.v, atol=self.TOL) == True, "np.allclose(np.dot(v, P), v, atol=%s) != True" % self.TOL

## References

1.  [Nose Documentation](https://nose.readthedocs.org/en/latest/)
2.  [Unittest Documentation](https://docs.python.org/2/library/unittest.html)
3.  [Writing Tests with Nose](https://nose.readthedocs.org/en/latest/writing_tests.html)