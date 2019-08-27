#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Run post-generation actions for the project."""

import logging
import os

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)
LOGGER = logging.getLogger(__name__)


def remove_file(filepath):
    """Remove a file from the project directory."""
    path = os.path.join(PROJECT_DIRECTORY, filepath)
    LOGGER.debug("Removing file %s", path)
    os.remove(path)


def remove_directory(dirpath):
    """Remove a directory from the project directory."""
    path = os.path.join(PROJECT_DIRECTORY, dirpath)
    LOGGER.debug("Removing directory %s", path)
    os.rmdir(path)


if __name__ == "__main__":

    if "{{ cookiecutter.use_circleci }}" != "y":
        remove_file(".circleci/config.yml")
        remove_file(".circleci/deploy.sh")
        remove_directory(".circleci")

    if "{{ cookiecutter.use_green }}" != "y":
        remove_file(".green")

    if "{{ cookiecutter.use_travisci }}" != "y":
        remove_file(".travis.yml")

    if "Not open source" == "{{ cookiecutter.open_source_license }}":
        remove_file("LICENSE")
