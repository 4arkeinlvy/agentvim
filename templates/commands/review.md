# Copy to .claude/commands/review.md → use as /review [target]

Review $ARGUMENTS (default: the diff between this branch and main).

Order strictly by severity, and within severity by confidence:

1. **Correctness** — bugs, unhandled edge cases, race conditions, broken
   error paths. For each: cite `file:line`, describe the failing input or
   state, and the wrong outcome.
2. **Security** — injection, authz gaps, secrets, unsafe deserialization.
3. **Simplification** — code that reimplements stdlib/existing helpers in
   this repo, dead flexibility, speculative abstraction. Name the existing
   thing to reuse.
4. **Tests** — missing coverage only for behavior changed in this diff.

Rules: read the surrounding code before judging a hunk — the diff alone
lies. No style nits the formatter would catch. No praise padding. If
nothing is wrong at a level, say "none found" and move on. End with a
one-line verdict: merge / merge-after-fixes / do-not-merge.
