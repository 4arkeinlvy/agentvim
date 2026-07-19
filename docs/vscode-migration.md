# VSCode → AgentVim Migration

## Feature map

| VSCode | AgentVim | Notes |
|---|---|---|
| `Ctrl+P` quick open | `Space Space` | fuzzy, frecency-ranked |
| `Ctrl+Shift+F` search | `Space /` | ripgrep; `Space s r` for search & replace |
| `Ctrl+Shift+E` explorer | `Space e` | `a` add, `d` delete, `r` rename, `?` help |
| `` Ctrl+` `` terminal | `Ctrl+/` | floating; tmux for real multi-terminal |
| `Ctrl+Shift+P` palette | `Space` + wait, or `:` | which-key *shows* you the palette |
| `F12` / `Shift+F12` | `gd` / `gr` | back with `Ctrl+o` |
| Hover | `K` | again to enter/scroll the popup |
| `F2` rename | `Space c r` | LSP-wide |
| `Ctrl+.` quick fix | `Space c a` | |
| Format document | `Space c f` | plus format-on-save |
| Problems panel | `Space x x` | `]d` / `[d` jump diagnostics |
| `Ctrl+Tab` | `Space ,` (picker) or `Shift+h/l` | buffers ≈ tabs |
| Source control panel | `Space g g` | lazygit — stage/commit/rebase/resolve |
| GitLens blame | `Space g h b` | gitsigns |
| Breakpoints / F5 | `Space d b` / `Space d c` | nvim-dap |
| Outline | `Space c s` | |
| Zen mode | `Space u z` | |
| Settings UI | `lua/config/*.lua` | text > UI: diffable, portable, agent-editable |
| Extensions marketplace | `:LazyExtras` + `lua/plugins/` | curated, versioned in git |
| Claude Code extension | `Space a c` | same CLI, same protocol, native diffs |
| Copilot | `:LazyExtras` → `ai.copilot` | optional |
| Jupyter extension | jupytext + molten | [workflows.md](workflows.md#jupyter-analysis) |
| LaTeX Workshop | VimTeX | `\ll` compile, `\lv` view |
| Settings Sync | git — this repo *is* your config | clone it anywhere |

## Mindset changes (the real migration)

1. **Modes are not a tax, they're the feature.** In VSCode every key inserts
   text, so commands need `Ctrl+Shift+…`. In Normal mode, plain letters are
   commands — that's why `gd`, `ciw` beat chords. You spend far more time
   *navigating* code than typing it.
2. **Composition over commands.** `d` (delete) + `i(` (inside parens) =
   `di(`. You learn ~10 verbs and ~10 objects, not 100 shortcuts.
3. **The terminal is the IDE.** Servers, agents, k8s, git — panes next to
   your editor, not panels inside it. tmux is the window manager.
4. **Config is code.** Your editor setup is diffable, revertable, and — new
   in the agent era — *editable by Claude* ("add a keybinding that…").
5. **Discovery is built in.** Press `Space` and read. `:help anything`
   answers deeper questions. You are never stuck.

## Common mistakes

- **Escape-key panic.** Something weird? `Esc Esc` returns you to Normal
  mode. Typing `q` then a letter starts *macro recording* (watch the
  statusline) — press `q` again to stop.
- **Staying in Insert mode** and arrow-keying around — you're using 5% of
  the editor. Get out (`Esc` or `jk`), move, dive back (`i`/`a`/`o`).
- **`:q!` reflex** — `:q!` discards changes. `:wq` or plain `:x` saves.
- **Learning keybindings from random YouTube configs** — they won't match.
  Everything here is discoverable via `Space` + wait, and documented in
  [usage.md](usage.md).
- **Uninstalling VSCode on day one.** Don't burn the bridge; see timeline.

## Recommended timeline

| Phase | Do |
|---|---|
| Day 1–2 | [learning-path](learning-path.md) days 1–2. Edit real files. VSCode stays installed for emergencies. |
| Day 3–5 | All real editing in nvim. Learn `Space a c` (Claude) + `Space g g` (git) — the two biggest quality-of-life anchors. |
| Week 2 | tmux daily driver, notebooks/LaTeX if you use them. You'll cross the "faster than VSCode" line here. |
| Week 3+ | Delete VSCode (`sudo apt remove code; rm -rf ~/.config/Code ~/.vscode`) — reclaims several GB. Project files (`.env`, code, everything) are untouched: VSCode never stores project data in its own directories. |
