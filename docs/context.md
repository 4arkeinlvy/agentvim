# Context Engineering

The highest-leverage AI skill is not prompting — it's leaving the right
files where agents will find them. Agents are stateless; your repo is their
memory.

## The instruction files

| File | Read by | Contents |
|---|---|---|
| `CLAUDE.md` | Claude Code (auto) | Build/test commands, conventions, architecture pointers, "never do X" rules |
| `AGENTS.md` | Codex and most other CLIs (auto) | Same content — keep one canonical file and make the other a pointer/symlink |
| `README.md` | Humans first, agents second | What/why/quickstart — don't duplicate agent instructions here |

Starter template: [templates/CLAUDE.md](../templates/CLAUDE.md).

**Hierarchy.** Instructions cascade; put things at the *narrowest* scope that
needs them:

```
~/.claude/CLAUDE.md          # personal, all projects (your style prefs)
repo/CLAUDE.md               # project: commands, conventions, layout
repo/backend/CLAUDE.md       # subsystem quirks only backend work needs
```

Rule of thumb: if an instruction would be wrong in another repo, it doesn't
belong in the global file; if it's only true for one directory, push it down.

## Project knowledge layout

```
docs/
├── architecture/    # how the system is shaped, diagrams, data flow
├── adr/             # numbered decision records (the "why" that survives)
├── knowledge/       # domain facts, external API quirks, gotchas
├── prompts/         # reusable prompts / slash commands that work well
└── research/        # investigation write-ups (dated, immutable)
```

Why this works for agents:

- **ADRs are the big one.** "Why is this a monolith?" answered in
  `docs/adr/003-monolith.md` prevents every future agent from helpfully
  proposing microservices. Template: [templates/adr.md](../templates/adr.md).
  Write one whenever a decision was expensive to reach.
- **Small files, descriptive names.** Agents retrieve by grep/filename. A
  200-line `payments-retry-logic.md` gets found and fits in context; a
  5,000-line `NOTES.md` does neither.
- **Markdown is the interface.** Tables, code fences, and headers survive
  agent parsing perfectly. Binary docs (Word, Notion exports) are invisible.

## Context hygiene

- **Compression:** when a doc grows past a few hundred lines, split it and
  leave a one-paragraph summary + links at the old path. Agents (and humans)
  read summaries first, follow links on demand.
- **Retrieval strategy:** don't build RAG for a repo — agent CLIs grep. Your
  job is making grep *work*: real terms in filenames and headings, one topic
  per file.
- **Freshness:** stale instructions are worse than none (the agent obeys
  them). Delete aggressively; git remembers.
- **Long-term memory:** end significant sessions by asking the agent
  "update CLAUDE.md / the relevant ADR with what we decided." The `#` prefix
  in Claude Code appends a memory inline. Decisions that live only in chat
  history are decisions you'll pay to re-derive.
- **Prompt management:** prompts that worked go in `docs/prompts/` as
  Claude Code slash commands (`.claude/commands/foo.md` → `/foo`) — shared,
  versioned, reviewable like code.
