# Changelog

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
