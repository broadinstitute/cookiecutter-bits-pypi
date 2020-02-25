# cookiecutter-bits-pypi

This is a collection of standard files that are typically needed for most [Python][1]-related repositories.  Not all files in this repository may be needed for **every** [Python][1] project, but it's a good collection of common tools and configurations to which you can refer.

## New repository

To create a new repository using this template, the first thing you will need is the **cookiecutter** [Python][1] module, which you can install with `pip`:

```sh
pip install cookiecutter
```

Once you have that, you create the new repository with a command such as:

```sh
cookiecutter -o . https://github.com/broadinstitute/cookiecutter-bits-pypi.git
```

This command will create a new repository in the current directory using this template.  You will then need to answer all questions asked by **cookiecutter**, which will create a directory with your new repository setup.  You can then `cd` to this directory and run `git init` to make it a git repository.

## Updating a repository created by this template

A separate [Python][1] module (**scaraplate**) is used to update a repository that was created with a previous revision of this template.  This module can be installed with `pip`:

```sh
pip install scaraplate
```

**scaraplate** also requires the template to be cloned to a local directory:

```sh
cd /tmp
git clone https://github.com/broadinstitute/cookiecutter-bits-pypi.git
```

Now, you can `cd` into the directory where your repository directory lives (i.e. not the actual repository itself).  The directory is assumed to be `python-package_name` in this example.  Use `scaraplate` to update your repository to the latest configuration:

```sh
scaraplate rollup /tmp/cookiecutter-bits-pypi python-package_name
```

You will have to confirm the answers (by just hitting Enter) from the original `cookiecutter` creation of this repository.  This should update all the templated files that come from this repository and leave all the other files in your current repository alone.

## Updating a repository to use this template

This process is a bit more involved than just using the template given that `cookiecutter` will overwrite a directory completely if you point it at a pre-existing repository.  Therefore, the best method is to:

* Run `cookiecutter` to create a new repository with the same name and settings that would match the repository you want to convert.
* Go to your original repository and create a new branch.
* Copy any non-conflicting files from the original repository to this new repository.
* Copy the `.git` directory from the original repository to this new templated repository.

When you do a `git diff` now, you should just see the new files that `cookiecutter` added.  You should then commit these changes to the new branch to save the changes `cookiecutter` has made.

To test that future updates using `scaraplate` won't overwrite any inappropriate files, you should then use the `scaraplate` procedure to update this new branch and make sure no changes were made, since the template should presumably be up to date.

## Files

This is a just brief overview of the files.

### .gitignore

This is a sample `.gitignore` that just ignores all files.  This is primarily here as a protection for this repository so that files need to be added to the repository forcefully using `-f`.  A normal repository will have a far less restrictive `.gitignore`.

### .pre-commit-config.yaml

This is a config for [pre-commit][2], which is a library to control pre-commit hooks for Git.  These are just the standard ones BITS uses in [Python][1] repositories.

### .pylintrc

This is the BITS standard configuration file for the [pylint][3] [Python][1] linting application.

### .travis.yml

This is a sample [TravisCI][4] configuration file that can be used to run [TravisCI][4] jobs for commits to your repository for unit tests, linting, etc.  It currently supports:

* [Python][1] versions 2.7, 3.4, 3.5, and 3.6
* Pip package installation using [pipenv][5]
* Unit tests using [green][6]
* A pre-flight stage that runs [yamllint][7] and [pylama][8] on the whole codebase

### .yamllint

This is the BITS standard configuration file for the [yamllint][7] YAML linting application.

### dev.sh

This is a simple script that starts up or builds a development environment in [Docker][9].  The way it works is it looks for an image by the name specified at the top of the script.  If that image doesn't exist, it uses the `Dockerfile` in the local directory to build the image.  You are then dropped into a bash shell inside that container under the `/usr/src` path.  The present working directory outside the container is volume mapped to `/usr/src` inside the container as well.

### Dockerfile

This is a sample `Dockerfile` that can be used to create a [Python][1] container for use as a development environment for whatever Python][1] configuration you wish to use.  By default, it uses [Python][1] 3.6 and [pipenv][5] to install packages.

### LICENSE.txt

The default license approved for use at the Broad Institute (BSD 3-Clause "New" or "Revised" License).

### Pipfile (deprecated)

The file used by [pipenv][5] to install PyPi packages.  This file will be removed in a later release as [Poetry][11] is now the default dependency manager.

### pylama.ini

This is the BITS standard configuration file for the [pylama][8] [Python][1] linting application.

### pyproject.toml

The file used by [Poetry][11] to install PyPi packages.  [Poetry][11] is now the default dependency manager used in place of [pipenv][5].  There is a default list of packages included in this file to start.  Obviously, more packages will probably be needed depending on the project.

## BITS-specific repos

For BITS repos (named **bits-_reponame_**), be careful when answering the questions asked by cookiecutter.  For example, suppose we are making a new project to automate the **widget** service:

* **project_repo**: Make sure this is set to **bits-widget**
* **project_slug**: Make sure this is set to just **widget**
* **pypi_repo**: Make sure this is set to **bits-widget**

This has to do with the templates used to generate the repository.  They all require these values set in this manner for all the parts to line up correctly.

[1]: https://www.python.org/ "Python"
[2]: https://pre-commit.com/ "pre-commit"
[3]: https://www.pylint.org/ "pylint"
[4]: https://travis-ci.com/ "TravisCI"
[5]: https://pipenv.readthedocs.io/en/latest/ "pipenv"
[6]: https://github.com/CleanCut/green "green"
[7]: https://github.com/adrienverge/yamllint "yamllint"
[8]: https://github.com/klen/pylama "pylama"
[9]: https://www.docker.com/ "Docker"
[10]: https://code.visualstudio.com/ "VS Code"
[11]: https://python-poetry.org/ "Poetry"
