# CLAUDE.md — React app (template: replace ALL-CAPS placeholders)

## Project

APP_NAME: one-sentence purpose. React 19 + TypeScript + Vite, Tailwind,
TanStack Query for server state.

## Commands

```bash
npm run dev          # :5173
npm run test         # vitest — run before declaring done
npm run lint         # eslint + prettier check
npm run build        # type-checks too; must pass
```

## Layout

- `src/features/<name>/` — components, hooks, api, types per feature;
  features don't import from each other's internals (only `index.ts`)
- `src/shared/` — cross-feature UI kit, api client, utils
- `src/routes/` — route components only; compose features, no logic

## Conventions

- Server state via TanStack Query hooks in `features/*/api.ts`; no fetch in
  components. Local UI state stays in components — no global store until an
  ADR says so
- Follow an existing feature folder as the pattern for any new feature
- Tailwind only; no new CSS files. Variants via the existing `cn()` helper

## Never

- Never `any` (use `unknown` + narrowing) · never disable eslint rules
  inline without a comment explaining why · never import across feature
  internals
