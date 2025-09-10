#!/bin/bash

# Usage: ./mostch.sh <git_repo_path>

if [ -z "$1" ]; then
  echo "Usage: $0 <git_repo_path>"
  exit 1
fi

cd "$1" || { echo "Error: cannot enter directory $1"; exit 1; }

git log --pretty=format: --name-only \
  | grep -v '^$' \
  | sort \
  | uniq -c \
  | sort -rg \
  | head -10