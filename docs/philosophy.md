# Philosophy

The principles that decide what gets merged. When a proposal conflicts with
one of these, the proposal loses — or the principle is amended in a PR, in
writing.

1. **AI augments engineering; it does not replace it.** Every AI edit lands
   as a reviewable diff. The human accepts, rejects, and owns the result.
   Anything that encourages blind-accepting is a bug in the workflow.

2. **Integrate agents, don't re-implement them.** The agent CLI the user
   already runs — with its auth, MCP servers, and memory — is the source of
   truth. The editor plugs in. (See [ai.md](ai.md).)

3. **Keyboard-first, not keyboard-only.** Mouse works everywhere (yes, in
   the picker; yes, resizing splits). Speed comes from keys; nobody should
   be *stranded* without them.

4. **Every plugin justifies its existence** — problem, alternatives,
   tradeoffs, in writing ([plugins.md](plugins.md)). "It's popular" is not a
   justification. The best plugin count is the lowest one that does the job.

5. **Stable beats novel.** Prefer mature plugins by authors with a
   maintenance track record. New-and-shiny earns its way in by surviving in
   a branch first.

6. **Documentation is part of the product.** A feature that isn't
   documented doesn't exist. Docs explain *why*, not just *how* — the why is
   what survives plugin churn. Markdown is treated as a first-class artifact
   because it's also the AI context language.

7. **Defaults sensible, escape hatches everywhere.** Beginners get a
   working IDE on first launch; experts override any spec in
   `lua/plugins/` without forking. Inherit from LazyVim; don't wrap it in
   our own abstraction layer.

8. **Reproducible or it didn't happen.** Locked plugin versions, scripted
   install, measured performance claims. If it can't be rolled back in one
   command, it doesn't ship.

9. **Optimize for years, not demos.** Choices weigh maintenance burden over
   feature count. Boring technology that will still work in five years
   beats impressive technology that needs babysitting for five weeks.
