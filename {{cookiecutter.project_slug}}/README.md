{% set is_open_source = cookiecutter.open_source_license != 'Not open source' -%}
{% for _ in cookiecutter.project_name %}# {{ cookiecutter.project_name }}{% endfor %}

{{ cookiecutter.project_short_description }}

{% if cookiecutter.is_open_source %}
.. image:: https://img.shields.io/pypi/v/{{ cookiecutter.project_slug }}.svg
        :target: https://pypi.python.org/pypi/{{ cookiecutter.project_slug }}

{% if cookiecutter.use_circleci %}
[![CircleCI](https://circleci.com/gh/broadinstitute/{{ cookiecutter.project_slug }}/tree/master.svg?style=svg)](https://circleci.com/gh/broadinstitute/{{ cookiecutter.project_slug }}/tree/master)
{%- endif %}

{% if cookiecutter.use_travisci %}
.. image:: https://img.shields.io/travis/broadinstitute/{{ cookiecutter.project_slug }}.svg
        :target: https://travis-ci.org/broadinstitute/{{ cookiecutter.project_slug }}
{%- endif %}

{% if cookiecutter.use_codecov %}
[![codecov](https://codecov.io/gh/broadinstitute/{{ cookiecutter.project_slug }}/branch/master/graph/badge.svg)](https://codecov.io/gh/broadinstitute/{{ cookiecutter.project_slug }})
{%- endif %}
{%- endif %}

{% if cookiecutter.add_pyup_badge == 'y' %}
[![pyup](https://pyup.io/repos/github/broadinstitute/{{ cookiecutter.project_slug }}/shield.svg)](https://pyup.io/repos/github/broadinstitute/{{ cookiecutter.project_slug }})
{% endif %}

## Basics

Basic information about the package

## Features

A list of features this package provides

## Installing

How do you install this package?

## Examples

Code examples using this package

## Contributing

Pull requests to add functionality and fix bugs are always welcome.  Please check the CONTRIBUTING.md for specifics on contributions.

### Testing

How do you run unit tests on the code in this repo?

## Releases

Releases to the codebase are typically done using the [bump2version][2] tool.  This tool takes care of updating the version in all necessary files, updating its own configuration, and making a GitHub commit and tag.  We typically do version bumps as part of a PR, so you don't want to have [bump2version][2] tag the version at the same time it does the commit as commit hashes may change.  Therefore, to bump the version a patch level, one would run the command:

```sh
bump2version --verbose --no-tag patch
```

Once the PR is merged, you can then checkout the new master branch and tag it using the new version number that is now in `.bumpversion.cfg`:

```sh
git checkout master
git pull --rebase
git tag 1.0.0 -m 'Bump version: 0.1.0 → 1.0.0'
git push --tags
```

# Credits

This package was created with Cookiecutter_ and the `broadinstitute/cookiecutter-bits-pypi`_ project template.

* [Cookiecutter][3]
* [https://github.com/broadinstitute/cookiecutter-bits-pypi](broadinstitute/cookiecutter-bits-pypi)

[1]: https://www.python.org/ "Python"
[2]: https://pypi.org/project/bump2version/ "bump2version"
[3]: https://cookiecutter.readthedocs.io/en/latest/index.html "Cookiecutter"
