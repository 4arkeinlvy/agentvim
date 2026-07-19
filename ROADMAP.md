# Roadmap

## Delivered

### v0.1 — Stable Beginner Edition

- LazyVim base + AI/notebook/LaTeX layer, lockfile-pinned
- Claude Code protocol integration; Codex/Gemini terminal workflows
- Docs: architecture, AI, orchestration, context engineering, workflows,
  10-day learning path, VSCode migration
- Linux/macOS installer + verify/update/uninstall scripts, CI

### v0.2 — Polish

- Real screenshots + GIF, recorded reproducibly with vhs
  (`assets/tapes/*.tape` — rerun them to regenerate)
- Inline notebook plots behind one toggle (`vim.g.agentvim_inline_images`)
- Scripted, isolated benchmark vs LazyVim / AstroNvim / NvChad
  (`scripts/benchmark.sh`, results in [docs/performance.md](docs/performance.md))
- Windows: `scripts/install.ps1` (scoop) + experimental CI boot job

### v0.3 — Deeper agent integration

- MCP presets with per-server guidance ([docs/mcp.md](docs/mcp.md),
  `templates/mcp.json`)
- Slash-command library: `/review`, `/adr`, `/incident`, `/refactor`
  (`templates/commands/`)
- Parallel-agent worktree helper (`scripts/worktree.sh`)

### v1.0

- Project templates with CLAUDE.md + ADR seeds: fastapi, react,
  research/LaTeX, k8s (`templates/projects/`)
- Versioning promise (below)

## Versioning promise (v1.0+)

- **Semantic versioning.** Keybinding removals/changes and config-breaking
  changes only in majors; new plugins/extras in minors; lockfile bumps and
  docs in patches.
- Every release ships migration notes in the CHANGELOG.
- `lazy-lock.json` on a release tag is a tested set — installing from a tag
  is always reproducible.

## Next

- Expand the GIF library (AI diff review, git, notebook runs — tapes
  welcome, see [assets/screenshots](assets/screenshots/README.md))
- Benchmark job in CI (scheduled, tracked over time)
- MCP preset expansion (MongoDB, browser-use) as servers mature
- Session/project switcher polish for multi-repo agent work

## Non-goals

- Becoming a general plugin framework (LazyVim already is one)
- Bundling every AI plugin — the [ai.md](docs/ai.md) comparison is the
  product; the layer stays thin
- GUI wrappers
