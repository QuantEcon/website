---
title: Additional Python Examples
permalink: python-examples
menu_item: false
---
# Additional Python Examples

## Example #1

### Creating a discrete approximation to an AR(1) process

The following code imports the `quantecon` library and creates a discrete approximation to an AR(1) process

    from quantecon import approx_markov
    states, matrix = approx_markov(0.9, 0.1, n=4)
    print(matrix)
    print(states)

In the below figure we are running this code interactively in an Jupyter notebook (See [here](https://lectures.quantecon.org/py/getting_started.html#jupyter) for more details on setting up [Jupyter](http://jupyter.org/)) and printing the results

![](/assets/img/test-qe.png)
