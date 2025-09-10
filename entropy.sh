#!/bin/bash

# Usage: ./entropy.sh <file>

file="$1"
[ -f "$file" ] || { echo "0"; exit 0; }

content=$(tr -d '\n\r' < "$file" | fold -w1 | sort | uniq -c)
total=$(echo "$content" | awk '{s+=$1} END{print s}')

if [ "$total" -eq 0 ]; then
    echo "0"
    exit 0
fi

awk -v total="$total" '
{
    p = $1/total
    h += -p*log(p)/log(2)
}
END {
    if (h == "") h = 0
    print h
}' <<< "$content"