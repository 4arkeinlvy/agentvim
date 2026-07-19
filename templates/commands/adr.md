# Copy to .claude/commands/adr.md → use as /adr <decision topic>

Draft an Architecture Decision Record for: $ARGUMENTS

1. Search the repo (code, docs/adr/, git log) for prior art and constraints
   relevant to this decision. Cite what you find.
2. Write the ADR using docs/adr/ numbering (next free NNN) and the
   project's ADR template (or AgentVim's templates/adr.md): Context,
   Decision, Alternatives considered (table, with honest "why not"),
   Consequences including accepted debt and a "revisit when" trigger.
3. Status is **proposed** — a human flips it to accepted.
4. Keep it under a page. The alternatives table is the most valuable part;
   don't strawman the losing options.

Write the file into docs/adr/ and show me the summary.
