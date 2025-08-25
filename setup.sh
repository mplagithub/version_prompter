#!/bin/bash

HOOK_SOURCE="pre-commit"

for repo in ../*/.git; do
    hooks_dir="$repo/hooks"
    if [ -d "$hooks_dir" ]; then
        cp "$HOOK_SOURCE" "$hooks_dir/pre-commit"
        chmod +x "$hooks_dir/pre-commit"
        echo "Installed pre-commit hook in $hooks_dir"
    fi
done