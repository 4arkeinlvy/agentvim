# ADR-001: Every paper artifact is script-generated

- **Status:** accepted
- **Date:** YYYY-MM-DD

## Context

Hand-tweaked figures and copy-pasted numbers rot instantly: a reviewer
request or a bug fix invalidates them, and nobody remembers which notebook
cell produced Figure 3.

## Decision

One script per figure/table under `experiments/figures/`; `results/` is
fully regenerable from configs + data. Notebooks are exploration only —
nothing in the paper may depend on notebook state.

## Alternatives considered

| Option | Why not |
|---|---|
| Notebooks as source of truth | Hidden state, unreviewable diffs, non-deterministic execution order |
| Full workflow engine (Snakemake/DVC) | Worth it for >~20 pipeline stages; start simple, this ADR's revisit clause covers it |

## Consequences

- Good: camera-ready rebuilds in one command; agents can safely regenerate
  anything.
- Debt: small upfront cost promoting notebook code to modules.
- Revisit when: pipeline stages or dataset versions outgrow flat scripts.
