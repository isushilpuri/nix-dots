#!/usr/bin/env bash
set -euo pipefail

# Go to nix-dots repo
pushd ~/nix-dots/home/

rm -f home-switch.log

# Show diff of nix files
git diff -U0 -- '*.nix'

read -rp "Do you want to proceed with Home Manager rebuild? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    popd
    exit 0
fi

# # Rebuild Home Manager, log output
# echo "Home Manager Rebuilding..."
# if ! home-manager switch --flake .#v0idshil &>home-switch.log; then
#     grep --color=always "error" home-switch.log || true
#     exit 1
# fi

echo "Home Manager Rebuilding..."
# Run home-manager, log everything
home-manager switch --flake .#v0idshil --show-trace 2>&1 | tee home-switch.log \
    | grep --line-buffered -E --color=never 'downloading|building|evaluating|copying' &

pid=$!
wait $pid
status=${PIPESTATUS[0]}  # Exit status of home-manager

if [ $status -ne 0 ]; then
    echo -e "\n Build failed:\n"
    grep --color=always -i "error" home-switch.log || true
    popd > /dev/null
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
