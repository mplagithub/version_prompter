#!/bin/bash

# Usage: ./update_cmake_version.sh [major|minor|patch]
if [[ $# -ne 1 || ! "$1" =~ ^(major|minor|patch)$ ]]; then
    echo "Usage: $0 [major|minor|patch]"
    exit 1
fi

BUMP="$1"

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT" || exit 1

find . -type d -name .cs -prune -o -name CMakeLists.txt -print | while read -r file; do
    new_version_line=$(grep -E 'project\([^)]+VERSION[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' "$file")

    echo "$new_version_line" | while read -r line; do
        # Extract the version number
        version=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        if [[ -z "$version" ]]; then
            continue
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
        new_line=$(echo "$line" | sed "s/$version/$new_version/")
        # Use sed to replace the line in the file
        sed -i "s|$line|$new_line|" "$file"
        echo "Updated $file: $version -> $new_version"
    done
done