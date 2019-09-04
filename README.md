# cookiecutter-bits-pypi

This is a collection of standard files that are typically needed for most [Python][1]-related repositories.  Not all files in this repository may be needed for **every** [Python][1] project, but it's a good collection of common tools and configurations to which you can refer.

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

### Dockerfile

This is a sample `Dockerfile` that can be used to create a [Python][1] container for use as a development environment for whatever Python][1] configuration you wish to use.  By default, it uses [Python][1] 3.6 and [pipenv][5] to install packages.

### LICENSE.txt

The default license approved for use at the Broad Institute (BSD 3-Clause "New" or "Revised" License).

### Pipfile

The file used by [pipenv][5] to install PyPi packages.  This is a default list and is meant as a base configuration for your project.  Obviously, more packages will probably be needed depending on the project.

### dev.sh

This is a simple script that starts up or builds a development environment in [Docker][9].  The way it works is it looks for an image by the name specified at the top of the script.  If that image doesn't exist, it uses the `Dockerfile` in the local directory to build the image.  You are then dropped into a bash shell inside that container under the `/usr/src` path.  The present working directory outside the container is volume mapped to `/usr/src` inside the container as well.

### pylama.ini

This is the BITS standard configuration file for the [pylama][8] [Python][1] linting application.

## VS Code

If you use workspaces in [VS Code][10], you can clone this repository in the base directory of your workspace.  You can then use [pipenv][5] to install the packages listed in the `Pipfile`.  You will need to make sure [pipenv][5] installs into a `.venv` directory under the workspace directory.  To do this, you can run [pipenv][5] as follows:

```sh
PIPENV_VENV_IN_PROJECT=1 pipenv lock
PIPENV_VENV_IN_PROJECT=1 pipenv install --dev
```

The `PIPENV_VENV_IN_PROJECT=1` environment variable setting makes sure that the virtual environment is stored in the local project directory instead of a different temporary directory [pipenv][5] typically uses.

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
