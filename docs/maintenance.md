# Maintenance

## Updating

| Layer | Command | Cadence |
|---|---|---|
| Plugins | `:Lazy update`, then commit `lazy-lock.json` | weekly-ish |
| This distro | `scripts/update.sh` (git pull + sync to lockfile + Mason/TS updates) | when the repo updates |
| LSPs/formatters | `:Mason` → `U` | monthly |
| Treesitter parsers | `:TSUpdate` (usually automatic with plugin updates) | with plugins |
| Neovim itself | reinstall the tarball / `brew upgrade neovim` | on stable releases |

**Update ritual that never bites:** update → use the editor for an hour →
if fine, commit the lockfile; if broken, `:Lazy restore` and you're back in
seconds.

## Rolling back

- **Plugins:** `:Lazy restore` pins everything to `lazy-lock.json`. Because
  the lockfile is committed, `git log lazy-lock.json` is a time machine —
  check out any historical lockfile and restore.
- **Config:** it's a git repo. `git revert` / `git checkout -- file`.
- **One misbehaving plugin:** pin it in its spec —
  `{ "author/plugin", commit = "abc123" }` — and file the issue upstream.

## Profiling

- `:Lazy profile` — startup cost per plugin.
- `nvim --startuptime /tmp/st.log +qa` — full boot trace.
- `:checkhealth` — the first stop for *any* misbehavior: providers, LSPs,
  treesitter, clipboard, terminal features.

## Recovering a broken setup

Escalate in order; each step is bigger:

1. `:Lazy restore` — plugin versions back to lockfile.
2. `nvim --clean` — boots without any config: proves whether the problem is
   config or Neovim/terminal.
3. Wipe *state* (safe: sessions, undo, shada):
   `rm -rf ~/.local/state/nvim`
4. Wipe *installed plugins* (safe: re-downloads from lockfile):
   `rm -rf ~/.local/share/nvim/lazy && nvim --headless "+Lazy! restore" +qa`
5. Wipe Mason tools (safe: reinstall on demand):
   `rm -rf ~/.local/share/nvim/mason`
6. Nuclear: fresh clone of this repo over `~/.config/nvim` (your custom
   changes live in git history/branches, so nothing is truly lost).

`scripts/verify.sh` after any recovery confirms the result.

## Version pinning policy

- `lazy-lock.json` **is** the pin — committed, always.
- `version = false` in specs (LazyVim default): track main branches, rely on
  lockfile for reproducibility. Pin individual plugins by `commit`/`version`
  only when actively dodging a regression, and leave a comment with the
  upstream issue link so the pin gets removed when it's fixed.
