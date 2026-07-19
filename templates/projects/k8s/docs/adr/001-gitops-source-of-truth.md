# ADR-001: Git is the only write path to clusters

- **Status:** accepted
- **Date:** YYYY-MM-DD

## Context

Mixed manual `kubectl` + repo-driven changes means the repo lies: debugging
starts with "what's *actually* running?", and an AI agent given cluster
access could drift things further.

## Decision

All cluster mutations flow repo → PR → CI. Humans and agents get read-only
contexts for prod; `kubectl apply` by hand is limited to dev.

## Alternatives considered

| Option | Why not |
|---|---|
| Trusted operators apply by hand | Works until the second operator; no review trail |
| Helm everywhere | Templating power unneeded for our overlay deltas; kustomize keeps YAML greppable for agents |

## Consequences

- Good: `git log` is the deploy history; agents can propose infra changes
  as ordinary PRs — the dangerous permission stays with CI.
- Debt: emergency fixes take a PR round-trip — mitigated by a fast-track
  label and small overlays.
- Revisit when: multi-cluster fleet or app-team self-service demands more
  than overlays.
