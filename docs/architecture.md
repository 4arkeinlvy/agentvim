# Architecture Decisions

Every major dependency answers four questions: what problem it solves, why it
was chosen, what the alternatives were, and what we trade away. If a future
change can't answer these, it doesn't get merged.

## Base: LazyVim (not AstroNvim, NvChad, Kickstart, or from scratch)

**Problem:** a modern editor needs ~40 correctly-wired plugins (LSP,
completion, treesitter, picker, git, formatting…). Maintaining that wiring
yourself is a part-time job.

**Choice:** [LazyVim](https://github.com/LazyVim/LazyVim), by folke — author
of lazy.nvim, which-key, snacks.nvim, tokyonight, trouble. AgentVim is a thin
layer (3 plugin files + curated "extras") on top of it.

**Alternatives considered:**

| Option | Why not |
|---|---|
| From scratch | Months of wiring to reach parity; every breaking upstream change becomes our bug. The audit goal is an AI-first *workflow*, not a re-implementation of an IDE base. |
| Kickstart.nvim | A teaching scaffold, deliberately minimal — you end up building LazyVim yourself, slowly. |
| NvChad | UI-focused, custom abstraction layer over plugin configs; less conventional structure to inherit and document. |
| AstroNvim | Good, comparable. LazyVim wins on ecosystem gravity: its "extras" system gives us one-line, maintained language stacks, and its author maintains half our plugin stack. |

**Tradeoffs:** we inherit LazyVim's defaults and release cadence; a major
LazyVim version bump can move keybindings. Mitigated by the committed
`lazy-lock.json` (reproducible installs, instant rollback).

## Plugin manager: lazy.nvim

The de-facto standard: lockfile, lazy-loading by event/ft/key, startup
profiler, UI. Alternatives (packer.nvim — archived; vim-plug — no
lazy-loading semantics) are not serious contenders in 2026. No tradeoff worth
naming.

## Completion: blink.cmp (not nvim-cmp)

**Problem:** completion popups must be instant; nvim-cmp's Lua source
architecture gets slow with many sources.

**Choice:** blink.cmp — LazyVim's default. Rust-backed fuzzy matching,
built-in sources, snippet support out of the box.

**Tradeoffs:** younger than nvim-cmp, fewer third-party sources. Every source
we need (LSP, path, snippets, buffer) is built in; if an exotic source is ever
required, blink supports nvim-cmp source adapters.

## Picker & explorer: snacks.nvim (not Telescope / Neo-tree)

**Problem:** fuzzy-finding files/grep/symbols and browsing the tree.

**Choice:** snacks.nvim picker + explorer — LazyVim's current default.
Telescope and Neo-tree (the previous defaults, and what most older guides
name) remain excellent; we deviate because snacks is faster on large repos,
maintained by the same author as the base distro (no version-skew), and one
plugin replaces two. Keybindings are identical (`Space Space`, `Space /`,
`Space e`) so tutorials still translate.

**Tradeoffs:** Telescope has a larger extension ecosystem. None of those
extensions are in our workflow; if one becomes necessary, the LazyVim
Telescope extra restores it in one line.

## AI integration: claudecode.nvim (see [ai.md](ai.md) for the full comparison)

**Problem:** AI editing must be *in* the editor — diffs, selection context,
file awareness — not a chat sidecar.

**Choice:** [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim)
implements the same WebSocket IDE protocol as Anthropic's official VSCode
extension, so the Claude Code CLI treats Neovim as a first-class IDE: native
diff review, `@`-mentions of the current selection, tree integration. Codex /
Gemini run as terminal processes (their CLIs are their interface — see
[agent-orchestration.md](agent-orchestration.md)).

**Alternatives:** Avante, CodeCompanion, Copilot — compared in depth in
[ai.md](ai.md). Short version: they re-implement an agent inside the editor;
we integrate the agent the user already runs, with its existing config, MCP
servers, and billing.

## Terminal: kitty (recommended, not required)

**Problem:** leaving VSCode means the terminal emulator becomes your IDE
shell. It needs Nerd Font rendering, true color, OSC 52 clipboard (Neovim's
clipboard without X11 helper tools), and the kitty graphics protocol (inline
notebook plots via image.nvim).

**Choice:** kitty — config-file driven (we ship one), GPU-rendered, graphics
protocol native. **Alternatives:** WezTerm (equally good; Lua-configured —
fine choice), Alacritty (no images, no tabs), GNOME Terminal/older VTE (no
OSC 52 → broken clipboard). AgentVim works in any terminal; the docs assume
kitty.

## Multiplexer: tmux

Sessions survive disconnects/laptop closes — that's what keeps long-running
agent sessions alive. Panes/windows organize nvim + agents + servers.
Alternatives: Zellij (nice, younger, less universal), kitty-native
splits (no session persistence). Tradeoff: one more prefix key to learn; the
learning path teaches it on day 9.

## Notebooks: jupytext.nvim + molten-nvim

**Problem:** `.ipynb` is JSON — unreviewable diffs, miserable to edit — but
kernels and cell execution are genuinely useful.

**Choice:** two orthogonal tools. jupytext converts notebooks to Markdown on
open and back on save (git-friendly, editable with the full LSP stack).
molten talks to real Jupyter kernels (per-project venvs via ipykernel) and
renders outputs inline; with image.nvim + kitty it renders plots too.

**Alternatives:** Jupynium (drives browser Jupyter via Selenium — heavy),
magma-nvim (molten's unmaintained ancestor), quarto-nvim (great for Quarto
docs, wraps molten anyway for execution), or plain browser JupyterLab (fine
for exploration; useless for refactoring and version control).

**Tradeoffs:** molten needs `pynvim` + a registered kernel per project — a
one-time, two-command setup documented in [usage.md](usage.md).

## LaTeX: VimTeX

The undisputed answer — continuous latexmk compilation, SyncTeX forward and
inverse search, environment text objects, citation completion. Alternatives
(texlab alone, overleaf) cover a fraction. Tradeoff: none; VimTeX is older
than most editors and still actively maintained.

## Python: Pyright + Ruff

- **Pyright:** fastest, most complete open-source type checker/LSP. Swap to
  basedpyright (community fork with extras) by setting
  `vim.g.lazyvim_python_lsp = "basedpyright"` — one line.
- **Ruff:** linter + formatter + import sorter in one Rust binary; replaces
  flake8/isort/black at ~100× speed. Runs as an LSP alongside Pyright
  (Pyright types, Ruff style).

## Tooling manager: Mason

LSPs/formatters/debuggers install into an isolated prefix
(`~/.local/share/nvim/mason`) — no sudo, no global npm/pip pollution, `:Mason`
UI to update. Alternative: system package managers (root, drift, distro-lag)
or manual npm/pip installs (unmanaged). Tradeoff: binaries live outside your
project's dependency lockfiles — which for editor tooling is exactly what you
want.

## Syntax: Treesitter

Incremental parsing for accurate highlighting, structural text objects
(functions/classes), and code folding. It's a Neovim built-in accelerated by
the nvim-treesitter plugin. No real alternative (regex syntax files are the
past). Tradeoff: parsers compile on install — needs a C compiler once.

## Formatting: conform.nvim (+ format-on-save)

Per-language formatters (stylua, ruff, prettier, shfmt…) with LSP fallback,
async, respects project configs (`.prettierrc`, `pyproject.toml`). LazyVim
default; alternatives (null-ls — archived; manual `:!prettier`) lose.
