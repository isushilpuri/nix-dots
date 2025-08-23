#!/usr/bin/env bash
set -euo pipefail

# Go to nix-dots repo
pushd ~/nix-dots/home/

rm -f home-switch.log

# Show diff of nix files
git diff -U0 *.nix

# Rebuild Home Manager, log output
echo "Home Manager Rebuilding..."
if ! home-manager switch --flake .#v0idshil &>home-switch.log; then
    grep --color=always "error" home-switch.log || true
    exit 1
fi

# Get current generation
gen=$(home-manager generations | grep current)

# Commit changes if there are any
if ! git diff --quiet; then
    git commit -am "Home Gen $gen"
    echo "Changes committed."
else
    echo "No changes to commit."
fi

# Return to original directory
popd

