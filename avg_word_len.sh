#!/bin/bash
# Usage: ./avg_word_len.sh <file>
file="$1"
[ -f "$file" ] || { echo "0"; exit 0; }

tr -s '[:space:]' '\n' < "$file" | awk 'length>0 {sum+=length; n++} END{if(n>0) print sum/n; else print 0}'