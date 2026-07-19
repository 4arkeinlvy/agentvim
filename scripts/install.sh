#!/usr/bin/env bash
# AgentVim installer.
# Linux x86_64: everything user-local (~/.local), no sudo required.
# macOS: uses Homebrew.
# Safe: existing nvim config/data are backed up, never deleted.
set -euo pipefail

REPO_URL="https://github.com/4arkeinlvy/agentvim"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"
FONTS="$HOME/.local/share/fonts"
TS="$(date +%Y%m%d-%H%M%S)"
TMP="$(mktemp -d)"
LSP_TOOLS="pyright ruff vtsls tailwindcss-language-server dockerfile-language-server \
docker-compose-language-service yaml-language-server json-lsp marksman texlab \
lua-language-server debugpy"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m  ✗ %s\033[0m\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

cleanup() { rm -rf "$TMP"; }
on_error() {
  cleanup
  printf '\n\033[1;31mInstall failed.\033[0m Nothing was deleted.\n' >&2
  printf 'Backups (if any) are at %s.bak.%s — restore with mv.\n' "$CFG" "$TS" >&2
  printf 'Fix the error above and rerun; the installer is idempotent.\n' >&2
}
trap on_error ERR
mkdir -p "$BIN" "$OPT" "$FONTS"

OS="$(uname -s)" ARCH="$(uname -m)"
case "$OS" in
  Linux)  [ "$ARCH" = "x86_64" ] || die "Linux $ARCH not supported by this script — see docs/installation.md" ;;
  Darwin) have brew || die "Homebrew required on macOS: https://brew.sh" ;;
  *)      die "Unsupported OS $OS — see docs/installation.md" ;;
esac

gh_latest_tag() { # gh_latest_tag owner/repo -> vX.Y.Z
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest" | sed 's|.*/tag/||'
}

# ---------------------------------------------------------------- core tools
info "Installing core tools"
if [ "$OS" = "Darwin" ]; then
  brew install neovim ripgrep fd lazygit >/dev/null
  brew install --cask font-jetbrains-mono-nerd-font >/dev/null || true
  ok "neovim, ripgrep, fd, lazygit, Nerd Font (brew)"
else
  if ! have nvim || [ ! -x "$OPT/nvim-linux-x86_64/bin/nvim" ]; then
    curl -fsSLo "$TMP/nvim.tar.gz" \
      https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    rm -rf "$OPT/nvim-linux-x86_64"
    tar -C "$OPT" -xzf "$TMP/nvim.tar.gz"
    ln -sfn "$OPT/nvim-linux-x86_64/bin/nvim" "$BIN/nvim"
  fi
  ok "neovim $("$BIN/nvim" --version | head -1 | awk '{print $2}')"

  if ! have rg; then
    tag=$(gh_latest_tag BurntSushi/ripgrep)
    curl -fsSLo "$TMP/rg.tar.gz" \
      "https://github.com/BurntSushi/ripgrep/releases/download/${tag}/ripgrep-${tag}-x86_64-unknown-linux-musl.tar.gz"
    tar -C "$TMP" -xzf "$TMP/rg.tar.gz" && cp "$TMP"/ripgrep-*/rg "$BIN/"
  fi
  ok "ripgrep"

  if ! have fd; then
    tag=$(gh_latest_tag sharkdp/fd)
    curl -fsSLo "$TMP/fd.tar.gz" \
      "https://github.com/sharkdp/fd/releases/download/${tag}/fd-${tag}-x86_64-unknown-linux-musl.tar.gz"
    tar -C "$TMP" -xzf "$TMP/fd.tar.gz" && cp "$TMP"/fd-*/fd "$BIN/"
  fi
  ok "fd"

  if ! have lazygit; then
    tag=$(gh_latest_tag jesseduffield/lazygit)
    curl -fsSLo "$TMP/lg.tar.gz" \
      "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag#v}_Linux_x86_64.tar.gz"
    tar -C "$TMP" -xzf "$TMP/lg.tar.gz" lazygit && mv "$TMP/lazygit" "$BIN/"
  fi
  ok "lazygit"

  if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd"; then
    curl -fsSLo "$TMP/jbm.tar.xz" \
      https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    mkdir -p "$FONTS/JetBrainsMonoNerd"
    tar -xJf "$TMP/jbm.tar.xz" -C "$FONTS/JetBrainsMonoNerd" --wildcards \
      'JetBrainsMonoNerdFont-Regular.ttf' 'JetBrainsMonoNerdFont-Bold.ttf' \
      'JetBrainsMonoNerdFont-Italic.ttf' 'JetBrainsMonoNerdFont-BoldItalic.ttf'
    have fc-cache && fc-cache -f "$FONTS" >/dev/null 2>&1 || true
  fi
  ok "JetBrainsMono Nerd Font (set it in your terminal profile)"
