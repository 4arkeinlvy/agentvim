# Engineering Workflows

Not plugin tours — end-to-end recipes. Each lists the tools, the keys, where
the AI sits, and what "done" looks like. Keybinding legend: `Space` = leader.

## Backend feature (FastAPI / Python)

**Tools:** Pyright + Ruff (auto), venv-selector, Claude Code, DAP.

1. `tmux new -s api` → `nvim`. Select the project venv once: `Space c v`.
2. `Space a c` → Claude in plan mode: *"add a paginated GET /invoices
   endpoint; look at how /orders does it first"* — pointing at an existing
   pattern is the highest-value sentence you can type.
3. Accept diffs file-by-file (`Space a a`). Ruff formats on save.
4. Test loop in the float terminal `Ctrl+/`: `pytest -x -q` (or have Claude
   run it). Debug a gnarly failure with breakpoints: `Space d b` on a line,
   `Space d c` to run the test under debugpy.
5. `Space g g` → stage hunks, commit. **Done =** endpoint + passing tests +
   clean diff you actually read.

## Frontend feature (React / TypeScript)

**Tools:** vtsls, Tailwind LSP, Prettier, Claude Code.

1. Window 1 `nvim`, window 3 `npm run dev`.
2. Component skeleton: `Space a c` → *"create an InvoiceTable following
   OrdersTable.tsx conventions"*. Tailwind classes autocomplete with color
   swatches; `gd` jumps into component definitions, `gr` finds usages.
3. Rename a prop across the codebase: `Space c r` (LSP rename — safer than
   agent find-replace).
4. Visual check in the browser; iterate via selection: select JSX →
   `Space a s` → *"make this responsive"*.

## Bug investigation

1. Reproduce first: failing command in `Ctrl+/` terminal.
2. `Space a c`: paste the stack trace (or `Space a b` to add the suspect
   file). Ask for *root cause before any fix* — "explain why this happens;
   don't edit yet."
3. Cross-check big diagnoses with a second agent
   ([agent-orchestration.md](agent-orchestration.md#orchestration-patterns)).
4. Fix + regression test in one diff; `]d` walks any new diagnostics.
   **Done =** the old failure fails no more *and* is pinned by a test.

## Code review (a PR or branch)

1. `Space g g` → lazygit → browse the branch diff; or `git diff main | nvim -`.
2. Claude: *"review the diff between main and HEAD: correctness first, then
   naming, then perf; cite file:line"*. Trouble panel (`Space x x`) tracks
   anything it turns into diagnostics.
3. Independent pass from Codex/Gemini for high-stakes changes; human
   arbitrates disagreements — that's the review.

## Jupyter analysis

**Tools:** jupytext (auto), molten, per-project kernel.

```bash
cd project && source .venv/bin/activate
pip install ipykernel && python -m ipykernel install --user --name project
```

1. `nvim analysis.ipynb` — it opens as Markdown with code fences.
2. `Space j i` → pick the `project` kernel.
3. Run: select lines → `Space j e`; outputs render inline (`Space j o` to
   reopen). Dataframes/text always work; add image.nvim for inline plots
   (see [usage.md](usage.md#notebooks)).
4. Refactor freely — it's a text buffer with full LSP. Save writes valid
   `.ipynb`; the git diff stays human-readable.

## Kubernetes debugging

**Tools:** yamlls (Kubernetes schemas built in), kubectl, a kube-context
switcher, Claude Code.

Set up per-cluster kubeconfigs once (this pattern scopes the context to one
shell — prod in pane A can't leak into pane B):

```bash
mkdir -p ~/.kube/configs        # drop staging.yaml, prod.yaml here
# in ~/.zshrc or ~/.bashrc:
use() {
  local dir=~/.kube/configs f
  if [ -z "$1" ]; then command ls "$dir" 2>/dev/null | sed 's/\.ya\?ml$//'; return; fi
  for f in "$dir/$1.yaml" "$dir/$1.yml" "$dir/$1"; do
    [ -f "$f" ] && export KUBECONFIG=$f && kubectl config current-context && return
  done
  echo "no kubeconfig named '$1'" >&2; return 1
}
```

1. tmux window: `use staging` → `kubectl get pods -w`. Another pane:
   `use prod` for read-only comparison. (`kubectx` is the plugin-equivalent
   if you prefer a tool; this is 12 lines of shell.)
2. Manifests in nvim get schema validation + completion from yamlls —
   most "why won't it apply" bugs are red-underlined before you apply.
3. Feed incidents to Claude with real data: `kubectl describe pod X > /tmp/pod.txt`,
   then *"read /tmp/pod.txt — why is this pod CrashLooping?"* Files beat
   pasted walls of text.
4. Fix the manifest (diff review), `kubectl apply` from the pane, watch.

## LaTeX paper

1. `nvim paper.tex` → `\ll` once — latexmk recompiles on every save; PDF
   follows along, `\lv` jumps the PDF to your cursor.
2. Citations autocomplete from the `.bib`; `]]`/`[[` move between sections;
   `cse` changes an environment.
3. AI for prose: select a paragraph → `Space a s` → *"tighten this abstract;
   keep the claims"*. Review the diff like code.

## Refactoring (multi-file)

1. Mechanical, type-safe renames → **LSP** (`Space c r`), not AI.
2. Structural changes → Claude in plan mode: *"extract the retry logic in
   services/*.py into a shared decorator; show the plan first"*. Approve,
   then accept diffs per file. Grep-verify leftovers: `Space /` old name.
3. The test suite is the referee; run it before and after
   (`Ctrl+/` → `pytest`). No green, no merge.
