#!/bin/bash
#
# Helper script to output bash version which is tested
# Usage: ../version.sh >> VERSION

date +%Y%m%d-%H%M%S
dpkg -l bash | cat
bash --version

