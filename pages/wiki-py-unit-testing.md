---
title: Unit Testing in QuantEcon
permalink: /wiki-py-unit-testing/
menu_item: false
---
# Unit Testing in QuantEcon

## Summary

The QuantEcon package uses [pytest](https://docs.pytest.org/) to manage tests. We adhere to some conventions to facilitate ease of maintenance and management of test cases. The main conventions are as follows:

*   Tests live in Python files, which in turn live in `quantecon/tests/`
*   These test files should be prepended with `test_` followed by module name (e.g., tests for `asset_pricing.py` should be found in `quantecon/tests/test_asset_pricing.py`).
*   Test files should contain test functions prefixed with `test_`.

## Test Fundamentals

The basic premise of testing in Python is to write functions that make assertions. An assertion checks a given logical condition. If the condition is met, then the program continues onto the next line. If not, the assertion will trigger an Exception and issue an `AssertionError`. Here's a simple example:

```python
def test_equal(a, b):
    """
    This tests for equality between two arguments a and b
    """
    assert a == b, "Test failed: Arguments are not equal."
```

If `a=2` and `b=1` then this test would fail and raise an `AssertionError` with the message string after the comma.

pytest parses Python files in the QuantEcon repository and collects all tests (i.e., all functions that satisfy the test naming convention discussed below). It then runs them one by one and provides you with a report of which passed and which failed.

To run the test suite, you need to type `pytest` at the command line, or `pytest -v` for a more verbose report.

### Test Function Names

When `pytest` parses the repository looking for tests, it will search for functions prefixed with `test_`. Examples:

*   `test_somethinghere`
*   `test_my_function_returns_correct_value`

When naming your test function, remember to use PEP8 convention. Also make sure you clearly indicate what part of a module (be it a function or class etc.) that your test is testing.

### Assertion Methods

While it's fine to construct your own logic and messaging using `assert` statements as above, note that there are also many helpful pre-existing assertion methods available in other packages, such as

1.  [numpy.testing](https://numpy.org/doc/stable/reference/routines.testing.html)
2.  [pandas.testing](https://pandas.pydata.org/docs/reference/testing.html)

These packages are used throughout QuantEcon, so it is safe to use functions and methods from them directly using import statements such as:

```python
from numpy.testing import assert_allclose
```

This particular function is useful in testing if an array matches a known solution, allowing for a degree of tolerance through the `rtol=` relative tolerance or `atol=` absolute tolerance keyword arguments.

To learn more, you can browse some of the files in `quantecon/tests/` and learn from these examples.

### Example: A Basic Test

Let's look at an example, concerning a basic test for the `mc_compute_stationary` function from the `mc_tools.py` module.

We will use a known matrix and compute its stationary distribution.

$$ P := \left( \begin{array}{cc} 0.4 & 0.6 \\ 0.2 & 0.8 \end{array} \right) $$

We know that the unique stationary distribution should be (0.25, 0.75)

Now let's write a test case in the file: `tests/test_mc_tools.py`:

```python
import numpy as np
from numpy.testing import assert_allclose
from quantecon import mc_compute_stationary

def test_mc_compute_stationary_pmatrix():
    """
    Test mc_compute_stationary for a Known Solution of Matrix P
    """
    P = np.array([[0.4, 0.6], [0.2, 0.8]])
    P_known = np.array([0.25, 0.75])
    computed = mc_compute_stationary(P)
    assert_allclose(computed, P_known)
```

Note: We use `assert_allclose` rather than exact equality because computed results and perfect analytical results are often very close but not quite equal due to floating point precision.

### Making Tests More General

You can use pytest's parametrize decorator to run the same test with multiple inputs:

```python
import pytest
import numpy as np
from numpy.testing import assert_allclose
from quantecon import mc_compute_stationary

@pytest.mark.parametrize("P,expected", [
    (np.array([[0.4, 0.6], [0.2, 0.8]]), np.array([0.25, 0.75])),
    (np.array([[1.0, 0.0], [0.0, 1.0]]), np.array([0.5, 0.5])),
])
def test_mc_compute_stationary_pmatrix(P, expected):
    """
    Test mc_compute_stationary for known solutions
    """
    computed = mc_compute_stationary(P)
    assert_allclose(computed, expected)
```

## Running Tests

To run all tests:

```bash
pytest
```

To run tests in a specific file:

```bash
pytest quantecon/tests/test_mc_tools.py
```

To run a specific test:

```bash
pytest quantecon/tests/test_mc_tools.py::test_mc_compute_stationary_pmatrix
```

## Resources

*   [pytest Documentation](https://docs.pytest.org/)
*   [NumPy Testing Guide](https://numpy.org/doc/stable/reference/routines.testing.html)
