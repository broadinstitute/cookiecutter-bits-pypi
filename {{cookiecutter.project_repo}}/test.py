#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Test script which demos module functionality."""

import os
import sys

# add bitsapiclient to the path
MYPATH = os.path.dirname(os.path.realpath(__file__))
sys.path.append(os.path.join(MYPATH, "bits"))

from bits.{{ cookiecutter.project_slug }} import Example


def main():
    """Execute the main function."""
    exa = Example()
    print(exa)


if __name__ == '__main__':
    main()
