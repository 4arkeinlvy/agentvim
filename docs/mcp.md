# MCP Server Presets

MCP (Model Context Protocol) servers give agents tools beyond the shell —
browsers, databases, APIs. Because AgentVim integrates the **Claude Code
CLI itself**, every MCP server you configure for the CLI works inside
Neovim with zero editor config.

## First: what you *don't* need MCP for

Claude Code already has filesystem and shell access natively, which covers
git, docker, kubectl, gh — it just runs them. **Don't add an MCP server for
something the CLI already does well**; each server costs context tokens.
Add one when it provides a capability the shell doesn't (browser control,
schema-aware DB access, third-party APIs).

## Presets

Project scope (recommended — committed, shared with your team) goes in
`.mcp.json` at the repo root; template: [templates/mcp.json](../templates/mcp.json).
Personal scope: `claude mcp add --scope user …`.

**Playwright (browser automation / E2E debugging):**

```bash
claude mcp add playwright -- npx -y @playwright/mcp@latest
```

Agent can now open pages, click, screenshot — "open localhost:3000, submit
the login form, tell me what breaks."

**PostgreSQL (schema-aware, read-only queries):**

```bash
claude mcp add db -- npx -y @modelcontextprotocol/server-postgres \
  "postgresql://user:pass@localhost:5432/mydb"
```

"Which tables reference invoices, and what's the row count per status?"
without hand-feeding schemas. Point it at a **read replica or dev DB**,
never prod with write credentials.

**GitHub (issues/PRs/CI beyond what `gh` covers):**

```bash
claude mcp add github --transport http https://api.githubcopilot.com/mcp/
```

(GitHub's hosted server; authenticates via OAuth on first use. The `gh` CLI
via shell is often enough — prefer it for simple issue/PR reads.)

**Kubernetes (cluster introspection):**

```bash
claude mcp add k8s -- npx -y mcp-server-kubernetes
```

Uses your current kubeconfig — combine with the `use <cluster>` switcher
([workflows.md](workflows.md#kubernetes-debugging)) so the agent inherits
the *right* cluster, and keep it on read-only contexts.

## Managing

```bash
claude mcp list            # what's configured (and connection health)
claude mcp remove <name>
```

In a session, `/mcp` shows live server status. Rule of thumb: if `claude
mcp list` shows more than ~4 servers, you're paying context for tools you
rarely use — scope rarely-used servers to the projects that need them via
`.mcp.json` instead of user scope.
