#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Run post-generation actions for the project."""

import os

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath):
    """Remove a file from the project directory."""
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))


if __name__ == "__main__":

    if "{{ cookiecutter.use_travisci }}" != "y":
        remove_file(".travis.yml")

    if "{{ cookiecutter.use_circleci }}" == "y":
        remove_file(".circleci/config.yml")
        remove_file(".circleci/deploy.sh")
        remove_file(".circleci")

    if "Not open source" == "{{ cookiecutter.open_source_license }}":
        remove_file("LICENSE.txt")
