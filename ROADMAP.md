# Roadmap

## v0.1 — now (Stable Beginner Edition)

- LazyVim base + AI/notebook/LaTeX layer, lockfile-pinned
- Claude Code protocol integration; Codex/Gemini terminal workflows
- Full docs set: architecture, AI, orchestration, context engineering,
  workflows, 10-day learning path, VSCode migration
- Linux/macOS installer + verify/update/uninstall scripts, CI

## v0.2 — polish

- Real screenshots & GIFs ([assets/screenshots](assets/screenshots/README.md)
  — contributions wanted)
- Inline notebook images preset (image.nvim + kitty) behind one toggle
- Scripted benchmark matrix vs LazyVim/AstroNvim/NvChad on identical
  hardware ([docs/performance.md](docs/performance.md))
- Native Windows install path (scoop) with CI coverage

## v0.3 — deeper agent integration

- MCP server presets (filesystem, git, Postgres, Playwright) with setup
  docs per server
- Prompt/slash-command library in `templates/` (review, ADR, incident,
  refactor)
- Git worktree helpers for parallel-agent workflows

## v1.0 — stability promise

- Semantic versioning; breaking keybinding/config changes only on majors
- Migration notes per release
- Project templates (fastapi, react, research/LaTeX, k8s) — each with
  CLAUDE.md, ADR seed, and recommended layout per
  [docs/context.md](docs/context.md)

## Non-goals

- Becoming a general plugin framework (LazyVim already is one)
- Bundling every AI plugin — the [ai.md](docs/ai.md) comparison is the
  product; the layer stays thin
- GUI wrappers
