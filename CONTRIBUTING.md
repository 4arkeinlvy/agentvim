# Contributing

Thanks for wanting to improve AgentVim. Read
[docs/philosophy.md](docs/philosophy.md) first — it's short and it decides
what merges.

## Ground rules

- **New plugins must justify themselves.** A plugin PR fills in the
  [plugin matrix](docs/plugins.md) columns: problem, why this plugin,
  alternatives considered, tradeoffs, load strategy. "Popular" isn't a
  reason; "duplicates existing functionality" is a rejection.
- **Docs move with code.** A behavior change updates the affected doc in the
  same PR.
- **Keep the layer thin.** Prefer enabling a LazyVim extra over hand-rolling
  config; prefer configuring an existing plugin over adding one.
- **Startup budget:** `:Lazy profile` before/after; nothing new above ~5 ms
  at startup without written justification.

## Dev setup

```bash
git clone https://github.com/4arkeinlvy/agentvim && cd agentvim
# try it without touching your real config:
NVIM_APPNAME=agentvim-dev ln -s "$PWD" ~/.config/agentvim-dev
NVIM_APPNAME=agentvim-dev nvim
```

`NVIM_APPNAME` gives the checkout its own config/data/state — your daily
setup stays untouched.

## Checks (CI runs these)

```bash
stylua --check lua/                      # formatting (stylua.toml in repo)
nvim --headless "+Lazy! restore" +qa     # lockfile install works
bash scripts/verify.sh                   # health
```

## Commits & PRs

- Small, focused PRs; imperative commit subjects ("add sqlfluff config",
  not "added"/"misc fixes").
- If plugin versions change, commit the updated `lazy-lock.json` and say
  why.
- Fill in the PR template; link issues.

## Docs-only contributions

Extremely welcome — especially screenshots/GIFs
([assets/screenshots](assets/screenshots/README.md)), workflow recipes for
stacks we don't cover, and corrections from real migration experience.
