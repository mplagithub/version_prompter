#!/bin/bash

for repo in ../*/.git; do
    # Skip version_prompter directory
    if [[ "$repo" == *"/version_prompter/.git" ]]; then
        continue
    fi
    hooks_dir="$repo/hooks"
    if [ -d "$hooks_dir" ]; then
        rm -f "$hooks_dir/pre-push"
        rm -f "$hooks_dir/bump_cmake_version.sh"
        echo "Removed pre-push hook and bump_cmake_version.sh from $hooks_dir"
    fi
done