#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Install {{ cookiecutter.project_slug }}."""

import io
{% if cookiecutter.use_circleci == 'y' or cookiecutter.use_travisci == 'y' -%}
import os
import sys
{% endif %}
from setuptools import find_packages
from setuptools import setup
from setuptools.command.install import install

VERSION = "{{ cookiecutter.version }}"


def get_long_description():
    """Retrieve the long description from the README file."""
    # Use io.open to support encoding on Python 2 and 3
    fileh = io.open("README.md", "r", encoding="utf8")
    desc = fileh.read()
    fileh.close()

    return desc


# This was a great idea!! https://github.com/levlaz/circleci.py/blob/master/setup.py
{% if cookiecutter.use_circleci == 'y' or cookiecutter.use_travisci == 'y' -%}
class VerifyVersionCommand(install):
    """Verify that the git tag matches our version."""
    description = "verify that the git tag matches our version"

    def run(self):
        """Check the environment variable representing the tag name against the recorded version."""
{%- if cookiecutter.use_circleci == 'y' %}
        tag = os.getenv("CIRCLE_TAG")
{%- endif %}
{%- if cookiecutter.use_travisci == 'y' %}
        tag = os.getenv("TRAVIS_TAG")
{%- endif %}
        if tag != VERSION:
            info = "Git tag: {0} does not match the version of this app: {1}".format(tag, VERSION)
            sys.exit(info)
{% else -%}
class VerifyVersionCommand(install):
    """Verify that the git tag matches our version."""
    description = "verify that the git tag matches our version"

    def run(self):
        """There are no checks, so just return."""
        return
{% endif -%}
# end of function (for templating)


setup(
    name="{{ cookiecutter.project_slug }}",
    version=VERSION,
    author="{{ cookiecutter.full_name }}",
    author_email="{{ cookiecutter.email }}",
    description="{{ cookiecutter.project_short_description }}",  # pylint:disable max-line-length
    include_package_data=True,
    keywords=[],
    license="{{ cookiecutter.open_source_license }}",
    long_description=get_long_description(),
    long_description_content_type="text/markdown",
    packages=find_packages(exclude=("tests")),
    url="https://github.com/broadinstitute/{{ cookiecutter.project_repo }}",
    classifiers=[
        "Programming Language :: Python",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
    ],
    install_requires=[],
    python_requires=">=2.7, <4",
    setup_requires=["setuptools_scm"],
    cmdclass={"verify": VerifyVersionCommand},
)
