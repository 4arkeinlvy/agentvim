# CLAUDE.md — FastAPI service (template: replace ALL-CAPS placeholders)

## Project

SERVICE_NAME: one-sentence purpose. Python 3.12, FastAPI, SQLAlchemy 2,
Postgres. Managed with uv.

## Commands

```bash
uv sync                                  # install deps
uv run uvicorn app.main:app --reload     # dev server :8000
uv run pytest -x -q                      # tests — run before declaring done
uv run ruff check . && uv run ruff format .
uv run alembic upgrade head              # migrations
```

## Layout

- `app/api/` — routers; thin: validate, call service, map errors to HTTP
- `app/services/` — business logic; no FastAPI imports here
- `app/repositories/` — all DB access; services never touch the session directly
- `app/models/` — SQLAlchemy models · `app/schemas/` — Pydantic I/O schemas
- `tests/` — mirrors app/; fixtures in `tests/conftest.py`

## Conventions

- New endpoint = router + service + schema + test, following an existing
  endpoint as the pattern (look at a neighbor first)
- Domain exceptions in `app/exceptions.py`; the global handler maps them —
  never `raise HTTPException` from services
- DB schema changes always via Alembic migration, never by editing models alone

## Never

- Never commit `.env` (see `.env.example`) · never log request bodies with
  PII · never write to the DB from `app/api/`
