# Installation

## Automated

```bash
curl -fsSL https://raw.githubusercontent.com/4arkeinlvy/agentvim/main/scripts/install.sh | bash
```

Supported: **Linux x86_64** (no sudo needed — everything installs to
`~/.local`) and **macOS** (via Homebrew). The installer:

1. Backs up any existing `~/.config/nvim` to `~/.config/nvim.bak.<timestamp>`
   (same for `~/.local/share/nvim`) — nothing is destroyed.
2. Installs latest stable Neovim, ripgrep, fd, lazygit (Linux: static
   binaries into `~/.local/bin`; macOS: brew).
3. Installs the JetBrainsMono Nerd Font.
4. Clones this repo to `~/.config/nvim`.
5. Installs Python notebook deps (`pynvim`, `jupyter_client`, `ipykernel`,
   `jupytext`) via `pip --user`.
6. Headlessly installs all plugins (lockfile-pinned) and language servers.
7. Runs `scripts/verify.sh` and prints a health report.

If any step fails, already-completed steps are reported and your backup is
untouched — rerun after fixing the issue, or restore with
`scripts/uninstall.sh`.

## Manual (any platform)

```bash
# 1. Prerequisites: nvim >= 0.11, git, curl, node >= 18, python3 >= 3.9,
#    ripgrep, fd, lazygit, a C compiler, a Nerd Font.
# 2. Back up and clone:
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
git clone https://github.com/4arkeinlvy/agentvim ~/.config/nvim
# 3. Notebook support (optional):
python3 -m pip install --user pynvim jupyter_client ipykernel jupytext
# 4. First launch — plugins & LSPs install automatically:
nvim
```

### Per-OS notes

- **Ubuntu/Debian:** apt's Neovim is far too old — use the installer (which
  fetches the official tarball) or a release tarball into
  `/opt` / `~/.local/opt`.
- **Arch:** `pacman -S neovim ripgrep fd lazygit ttf-jetbrains-mono-nerd`
  then manual steps 2–4.
- **macOS:** `brew install neovim ripgrep fd lazygit && brew install
  --cask font-jetbrains-mono-nerd-font kitty` then steps 2–4.
- **Windows:** use **WSL2 + the Linux installer** (recommended — the
  terminal-centric agent workflow assumes a Unix shell), with a Nerd Font
  set in Windows Terminal. Native Windows works with scoop
  (`scoop install neovim ripgrep fd lazygit`) but is not CI-tested; a
  native installer is on the [roadmap](../ROADMAP.md).

### Terminal & AI

- **Terminal:** kitty recommended (a ready config ships in this repo's
  setup docs — see [architecture.md](architecture.md#terminal-kitty-recommended-not-required)).
  Any true-color terminal with a Nerd Font and OSC 52 works.
- **Claude Code:** install from <https://claude.com/claude-code>, run
  `claude` once to authenticate — `Space a c` then works immediately.
- **Codex:** `npm install -g @openai/codex` · **Gemini:**
  `npm install -g @google/gemini-cli`.

## The scripts

| Script | Does |
|---|---|
| `scripts/install.sh` | Everything above, idempotently |
| `scripts/verify.sh` | Checks binaries, config, headless boot, plugin/LSP counts — run any time |
| `scripts/update.sh` | `git pull` + plugin sync to lockfile + Mason/parser updates |
| `scripts/uninstall.sh` | Removes AgentVim (config + data), restores your newest backup |

Backups are plain directories (`~/.config/nvim.bak.*`) — "restore" is `mv`,
no tooling required.

## Verifying

```bash
~/.config/nvim/scripts/verify.sh   # or: nvim, then :checkhealth
```

First interactive launch may still be downloading a few Mason tools — watch
`:Mason`, it's done within a couple of minutes on normal connections.
