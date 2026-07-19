# 10-Day Learning Path

One skill per day, ~20 minutes of deliberate practice on *real* work. Don't
skip ahead — each day compounds. `Space` = leader.

**Day 0 (5 min):** run `:Tutor` in nvim. Seriously — it's interactive and
covers raw motion basics faster than any doc.

## Day 1 — Moving

`h j k l`, `w` / `b`, `0` / `$`, `gg` / `G`, `Ctrl+d` / `Ctrl+u`, `/search n N`.
**Exercise:** open a real file, navigate to 10 specific spots without arrows
or mouse. **Rule:** arrows allowed today, banned tomorrow.

## Day 2 — Editing

`i a o` enter Insert, `Esc` leaves. Verbs+objects: `dd`, `ciw`, `di(`,
`yy p`, `u` / `Ctrl+r`. **Exercise:** rename variables with `ciw`, delete a
function body with `di{`, duplicate a line with `yyp`. Notice: `c`/`d`/`y` +
`i`/`a` + object is a *language*, not a shortcut list.

## Day 3 — Finding

`Space Space` files · `Space /` grep · `s`+2 chars flash-jump · `Ctrl+o`
jump back. **Exercise:** answer "where is X defined/used?" ten times in your
codebase without the explorer.

## Day 4 — Buffers & windows

`Space ,` picker · `Shift+h/l` cycle · `Space b d` close · `Ctrl+w v`/`s`
split · `Ctrl+h/j/k/l` move between splits. **Exercise:** two files
side-by-side, copy code from one to the other, close cleanly.

## Day 5 — LSP

`gd` `gr` `K` · `Space c r` rename · `Space c a` code action · `]d`
diagnostics · `Space x x` panel. **Exercise:** do a real rename refactor and
one auto-import via code action. This is where VSCode parity lands.

## Day 6 — Git

`Space g g` lazygit (`?` for help inside) · `]h` hunks · `Space g h s`
stage hunk. **Exercise:** stage *part* of a file (hunk-level), commit, view
the log — all without the shell.

## Day 7 — AI

`Space a c` Claude panel · visual + `Space a s` send selection ·
`Space a a`/`Space a d` accept/reject diffs · `Space a r` resume.
**Exercise:** one real feature: plan mode → approve → review diffs
one-by-one. Read [ai.md](ai.md) tonight.

## Day 8 — Debugging

`Space d b` breakpoint · `Space d c` continue · `Space d i`/`Space d o`
step in/over · hover variables. **Exercise:** debug a failing test with
breakpoints instead of print statements.

## Day 9 — Terminal & tmux

`Ctrl+/` float · `tmux new -s work`, `Ctrl+b %` split, `c` window, `d`
detach, `tmux attach`. **Exercise:** the standard layout — nvim + agent +
dev server ([agent-orchestration.md](agent-orchestration.md)) — detach,
reattach, everything alive.

## Day 10 — Your workflows

Pick your two from [workflows.md](workflows.md) (notebooks? LaTeX? k8s?)
and run them end-to-end. Then read [context.md](context.md) and write your
first project `CLAUDE.md` — the highest-leverage 30 minutes in this course.

**After day 10:** speed comes from *not thinking* about the keys. When you
notice a clunky repeated action, there's a better way — `Space s k` to
search keymaps, or ask Claude "how do I X in this config?" (it can read the
config).
