#!/usr/bin/env python
"""Run pre-generation actions for the project."""

import re
import sys

MODULE_REGEX = r"^[_a-zA-Z][_a-zA-Z0-9]+$"

MODULE_NAME = "{{ cookiecutter.project_slug }}"

if not re.match(MODULE_REGEX, MODULE_NAME):
    print("ERROR: The project slug (%s) is not a valid Python module name." % MODULE_NAME)
    print("Please do not use a - and use _ instead")

    # Exit to cancel project
    sys.exit(1)

ci_check = [
    "{{ cookiecutter.use_actions }}", "{{ cookiecutter.use_circleci }}", "{{ cookiecutter.use_travisci }}"
]
if ci_check.count("y") > 1:
    print("ERROR: You cannot use multiple CI systems.  Pick Actions, CircleCI or TravisCI.")

    # Exit to cancel project
    sys.exit(2)

dep_check = ["{{ cookiecutter.use_pipenv }}", "{{ cookiecutter.use_poetry }}"]
if dep_check.count("y") > 1:
    print("ERROR: You cannot use multiple dependency managers.  Pick pipenv or poetry.")

    # Exit to cancel project
    sys.exit(2)

test_check = ["{{ cookiecutter.use_pytest }}", "{{ cookiecutter.use_green }}"]
if test_check.count("y") > 1:
    print("ERROR: You cannot use multiple unit test frameworks.  Pick either green or pytest.")

    # Exit to cancel project
    sys.exit(2)

test_check = ["{{ cookiecutter.use_pylama }}", "{{ cookiecutter.use_ruff }}"]
if test_check.count("y") > 1:
    print("ERROR: You cannot use multiple linters.  Pick either pylama or ruff.")

    # Exit to cancel project
    sys.exit(2)
