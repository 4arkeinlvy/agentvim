# Copy to .claude/commands/refactor.md → use as /refactor <scope + goal>

Refactor: $ARGUMENTS

Rules of engagement:

1. **Plan first, no edits.** Map every file the change touches, in
   dependency order. Flag public interfaces and anything without test
   coverage — those are the risk. Wait for my approval.
2. Behavior-preserving only — if you find a bug mid-refactor, report it,
   don't silently fix it in the same diff.
3. Mechanical renames/moves go through LSP-style whole-symbol edits, and
   grep afterwards for stragglers (strings, comments, docs, configs).
4. Run the test suite before starting (baseline) and after each file
   group. A refactor that "should still pass" isn't done until it does.
5. Small commits per logical step, each message naming what moved where.

Deliverable: the plan, then diffs per step, then the before/after test run.
