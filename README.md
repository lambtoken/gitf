# Git forensics scripts

A university project.

Variety of scripts that do different things.

## Scripts

1. histage (py)
    - Generates a histogram of file ages
    - Uses matplotlib
2. mostch (bash)
    - Returns a list of most changed files
3. obfuscation (bash)
    - A naive way of determining obfuscation rate of files
    - Composed of 3 parts/scripts: entropy.sh, space_ratio.sh, avg_word_len.sh
    - Uses Git, awk, tr
4. stale_files (bash)
    - Caclulates how long has been since the files have been changed. Returns up to 20 most stale files.