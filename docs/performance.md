# Performance

## Measured (reference machine)

Ubuntu 22.04, 4-core laptop, NVMe, Neovim 0.12.4 — 2026-07-19:

| Metric | Value | Method |
|---|---|---|
| Startup to ready | **~25 ms** | `nvim --startuptime` (last line, `NVIM STARTED`), median of 5 |
| Plugins installed | 49 | `:Lazy` |
| Plugins loaded at startup | ~10 | `:Lazy profile` — everything else loads on event/ft/key |
| First LSP attach (pyright, warm) | < 1 s after file open | `:LspInfo` |
| VSCode cold start, same machine, same project | ~4–6 s to interactive | wall clock; for scale, not science |

Reproduce it yourself:

```bash
nvim --startuptime /tmp/st.log +qa && tail -1 /tmp/st.log
```

In-editor: `:Lazy profile` (per-plugin cost, sorted).

## Distro comparison (measured, reproducible)

`scripts/benchmark.sh` installs each distro's official starter into an
isolated `NVIM_APPNAME` sandbox and measures pty startups **opening a
Python file** (so LSP/treesitter/lazy-file plugins load — a heavier, more
honest number than dashboard startup). Same machine, same run, median of 7:

| Distro | Startup opening a `.py` |
|---|---|
| NvChad (starter) | 136 ms |
| AstroNvim (template) | 162 ms |
| LazyVim (starter) | 176 ms |
| **AgentVim** | **245 ms** |

Read this honestly: the starters are faster **because they ship almost no
language support** — NvChad's starter has no Python LSP, formatter, or
debugger configured at all. AgentVim's number includes ~11 working language
stacks, notebooks, and the AI layer; configure the starters up to parity
and you pay the same cost there. The comparison you should actually care
about: AgentVim opens a Python file with full tooling in a quarter second;
VSCode takes several seconds to become interactive.

Rerun it on your hardware: `~/.config/nvim/scripts/benchmark.sh`
(cleanup: `--clean`). Numbers above: Linux 6.8, 12-core laptop, NVMe.

## Why it's fast

1. **lazy.nvim discipline:** plugins declare `event`/`ft`/`keys`/`cmd`
   triggers. Molten costs nothing until a Python/notebook file opens; Claude
   integration costs nothing until `Space a`.
2. **blink.cmp:** Rust fuzzy matcher; no completion cost until Insert mode.
3. **Single-plugin consolidation:** snacks.nvim provides picker + explorer +
   terminal + dashboard — one startup footprint instead of four.
4. **Treesitter parsers are compiled C**, loaded per-language.
5. **No duplicate functionality** — the plugin matrix
   ([plugins.md](plugins.md)) exists to keep it that way.

## Keeping it fast

- After adding a plugin: check `:Lazy profile`. Budget: nothing above
  ~5 ms at startup without written justification in its spec.
- Startup regressions bisect trivially: `:Lazy restore` (lockfile) vs
  latest.
- Memory: Neovim + full LSP stack for a Python+TS monorepo typically sits
  in the hundreds of MB — the LSP servers dominate, and they'd cost the
  same in any editor; the editor itself is tens of MB.
- Giant files: treesitter/LSP auto-disable over size thresholds (LazyVim
  `bigfile` handling) — a 500 MB log opens fine.
