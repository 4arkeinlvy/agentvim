# CLAUDE.md — project context template

<!-- Copy to your project root as CLAUDE.md (Claude Code) and/or AGENTS.md
     (Codex etc. — keep ONE canonical, make the other a pointer).
     Delete sections that don't apply; shorter is better. Every line here
     is something agents would otherwise have to rediscover each session.
     See docs/context.md in AgentVim for the reasoning. -->

## Project

One paragraph: what this is, who uses it, current phase.

## Commands

```bash
make dev        # run locally  (REPLACE with real commands)
make test       # run tests — ALWAYS run before declaring work done
make lint       # lint + format
```

## Layout

- `src/api/` — HTTP layer; thin handlers only, logic lives in `src/services/`
- `src/services/` — business logic; pure where possible
- `tests/` — mirrors src/ structure

## Conventions

- (e.g.) Errors: raise domain exceptions from services; handlers map to HTTP
- (e.g.) DB access only through repositories; no ORM calls in services
- Follow existing patterns in neighboring files over anything generic

## Never

- Never commit directly to main
- Never edit generated files (`*_pb2.py`, `migrations/` after merge)
- Never store secrets in code — env vars via `.env` (see `.env.example`)

## Context pointers

- Architecture decisions: `docs/adr/`
- Domain gotchas: `docs/knowledge/`
