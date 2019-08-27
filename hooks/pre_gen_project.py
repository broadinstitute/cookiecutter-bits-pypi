#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Run pre-generation actions for the project."""

import re
import sys


MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

MODULE_NAME = "{{ cookiecutter.project_slug}}"

if not re.match(MODULE_REGEX, MODULE_NAME):
    print("ERROR: The project slug (%s) is not a valid Python module name." % MODULE_NAME)
    print("Please do not use a - and use _ instead")

    # Exit to cancel project
    sys.exit(1)

if ("{{ cookiecutter.use_travisci}}" == "y") and ("{{ cookiecutter.use_circleci}}" == "y"):
    print("ERROR: You cannot build on both CircleCI and TravisCI.  Pick one.")

    # Exit to cancel project
    sys.exit(2)

if ("{{ cookiecutter.use_pytest}}" == "y") and ("{{ cookiecutter.use_green}}" == "y"):
    print("ERROR: You cannot test with both pytest and green.  Pick one.")

    # Exit to cancel project
    sys.exit(2)
