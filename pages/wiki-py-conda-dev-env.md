---
title: Creating a Conda development environment
permalink: /wiki-py-conda-dev-env/
menu_item: false
---
# Creating a Conda development environment

One of the advantages of the Anaconda Python environment is that it is cheap to set up (and discard) Python environments for development versions of packages and populate them with your favorite scientific tools. For example, if you’re working on `QuantEcon.py` you might find it useful to set up an environment (containing NumPy, SciPy, etc.) that uses your development version rather than the default one. This facilitates contributing to `QuantEcon.py` without worrying about corrupting the Python environment on which your other work depends.

Googling will locate plenty of tutorials on setting up Conda environments but here’s a quick start. It assumes that you’ve already installed Anaconda.

## Step 1:

[Fork and clone](https://help.github.com/articles/fork-a-repo) a copy of the `QuantEcon.py` repository on to your local machine.

## Step 2:

Create a `conda` environment called `quantecon-dev` (say) by opening a terminal and typing

    conda create -n quantecon-dev anaconda

## Step 3:

Activate the `quantecon-dev` environment:

    source activate quantecon-dev

## Step 4:

Change into your local copy of the `quantecon` repo. For example, on a UNIX-like system, type

    cd /PATH/TO/LOCAL/CLONE/

## Step 5:  

Install your local version of `quantecon`. If you’re at the top of the repo directory tree (where the file setup.py exists) then type

    python setup.py install

Instead you may wish to install a developer copy which allows for changes to take effect immediately. Rather than copying files to site-packages this command will make symbolic links instead.The above command installs quantecon into the local site-packages folder on your machine. If you make changes you will need to rerun the command for changes to be installed into site-packages.

    python setup.py develop

## Other useful commands  

To switch into the `quantecon-dev` Conda environment:

    source activate quantecon-dev

To shift back to your default Python environment type

    source deactivate

To delete the environment type

    conda remove -n quantecon-dev --all

To list all environments try

    conda info -e
