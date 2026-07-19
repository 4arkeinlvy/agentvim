#!/usr/bin/env bash
# AgentVim verification — safe to run any time. Exits non-zero on failure.
set -u

CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
FAIL=0

pass() { printf '\033[1;32m  ✓\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m  ✗\033[0m %s\n' "$*"; FAIL=1; }
have() { command -v "$1" >/dev/null 2>&1; }

echo "AgentVim health report"

for bin in nvim git rg fd lazygit; do
  have "$bin" && pass "$bin ($(command -v "$bin"))" || fail "$bin missing"
done
have node && pass "node $(node --version)" || fail "node missing (LSPs need >= 18)"
have python3 && pass "python3" || fail "python3 missing"

if have nvim; then
  v=$(nvim --version | head -1 | grep -o '[0-9]\+\.[0-9]\+' | head -1)
  case "$v" in
    0.[0-9]) [ "${v#0.}" -ge 11 ] && pass "nvim version $v" || fail "nvim $v too old (need >= 0.11)" ;;
    *) pass "nvim version $v" ;;
  esac
fi

[ -f "$CFG/init.lua" ] && pass "config at $CFG" || fail "no config at $CFG"

if [ -d "$DATA/lazy" ]; then
  n=$(ls "$DATA/lazy" | wc -l | tr -d ' ')
  [ "$n" -gt 30 ] && pass "$n plugins installed" || fail "only $n plugins installed (expected ~49) — run nvim --headless '+Lazy! restore' +qa"
else
  fail "no plugins installed yet — launch nvim once"
fi

if [ -d "$DATA/mason/packages" ]; then
  n=$(ls "$DATA/mason/packages" | wc -l | tr -d ' ')
  [ "$n" -ge 10 ] && pass "$n Mason tools installed" || printf '\033[1;33m  !\033[0m %s\n' "$n Mason tools (more install on first launch)"
fi

if have nvim && nvim --headless "+lua vim.print('boot-ok')" +qa 2>&1 | grep -q "boot-ok"; then
  pass "headless boot clean"
else
  fail "headless boot produced errors — run :checkhealth"
fi

python3 -c "import pynvim" 2>/dev/null && pass "pynvim (notebooks)" \
  || printf '\033[1;33m  !\033[0m %s\n' "pynvim missing — notebook cell execution disabled"

fc-list 2>/dev/null | grep -qi "nerd" && pass "a Nerd Font is installed" \
  || printf '\033[1;33m  !\033[0m %s\n' "no Nerd Font found via fc-list (macOS: fine if installed via brew cask)"

[ "$FAIL" -eq 0 ] && printf '\n\033[1;32mAll checks passed.\033[0m\n' \
  || printf '\n\033[1;31mSome checks failed\033[0m — see docs/maintenance.md\n'
exit "$FAIL"
