#!/bin/bash

# Usage: ./mostch.sh <git_repo_path>

# This script lists the top 10 most frequently changed files in a git repo

git log --pretty=format: --name-only | grep -v '^$' | sort | uniq -c | sort -rg | head -10