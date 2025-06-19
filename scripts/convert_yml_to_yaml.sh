#!/bin/bash

set -e

# If filenames are passed as arguments (pre-commit --all-files), use them.
if [[ $# -gt 0 ]]; then
  files="$@"
else
  # Otherwise, find all staged .yaml files
  files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.yaml$' || true)
fi

for file in $files; do
  # Skip if file does not exist (could be deleted or moved)
  [[ -f "$file" ]] || continue
  yaml_file="${file%.yaml}.yaml"
  cp "$file" "$yaml_file"
  git add "$yaml_file" 2>/dev/null || true
  git rm --cached "$file" 2>/dev/null || true
  rm "$file"
  echo "Converted $file to $yaml_file"
done

# Optionally, exit non-zero if any conversions happened (to force review)
