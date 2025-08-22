#!/bin/bash
# Usage: ./obfuscation.sh <git_repo_path> [subdir]

# This script analyzes files in a git repo and returns top 10 files likely to be obfuscated
# The scoring is based on entropy, space ratio, and average word length and is not perfect
# There are far better scripts that do this way better but this is my implementation for learning purposes

# The script relies on 3 helper scripts found in the same directory

REPO_PATH="$1"
SUBDIR="$2"

[ -d "$REPO_PATH" ] || { echo "Invalid git repo path"; exit 1; }
cd "$REPO_PATH" || exit 1

if [ -n "$SUBDIR" ]; then
	FILES=$(git ls-files "$SUBDIR")
else
	FILES=$(git ls-files)
fi

for f in $FILES; do
	[ -f "$f" ] || continue

	# helper scripts
	entropy=$(bash ./entropy.sh "$f")
	space_ratio=$(bash ./space_ratio.sh "$f")
	avg_word_len=$(bash ./avg_word_len.sh "$f")

	score=$(awk -v e="$entropy" -v s="$space_ratio" -v w="$avg_word_len" 'BEGIN{print (s*2) + (w/5) + (8-e)}')
	echo "$score $f"
done | sort -nr | head -10