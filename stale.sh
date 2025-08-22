#!/bin/bash
# Usage: ./stale.sh <git_repo_path>

REPO_PATH="$1"

[ -d "$REPO_PATH" ] || { echo "Invalid git repo path"; exit 1; }
cd "$REPO_PATH" || exit 1

FILES=$(git ls-files)

SECONDS_IN_DAY=$((24*60*60))
SECONDS_IN_HOUR=$((60*60))
SECONDS_IN_MINUTE=60

for file in $FILES; do
  last_commit=$(git log -1 --format="%ct" -- "$file")
  seconds_ago=$(( $(date +%s) - last_commit ))

  days=$(( $seconds_ago / $SECONDS_IN_DAY ))
  hours=$(( ($seconds_ago % $SECONDS_IN_DAY) / $SECONDS_IN_HOUR ))
  minutes=$(( ($seconds_ago % $SECONDS_IN_HOUR) / $SECONDS_IN_MINUTE ))
  seconds=$(( $seconds_ago % $SECONDS_IN_MINUTE ))

  echo -n "$file: "
  [[ $days -gt 0 ]] && echo -n "${days}d "
  [[ $hours -gt 0 ]] && echo -n "${hours}h "
  [[ $minutes -gt 0 ]] && echo -n "${minutes}m "
  echo "${seconds}s ago"
done | sort -nr -k2 | head -20
