#!/bin/bash

HOOK_SOURCE="./pre-push"
CMAKE_UPDATER="./bump_cmake_version.sh"

for repo in ../*/.git; do
    # Skip version_prompter directory
    if [[ "$repo" == *"/version_prompter/.git" ]]; then
        continue
    fi
    hooks_dir="$repo/hooks"
    if [ -d "$hooks_dir" ]; then
        cp "$HOOK_SOURCE" "$hooks_dir/pre-push"
        chmod +x "$hooks_dir/pre-push"
        cp "$CMAKE_UPDATER" "$hooks_dir/bump_cmake_version.sh"
        chmod +x "$hooks_dir/bump_cmake_version.sh"
        echo "Installed pre-push hook and bump_cmake_version.sh in $hooks_dir"
    fi
done