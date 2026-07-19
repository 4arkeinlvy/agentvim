# ADR-001: Layered architecture (api → services → repositories)

- **Status:** accepted
- **Date:** YYYY-MM-DD

## Context

FastAPI makes it easy to put queries and logic directly in route handlers;
that stops scaling as soon as logic is reused outside HTTP (workers, CLI,
tests).

## Decision

Three layers with one-way imports: `api` (HTTP concerns) → `services`
(domain logic, framework-free) → `repositories` (all persistence).

## Alternatives considered

| Option | Why not |
|---|---|
| Fat handlers | Untestable without HTTP; logic duplicated in workers |
| Full DDD/hexagonal | Ceremony exceeds current team/domain size — revisit at ~20+ entities |

## Consequences

- Good: services testable without HTTP or DB mocks at the route level;
  agents have an obvious "where does this go" rule.
- Debt: some pass-through service methods that just call a repository.
- Revisit when: a second delivery mechanism (gRPC, CLI) or domain events
  appear.
