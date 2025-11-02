#!/bin/bash

# Simple script to install git pre-commit hook
# Copies the hook script to .git/hooks/pre-commit
#
# This script can be run manually or via postinstall hook

set -e

# Only install if .git exists (we're in a git repo)
if [ ! -d ".git" ]; then
    echo "??  Not in a git repository, skipping hook installation"
    exit 0
fi

# Verify hook source exists
if [ ! -f "scripts/pre-commit-check.sh" ]; then
    echo "??  Warning: scripts/pre-commit-check.sh not found, skipping hook installation"
    exit 0
fi

# Install the hook
mkdir -p .git/hooks
cp scripts/pre-commit-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "? Pre-commit hook installed"
