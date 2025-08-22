#!/usr/bin/env python3

# Usage: ./histage.py <directory>
# This script generates a histogram of file ages in a git repository.

import os
import sys
import subprocess
import matplotlib.pyplot as plt
from datetime import datetime

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <directory>")
    sys.exit(1)

target_dir = os.path.abspath(sys.argv[1])
original_cwd = os.getcwd()
os.chdir(target_dir)

try:
    git_root = subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"]
    ).decode().strip()
except subprocess.CalledProcessError:
    print("Not a git repository.")
    sys.exit(1)

file_ages = []

for root, dirs, files in os.walk("."):
    for f in files:
        abs_path = os.path.join(root, f)
        try:
            ts = subprocess.check_output(
                ["git", "log", "-1", "--format=%ct", abs_path],
                stderr=subprocess.DEVNULL
                ).strip()
            if ts:  # only process if there's output
                age = (datetime.now() - datetime.fromtimestamp(int(ts))).days
                file_ages.append(age)
        except subprocess.CalledProcessError:
            continue

os.chdir(original_cwd)

if not file_ages:
    print("No files with Git history found.")
    sys.exit(0)

plt.hist(file_ages, bins=50, color='red')
plt.title("Codebase File Age Histogram")
plt.xlabel("Days Since Last Edit")
plt.ylabel("File Count")
plt.grid(True)
plt.show()