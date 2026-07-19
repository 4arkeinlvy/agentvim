# Daily Usage Manual

The reference for driving AgentVim day to day. Leader = `Space`,
localleader = `\`. Press `Space` and wait — which-key shows everything below.

## Vim survival (day one)

| Do this | Keys |
|---|---|
| Insert text | `i` before cursor, `a` after, `o` new line below |
| Back to Normal mode | `Esc` |
| Save / quit / both | `:w` / `:q` / `:wq` (discard: `:q!`) |
| Move | `h j k l`, `w`/`b` by word, `0`/`$` line ends, `gg`/`G` file ends |
| Half-page | `Ctrl+d` / `Ctrl+u` |
| Delete / change / copy | `dd` line, `ciw` change word, `yy` yank, `p` paste |
| Undo / redo | `u` / `Ctrl+r` |
| Search | `/text`, then `n`/`N` |
| Visual select | `v` / `V` (lines), then any verb |
| System clipboard | `"+y` copy, `"+p` paste |
| Jump anywhere on screen | `s` + 2 chars (flash) |

Structured lessons: [learning-path.md](learning-path.md).

## Find & navigate

| Key | Action |
|---|---|
| `Space Space` | Find file |
| `Space /` | Grep project (`Space s r`: search & replace) |
| `Space e` | Explorer (`a` add, `d` delete, `r` rename, `?` help) |
| `Space ,` | Buffers · `Shift+h/l` cycle · `Space b d` close |
| `Space s s` | Symbols in file · `Space s S` workspace |
| `Space s k` | Search keymaps (forgot a binding? this) |
| `gd` `gr` `gI` | Definition / references / implementation (`Ctrl+o` back) |
| `K` | Docs popup |

## Code intelligence

| Key | Action |
|---|---|
| `Space c r` / `Space c a` | Rename / code action |
| `Space c f` | Format (also automatic on save) |
| `]d` `[d` / `Space x x` | Next/prev diagnostic / diagnostics panel |
| `Space c s` | Outline |
| `Space c v` | **Python: select venv** for LSP (per project) |
| `Space d b` `Space d c` | Breakpoint / start-continue debugging |

## AI — Claude Code

| Key | Action |
|---|---|
| `Space a c` | Toggle Claude panel |
| `Space a f` | Focus panel |
| `Space a b` | Add current buffer to context |
| `Space a s` (visual) | Send selection |
| `Space a a` / `Space a d` | Accept / reject proposed diff |
| `Space a r` / `Space a C` | Resume picker / continue last session |

Codex/Gemini: run in any terminal (below). Deep dives: [ai.md](ai.md),
[agent-orchestration.md](agent-orchestration.md), [workflows.md](workflows.md).

## Terminals

1. `Ctrl+/` — floating terminal, toggles.
2. **tmux** — real sessions: `tmux new -s work`; `Ctrl+b` then `%`/`"`
   split, `c` new window, `1..9` jump, `d` detach (`tmux attach` resumes —
   long agent runs survive laptop closes).
3. kitty tabs: `Ctrl+Shift+T`.

## Git

| Key | Action |
|---|---|
| `Space g g` | **lazygit** — stage/commit/push/rebase/resolve (`?` = help) |
| `]h` `[h` | Jump hunks |
| `Space g h s` / `Space g h r` | Stage / reset hunk |
| `Space g h b` / `Space g h d` | Blame line / diff |

## Notebooks

One-time per project: create a kernel from the project venv —

```bash
source .venv/bin/activate && pip install ipykernel
python -m ipykernel install --user --name myproject
```

Open the `.ipynb` (it appears as Markdown via jupytext; saving writes real
`.ipynb`):

| Key | Action |
|---|---|
| `Space j i` | Init kernel (pick `myproject`) |
| `Space j e` (visual) / `Space j l` | Run selection / line |
| `Space j o` / `Space j h` | Show / hide output |
| `Space j s` / `Space j R` | Interrupt / restart |

Text and dataframe outputs render inline everywhere. Inline **plots** are
one toggle away: set `vim.g.agentvim_inline_images = true` in
`lua/config/options.lua`, restart, `:Lazy sync` (requires kitty/WezTerm +
ImageMagick).

## LaTeX

`\ll` continuous compile (recompiles every `:w`) · `\lv` forward-search PDF ·
`\le` errors · `\lc` clean aux · `]]`/`[[` sections · `cse`/`dse`
change/delete environment · `\lt` TOC. Viewer: evince (SyncTeX). Prefer
zathura/sioyek? Change one line in `lua/plugins/tex.lua`.

## Markdown

Pretty in-buffer rendering automatically; `Space c p` live browser preview
(Mermaid works); `Space c s` outline; checkboxes/tables highlighted.

## Environments & dependency model

- **Editor tooling** (LSPs/formatters/debuggers) → Mason, isolated in
  `~/.local/share/nvim/mason` — never touches your projects. `:Mason` to
  manage.
- **Python** → per-project `.venv`; Pyright auto-detects, `Space c v`
  overrides; kernels via ipykernel (above).
- **Node** → project `node_modules` used automatically.
- **Kubernetes** → per-cluster kubeconfigs + a `use <cluster>` shell
  switcher: [workflows.md](workflows.md#kubernetes-debugging).

## Updating & health

| What | How |
|---|---|
| Plugins | `:Lazy update` — then commit the changed `lazy-lock.json` |
| Roll back plugins | `:Lazy restore` (uses the lockfile) |
| LSPs/tools | `:Mason` → `U` |
| Parsers | `:TSUpdate` |
| Anything wrong | `:checkhealth` first, then [maintenance.md](maintenance.md) |

## Troubleshooting quick hits

| Symptom | Fix |
|---|---|
| Icons are boxes | Terminal isn't using a Nerd Font |
| Clipboard dead over SSH/terminal | Use an OSC 52-capable terminal (kitty, WezTerm, recent VTE) |
| LSP silent | `:LspInfo`, then `:Mason` — is the server installed? |
| Stuck/frozen | `Esc` a few times; if recording (`q` in statusline), press `q` |
| Molten: no kernel | `jupyter kernelspec list` — did you register one? |
| Startup got slow | `:Lazy profile` names the culprit |
