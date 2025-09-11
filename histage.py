#!/usr/bin/env python3

# Usage: ./histage.py [--mode=creation|lastedit] <directory>
# This script generates a histogram of file ages in a git repository.

import os
import sys
import subprocess
import matplotlib.pyplot as plt
from datetime import datetime

if len(sys.argv) < 2 or len(sys.argv) > 3:
    print(f"Usage: {sys.argv[0]} [--mode=creation|lastedit] <directory>")
    sys.exit(1)

mode = "creation"  # default
data_color = "blue"

if sys.argv[1].startswith("--mode="):
    mode_val = sys.argv[1].split("=")[1]
    if mode_val in ("creation", "lastedit"):
        mode = mode_val
    else:
        print("Invalid mode. Choose 'creation' or 'lastedit'.")
        sys.exit(1)

    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} [--mode=creation|lastedit] <directory>")
        sys.exit(1)

    target_dir = os.path.abspath(sys.argv[2])
else:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} [--mode=creation|lastedit] <directory>")
        sys.exit(1)
    target_dir = os.path.abspath(sys.argv[1])

original_cwd = os.getcwd()
os.chdir(target_dir)

try:
    subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
except subprocess.CalledProcessError:
    print("Not a git repository.")
    sys.exit(1)

file_ages = []

for root, dirs, files in os.walk("."):
    for f in files:
        abs_path = os.path.join(root, f)
        try:
            if mode == "creation":
                ts = subprocess.check_output(
                    ["git", "log", "--diff-filter=A", "--format=%ct", "--", abs_path],
                    stderr=subprocess.DEVNULL
                ).strip()
                data_color = "blue"
            else:  # lastedit
                ts = subprocess.check_output(
                    ["git", "log", "-1", "--format=%ct", "--", abs_path],
                    stderr=subprocess.DEVNULL
                ).strip()
                data_color = "red"

            if ts:
                age = (datetime.now() - datetime.fromtimestamp(int(ts))).days
                file_ages.append(age)
        except subprocess.CalledProcessError:
            continue

os.chdir(original_cwd)

if not file_ages:
    print("No files with Git history found.")
    sys.exit(0)

plt.hist(file_ages, bins=50, color=data_color)
plt.title(f"Codebase File Age Histogram ({mode})")
plt.xlabel("Days Since " + ("Creation" if mode == "creation" else "Last Edit"))
plt.ylabel("File Count")
plt.grid(True)
plt.show()
