# ADR-001: Feature folders over type folders

- **Status:** accepted
- **Date:** YYYY-MM-DD

## Context

Type-based layout (`components/`, `hooks/`, `api/`) scatters every feature
across the tree; each change touches four distant directories, and agents
asked to "add X" can't infer where anything goes.

## Decision

Group by feature: `src/features/<name>/{components,hooks,api,types}` with a
public `index.ts`. Shared primitives live in `src/shared/`.

## Alternatives considered

| Option | Why not |
|---|---|
| Type folders | Poor locality; import spaghetti between siblings |
| Monorepo packages per feature | Build overhead unjustified below ~10 devs |

## Consequences

- Good: a feature is one directory — reviewable, deletable, explainable to
  an agent in one line.
- Debt: judgment calls on what's "shared"; default is: duplicated twice →
  stays local, needed a third time → promote to shared.
- Revisit when: features need independent deploy/versioning.
