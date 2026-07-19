#!/usr/bin/env bash
# Reproducible startup benchmark: AgentVim vs LazyVim vs AstroNvim vs NvChad.
#
# Each distro installs into an isolated NVIM_APPNAME (bench-*) so nothing
# touches your real config. Plugins sync headlessly, two warmup launches
# (treesitter compiles, caches), then RUNS timed interactive startups (real
# pty via `script`) opening a small python file. Reports the median.
#
#   RUNS=9 scripts/benchmark.sh          # default RUNS=7
#   scripts/benchmark.sh --clean         # remove bench-* configs/data after
set -euo pipefail

RUNS=${RUNS:-7}
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
DUMMY=$(mktemp --suffix=.py); printf 'def f():\n    return 1\n' > "$DUMMY"
ST=$(mktemp)
trap 'rm -f "$DUMMY" "$ST"' EXIT

declare -A REPOS=(
  [bench-lazyvim]="https://github.com/LazyVim/starter"
  [bench-astronvim]="https://github.com/AstroNvim/template"
  [bench-nvchad]="https://github.com/NvChad/starter"
)

launch() { # launch <appname|default> [extra nvim args...]
  local app=$1; shift
  local env=""
  [ "$app" != default ] && env="NVIM_APPNAME=$app"
  # -n: no swapfile (a stale swap prompt would hang the pty); hard timeout as
  # a backstop against any plugin blocking exit.
  timeout -k 5 45 script -qec "env $env nvim -n $* $DUMMY '+qa!'" /dev/null >/dev/null 2>&1 || true
}

median() { sort -n | awk '{a[NR]=$1} END{printf "%.1f", a[int((NR+1)/2)]}'; }

install_distro() {
  local app=$1
  if [ ! -d "$CFG/$app" ]; then
    echo "  installing $app ..." >&2
    git clone --quiet --depth 1 "${REPOS[$app]}" "$CFG/$app"
    rm -rf "$CFG/$app/.git"
    NVIM_APPNAME=$app nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true
  fi
}

bench() { # bench <appname|default> <label>
  local app=$1 label=$2 t
  launch "$app"; launch "$app"   # warmups
  local times=()
  for _ in $(seq "$RUNS"); do
    rm -f "$ST"
    launch "$app" "--startuptime $ST"
    t=$(awk '/NVIM STARTED/{print $1}' "$ST" | tail -1)
    [ -n "$t" ] && times+=("$t")
  done
  printf '%-12s %s ms (median of %d)\n' "$label" "$(printf '%s\n' "${times[@]}" | median)" "${#times[@]}"
}

if [ "${1:-}" = "--clean" ]; then
  for app in "${!REPOS[@]}"; do rm -rf "${CFG:?}/$app" "${DATA:?}/$app" \
    "${XDG_STATE_HOME:-$HOME/.local/state}/$app" "${XDG_CACHE_HOME:-$HOME/.cache}/$app"; done
  echo "bench-* configs removed"; exit 0
fi

echo "==> Installing comparison distros (isolated, ~200MB each)"
for app in "${!REPOS[@]}"; do install_distro "$app"; done

echo "==> Benchmarking (pty startup, opening a .py file, median of $RUNS)"
bench default      "AgentVim"
bench bench-lazyvim   "LazyVim"
bench bench-astronvim "AstroNvim"
bench bench-nvchad    "NvChad"
echo
echo "Machine: $(uname -sr), $(nproc) cores. Reproduce: scripts/benchmark.sh"
echo "Cleanup: scripts/benchmark.sh --clean"
