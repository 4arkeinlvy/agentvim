#!/usr/bin/env bash
# Remove AgentVim and offer to restore your newest pre-AgentVim backup.
# Leaves shared binaries (nvim, rg, fd, lazygit) alone — remove those
# yourself from ~/.local if you want them gone too.
set -euo pipefail
CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

printf 'This removes:\n  %s\n  %s\n  %s\n  %s\n' "$CFG" "$DATA" "$STATE" "$CACHE"
printf 'Continue? [y/N] '
read -r ans
[ "${ans:-n}" = "y" ] || { echo "Aborted."; exit 0; }

rm -rf "$CFG" "$DATA" "$STATE" "$CACHE"
echo "Removed."

backup=$(ls -dt "$CFG".bak.* 2>/dev/null | head -1 || true)
if [ -n "$backup" ]; then
  printf 'Restore your previous config from %s? [y/N] ' "$backup"
  read -r ans
  [ "${ans:-n}" = "y" ] && mv "$backup" "$CFG" && echo "Restored."
fi
echo "Done."
