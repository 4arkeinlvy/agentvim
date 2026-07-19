#!/usr/bin/env bash
# Parallel-agent worktrees: give each AI agent its own working tree so two
# agents can implement simultaneously without trampling each other
# (docs/agent-orchestration.md — the one-writer rule, scaled out).
#
#   scripts/worktree.sh add fix-auth     -> ../<repo>-fix-auth  (branch agent/fix-auth)
#   scripts/worktree.sh ls
#   scripts/worktree.sh rm  fix-auth     -> removes tree, keeps the branch
set -euo pipefail

cmd="${1:-ls}" name="${2:-}"
root=$(git rev-parse --show-toplevel)
repo=$(basename "$root")

case "$cmd" in
  add)
    [ -n "$name" ] || { echo "usage: worktree.sh add <name>" >&2; exit 1; }
    dest="$root/../$repo-$name"
    git worktree add -b "agent/$name" "$dest"
    echo "Ready: $dest (branch agent/$name)"
    echo "Next:  tmux new-window -c '$dest' — run your second agent there."
    ;;
  rm)
    [ -n "$name" ] || { echo "usage: worktree.sh rm <name>" >&2; exit 1; }
    git worktree remove "$root/../$repo-$name"
    echo "Removed tree. Branch agent/$name kept — merge or delete it:"
    echo "  git branch -d agent/$name"
    ;;
  ls) git worktree list ;;
  *) echo "usage: worktree.sh {add|rm|ls} [name]" >&2; exit 1 ;;
esac
