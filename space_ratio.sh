#!/bin/bash
# Usage: ./space_ratio.sh <file>
file="$1"
[ -f "$file" ] || { echo "0"; exit 0; }

total=$(wc -c < "$file")
spaces=$(tr -cd ' \t\n\r' < "$file" | wc -c)
awk -v t="$total" -v s="$spaces" 'BEGIN{if(t>0) print 1-(s/t); else print 0}'
