# Agent Orchestration

Running more than one AI agent on one repository without them trampling each
other. The primitives are boring on purpose: tmux for process layout, git for
conflict control, Markdown files for shared context.

## The standard layout

```
tmux session "myproject"
├── window 1: nvim  (+ Claude Code panel via Space a c)
├── window 2: codex          ← second opinion / parallel worker
├── window 3: dev server / logs / kubectl
└── window 4: shell
```

`Ctrl+b c` new window, `Ctrl+b 1..4` jump, `Ctrl+b %` split, `Ctrl+b d`
detach (agents keep running — reattach with `tmux attach`).

## The one-writer rule

**At most one agent has write access to the working tree at a time.**
Everything else reads. This single rule eliminates 90% of multi-agent chaos:

- Claude implementing? Codex/Gemini run in *ask/plan mode* (or you simply
  don't ask them to edit).
- Need two agents implementing in parallel? Give each its own branch via
  `git worktree` — `scripts/worktree.sh` wraps it:

  ```bash
  ~/.config/nvim/scripts/worktree.sh add codex-attempt
  # window 2: cd ../myproject-codex-attempt && codex
  ```

  Same repo, isolated trees, merge the winner. Claude Code's built-in
  subagents use the same idea internally.

## Orchestration patterns

**Feature development (implement → review → optimize):**

1. *Claude* (`Space a c`): plan mode first, approve the plan, implement.
   Review each diff (`Space a a` / `Space a d`).
2. *Codex* (window 2): `codex "review the diff on this branch vs main;
   list correctness issues only"` — a genuinely independent reviewer with
   different training biases.
3. Feed disagreements back to Claude; human decides ties.
4. Commit via lazygit (`Space g g`) — you write the message, or let Claude
   commit and review it in lazygit before pushing.

**Debugging (hypothesis cross-check):**

1. Claude: "reproduce and root-cause this failing test" — it runs the suite.
2. If the fix smells like a symptom patch: Gemini/Codex gets the same failing
   test *without seeing Claude's diagnosis* — independent diagnoses that
   agree are strong evidence.
3. Claude implements + regression test; you accept diffs.

**Architecture review (proposal → critique → human decision):**

1. Claude drafts `docs/adr/NNN-proposal.md` (template in
   [templates/adr.md](../templates/adr.md)).
2. Second agent critiques the *file* (not the chat): "read this ADR, attack
   its weakest assumptions."
3. Human accepts/amends; the ADR is committed — decision becomes permanent
   context for every future agent session.

## Context synchronization

Agents don't share memory. They share the **repo**:

- Durable knowledge → `CLAUDE.md` / `AGENTS.md` / `docs/` (see
  [context.md](context.md)). Both Claude and Codex read their respective
  instruction files automatically; keep one canonical and `@`-include or
  symlink the other.
- Task state between agents → a scratch `PLAN.md` or the ADR under review.
  "Window 2, read PLAN.md and continue step 3" beats re-explaining.
- Never relay long context by copy-pasting between chats — write it to a
  file and reference the path. Files are cheap, chat scrollback is lossy.

## Cost & model discipline

- Match model to task: heavy reasoning (architecture, gnarly bugs) on the big
  model; mechanical batches (rename, boilerplate, lint fixes) on the small
  one (`/model` in Claude Code).
- One task per session; `/clear` between tasks. Long mixed sessions burn
  tokens re-reading stale context.
- Resumable by design: `Space a r` (resume picker) / `Space a C` (continue
  last) — don't re-prompt from zero after a restart.
- Let `CLAUDE.md` answer the questions every session would otherwise ask
  (build commands, conventions, layout) — paying the explanation cost once
  instead of every conversation.
