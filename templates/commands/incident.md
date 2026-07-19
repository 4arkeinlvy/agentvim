# Copy to .claude/commands/incident.md → use as /incident <symptom or paste>

Production incident triage for: $ARGUMENTS

Phase 1 — **Stabilize (do first, report immediately):**
- From the symptom, list the 3 most likely causes *in this codebase* with a
  quick check for each (log line to grep, endpoint to curl, query to run).
- Identify the fastest safe mitigation (rollback? feature flag? scale?) and
  say explicitly whether it loses data.

Phase 2 — **Diagnose:**
- Trace the failing path in code; correlate with whatever logs/output I
  give you. State your confidence and what evidence would raise it.
- Distinguish trigger (what changed) from root cause (why it was possible).

Phase 3 — **Fix & prevent:**
- Minimal fix diff for review — not applied until I say so.
- The regression test that would have caught this.
- One-paragraph postmortem note for docs/knowledge/ (dated).

Never push, deploy, or migrate anything during an incident without an
explicit instruction.
