#!/bin/bash

# Usage: ./update_cmake_version.sh [major|minor|patch] [file-path]
if [[ $# -ne 2 || ! "$1" =~ ^(major|minor|patch)$ ]]; then
    echo "Usage: $0 [major|minor|patch] [file-path]"
    exit 1
fi

BUMP="$1"
FILE="$2"

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT" || exit 1

new_version_line=$(grep -E 'project\([^)]+VERSION[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' "$FILE")

# Extract the version number
version=$(echo "$new_version_line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
if [[ -z "$version" ]]; then
    echo "ERROR: No version found in $FILE"
    echo "Expected line matching: project\([^)]+VERSION[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+"
    echo "Exiting correctly, but version WAS NOT UPDATED"
    exit 0
fi

IFS='.' read -r major minor patch <<< "$version"
case "$BUMP" in
    major)
        new_version="$((major+1)).0.0"
        ;;
    minor)
        new_version="$major.$((minor+1)).0"
        ;;
    patch)
        new_version="$major.$minor.$((patch+1))"
        ;;
esac

# Replace only the version in this line
new_line=$(echo "$new_version_line" | sed "s/$version/$new_version/")
# Use sed to replace the line in the file
sed -i "s|$new_version_line|$new_line|" "$FILE"
echo "Updated $FILE: $version -> $new_version"