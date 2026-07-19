#!/usr/bin/env bash
# Update AgentVim: pull the repo, sync plugins to its lockfile, update parsers.
set -euo pipefail
CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

echo "==> Pulling latest AgentVim"
git -C "$CFG" pull --ff-only

echo "==> Syncing plugins to lockfile"
nvim --headless "+Lazy! restore" +qa

echo "==> Updating treesitter parsers"
nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true

echo "==> Done. Language-server updates: open nvim, run :Mason, press U."