fi

# ------------------------------------------------------------- prerequisites
info "Checking runtime prerequisites"
have git || die "git is required"
have node && ok "node $(node --version)" || warn "node not found — TS/JSON/YAML language servers need Node >= 18"
have python3 && ok "python3 $(python3 --version | awk '{print $2}')" || warn "python3 not found — notebook support disabled"
have cc || have gcc || warn "no C compiler — treesitter parsers cannot compile (install gcc/clang)"

# ------------------------------------------------------------------- config
info "Installing AgentVim config"
if [ -e "$CFG" ] && [ ! -L "$CFG" ] || { [ -L "$CFG" ] && [ ! -e "$CFG/lua/plugins/ai.lua" ]; }; then
  if [ -e "$CFG/lua/plugins/ai.lua" ] && git -C "$CFG" remote get-url origin 2>/dev/null | grep -q agentvim; then
    git -C "$CFG" pull --ff-only && ok "existing AgentVim checkout updated"
  else
    mv "$CFG" "$CFG.bak.$TS" && warn "existing config moved to $CFG.bak.$TS"
    git clone --depth 1 "$REPO_URL" "$CFG" && ok "cloned to $CFG"
  fi
elif [ ! -e "$CFG" ]; then
  git clone --depth 1 "$REPO_URL" "$CFG" && ok "cloned to $CFG"
else
  git -C "$CFG" pull --ff-only >/dev/null 2>&1 || true
  ok "existing AgentVim checkout"
fi
if [ -d "$DATA" ] && [ ! -d "$DATA/lazy" ]; then
  mv "$DATA" "$DATA.bak.$TS" && warn "existing nvim data moved to $DATA.bak.$TS"
fi

# ------------------------------------------------------------ python extras
if have python3; then
  info "Notebook support (pynvim, jupyter_client, ipykernel, jupytext)"
  python3 -m pip install --user --quiet pynvim jupyter_client ipykernel jupytext \
    && ok "python packages installed" \
    || warn "pip install failed — notebooks won't run cells (editor still fine)"
fi

# ------------------------------------------------------- plugins & servers
NVIM="${BIN}/nvim"; have "$NVIM" || NVIM=nvim
info "Installing plugins (pinned by lazy-lock.json) — takes a minute"
"$NVIM" --headless "+Lazy! restore" +qa
ok "plugins installed"

info "Installing language servers via Mason — takes a few minutes"
"$NVIM" --headless "+Lazy! load mason.nvim" "+MasonInstall $LSP_TOOLS" +qa >/dev/null 2>&1 \
  && ok "language servers installed" \
  || warn "some Mason installs failed — they retry automatically on first launch (:Mason to watch)"

# ------------------------------------------------------------------- verify
trap - ERR; cleanup
info "Verifying"
if [ -x "$CFG/scripts/verify.sh" ]; then "$CFG/scripts/verify.sh" || true; fi

printf '\n\033[1;32mAgentVim installed.\033[0m Next:\n'
printf '  1. Make sure %s is on your PATH and your terminal uses a Nerd Font\n' "$BIN"
printf '  2. Run: nvim   (then :checkhealth)\n'
printf '  3. Read: %s/docs/usage.md — or the 10-day course in docs/learning-path.md\n' "$CFG"
printf '  4. Claude Code: https://claude.com/claude-code  → then Space a c inside nvim\n'
