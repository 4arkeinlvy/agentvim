# Changelog

## v1.0.0 — 2026-07-19

**The stability line.** From here: semver, migration notes per release,
breaking changes only in majors (policy in [ROADMAP.md](ROADMAP.md)).

- Project templates with CLAUDE.md + ADR seeds — fastapi, react,
  research/LaTeX, k8s (`templates/projects/`)
- Migration notes: none needed — v0.x users just `scripts/update.sh`.

## v0.3.0 — 2026-07-19

- `docs/mcp.md`: MCP server presets (Playwright, Postgres, GitHub, K8s)
  with when-NOT-to-use guidance; `templates/mcp.json` project-scope template
- Slash-command library in `templates/commands/`: `/review`, `/adr`,
  `/incident`, `/refactor`
- `scripts/worktree.sh`: parallel-agent git worktrees

## v0.2.0 — 2026-07-19

- Real screenshots + demo GIF, reproducible via vhs tapes in
  `assets/tapes/` (dashboard now wears an AgentVim header)
- Inline notebook plots: one-line toggle `vim.g.agentvim_inline_images`
  (image.nvim + kitty graphics; off by default)
- `scripts/benchmark.sh`: isolated NVIM_APPNAME benchmark vs LazyVim,
  AstroNvim, NvChad; measured numbers in `docs/performance.md`
- Windows: `scripts/install.ps1` (scoop) + experimental CI boot job
- Fix documented: tree-sitter CLI glibc mismatch on Ubuntu 22.04
  (`docs/maintenance.md`)

## v0.1.0 — 2026-07-19

Initial public release.

- LazyVim base with curated extras: python, typescript, tailwind, docker,
  json, yaml, markdown, tex, sql, dap.core, prettier
- AI layer: claudecode.nvim (Claude Code IDE protocol, `Space a`),
  documented terminal workflows for Codex/Gemini
- Notebooks: jupytext.nvim + molten-nvim (`Space j`)
- LaTeX: VimTeX + latexmk + SyncTeX (evince default viewer)
- Pinned plugin set via lazy-lock.json; ~25 ms startup
- Installer (Linux x86_64 user-local, macOS brew), verify/update/uninstall
  scripts, CI (stylua + headless lockfile boot)
- Docs: architecture, plugins matrix, ai, agent-orchestration, context,
  workflows, usage, learning-path, vscode-migration, installation,
  performance, maintenance, philosophy
