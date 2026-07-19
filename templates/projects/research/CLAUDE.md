# CLAUDE.md — research project / paper (template)

## Project

PAPER_TITLE — target venue VENUE, deadline DATE. LaTeX via latexmk;
experiments in Python (uv-managed venv), notebooks for exploration.

## Commands

```bash
latexmk -pdf paper/main.tex        # build (or \ll inside AgentVim)
uv run python -m experiments.run --config configs/BASE.yaml
uv run pytest tests/ -x -q         # sanity tests for data pipeline
```

## Layout

- `paper/` — `main.tex`, `sections/*.tex` (one file per section), `refs.bib`
- `experiments/` — importable pipeline code (the source of truth)
- `notebooks/` — exploration only; promising code graduates to
  `experiments/` with a test. Notebooks are throwaway; modules are forever
- `data/` — gitignored; `data/README.md` documents how to fetch/regenerate
- `results/` — generated figures/tables, one script per artifact in
  `experiments/figures/` — every number in the paper must be regenerable

## Conventions

- Every figure/table in the paper is produced by a script, never edited by
  hand — reviewer asks "rerun with X" must be one command
- Claims in prose link to the experiment that supports them (comment with
  the script path next to the claim)
- BibTeX keys: `author2024keyword`; no duplicate entries — search refs.bib
  before adding

## Never

- Never commit `data/` or credentials · never overwrite `results/` of a
  tagged experiment — new config = new results dir
