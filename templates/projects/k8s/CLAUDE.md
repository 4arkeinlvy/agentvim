# CLAUDE.md — Kubernetes infra repo (template)

## Project

Infrastructure for SYSTEM_NAME. Kustomize overlays per environment;
deployed by CI (ArgoCD/Flux/pipeline — NAME IT), never by hand.

## Commands

```bash
kubectl kustomize overlays/staging          # render — always inspect before apply
kubectl apply -k overlays/staging --dry-run=server   # validate against cluster
use staging                                  # kube-context switcher (see AgentVim workflows.md)
kubectl -n NAMESPACE get pods
```

## Layout

- `base/` — environment-agnostic manifests, one directory per service
- `overlays/{dev,staging,prod}/` — kustomize patches only: replicas,
  resources, env-specific config. If it's identical across envs it belongs
  in `base/`
- `docs/adr/` — decisions (why kustomize, why these resource limits…)

## Conventions

- Change flow: edit → render → server dry-run → PR. CI applies; humans and
  agents never `kubectl apply` to prod directly
- Every container: resource requests+limits, liveness+readiness probes —
  linted, no exceptions without an ADR
- Secrets via EXTERNAL_SECRET_MECHANISM (name it); manifests contain only
  references — never values

## Never

- Never edit live cluster state (`kubectl edit`) — repo is the source of
  truth · never touch `overlays/prod/` without an explicit instruction ·
  never delete PVCs/namespaces even in dev without confirmation
