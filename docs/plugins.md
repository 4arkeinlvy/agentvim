# Plugin Decision Matrix

Everything installed, why it's there, and what it costs. "Load" describes
lazy-loading: almost nothing loads at startup — measured total startup is
~25 ms ([performance.md](performance.md)).

Plugins marked **(base)** come from LazyVim core or an enabled extra and are
maintained upstream; plugins marked **(agentvim)** are this distribution's
own layer, configured in `lua/plugins/`.

## The layer that makes this AgentVim

| Plugin | Purpose | Why chosen | Alternatives | Load |
|---|---|---|---|---|
| **claudecode.nvim** (agentvim) | Claude Code IDE integration: native diffs, selection/file context | Speaks the official VSCode-extension protocol; reuses your existing CLI, config, MCP servers | Avante, CodeCompanion, copilot.lua — see [ai.md](ai.md) | on `Space a *` keys |
| **jupytext.nvim** (agentvim) | Open `.ipynb` as Markdown, write valid `.ipynb` back | Only maintained in-editor jupytext bridge; makes notebooks diffable | raw JSON editing, browser Jupyter | startup (must catch `BufReadPre` for `.ipynb`) |
| **molten-nvim** (agentvim) | Execute code on Jupyter kernels, inline outputs | Maintained successor of magma-nvim; per-project kernels; optional inline images | Jupynium (Selenium browser control), quarto-nvim (wraps molten) | on python/markdown ft |
| **vimtex** (base: `lang.tex`) | Complete LaTeX workflow: latexmk, SyncTeX, motions | Category king, 12+ years maintained | texlab-only setups | on `.tex` |

Configuration and keybindings for these live in
[`lua/plugins/ai.lua`](../lua/plugins/ai.lua),
[`lua/plugins/jupyter.lua`](../lua/plugins/jupyter.lua),
[`lua/plugins/tex.lua`](../lua/plugins/tex.lua) — each file is commented and
under 60 lines. Keybinding reference: [usage.md](usage.md).

## Base editor (LazyVim core)

| Plugin | Purpose | Why / alternatives | Load |
|---|---|---|---|
| lazy.nvim | Plugin manager, lockfile, profiler | De-facto standard; packer archived | startup (is the loader) |
| snacks.nvim | Picker, explorer, terminal, dashboard, zen, notifications | One maintained plugin replaces Telescope + Neo-tree + toggleterm + alpha; same author as base | mixed; picker/explorer on demand |
| blink.cmp | Completion engine | Rust-fast fuzzy; LazyVim default over nvim-cmp | insert mode |
| nvim-treesitter | Parsing: highlight, textobjects, folds | No alternative | on file open |
| nvim-lspconfig | LSP client configs | Standard | on file open |
| mason.nvim (+ mason-lspconfig) | Install/manage LSPs, formatters, DAPs | Isolated, sudo-free tooling prefix | on demand |
| conform.nvim | Format-on-save with project-config respect | null-ls archived | on save |
| nvim-lint | Linters where no LSP exists (hadolint, markdownlint, sqlfluff) | Complements conform | per ft |
| which-key.nvim | Discoverable keybindings — press `Space`, read the menu | The single best beginner feature | on first keypress |
| gitsigns.nvim | Hunk signs, stage/reset/blame in-buffer | Standard | on file open |
| lazygit (external, `Space g g`) | Full git UI: stage/commit/rebase/resolve | Replaces VSCode source-control panel entirely | on demand |
| trouble.nvim | Diagnostics/quickfix panel | Standard (`Space x x`) | on demand |
| flash.nvim | Jump anywhere in 2–3 keystrokes (`s` + chars) | Successor to hop/leap-style motion | on keypress |
| grug-far.nvim | Project-wide search & replace UI | ripgrep-powered; safer than `:%s` across files | on demand |
| todo-comments.nvim | Highlight/search TODO/FIXME/HACK | Zero-config | on file open |
| persistence.nvim | Session restore per directory | Small, folke-maintained | on demand |
| noice.nvim + nui | Modern cmdline/messages UI | Cosmetic but signature-help routing is genuinely useful | UI event |
| bufferline.nvim + lualine.nvim | Tabs-like buffer bar; statusline | Standard pair | UI event |
| tokyonight.nvim (+ catppuccin available) | Theme (matches bundled kitty theme) | Taste; both included by base | startup |
| nvim-dap (+ ui) (extra: `dap.core`) | Debug adapter protocol: breakpoints, stepping | The only DAP stack; debugpy & js-debug preinstalled | on `Space d *` |

## Language extras enabled

`lang.python` (Pyright, Ruff, venv-selector, debugpy) · `lang.typescript`
(vtsls, js-debug) · `lang.tailwind` · `lang.docker` (dockerls, compose LS,
hadolint) · `lang.yaml` (yamlls + Kubernetes/schema-store schemas) ·
`lang.json` (jsonls + schemas) · `lang.markdown` (marksman,
render-markdown.nvim, markdown-preview browser live preview, markdownlint) ·
`lang.tex` (vimtex, texlab) · `lang.sql` (sqlfluff, dadbod completion) ·
`dap.core` · `formatting.prettier`.

Each is one `import` line in
[`lua/config/lazy.lua`](../lua/config/lazy.lua); add more (Go, Rust,
Terraform, Helm…) via `:LazyExtras` — they're maintained upstream by LazyVim.

## Performance & maintenance policy

- Nothing ships unless it lazy-loads or pays for itself at startup
  (measured: `:Lazy profile`).
- Prefer plugins that are (a) actively maintained, (b) by authors with
  multiple ecosystem plugins, (c) replaceable in under an hour if abandoned.
- The committed `lazy-lock.json` pins every plugin; `:Lazy restore` rolls the
  whole set back to the last known-good state.
- A plugin PR must fill in this matrix's columns — purpose, alternatives,
  why, load strategy — or it doesn't merge (see
  [CONTRIBUTING](../CONTRIBUTING.md)).
