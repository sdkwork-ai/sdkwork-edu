# ADR-20261102: Workspace Registration

- Status: Accepted
- Date: 2026-11-02
- Related: `SDKWORK_WORKSPACE_SPEC.md`, `PNPM_WORKSPACE_DEPENDENCY_SPEC.md`

## Context

SDKWork applications consume platform capabilities as sibling checkouts under
`sdkwork-space/` and are themselves siblings. A repository outside that layout cannot use
`path = "../sdkwork-*"` dependencies and would have to vendor or publish.

## Decision

The repository lives at `sdkwork-space/sdkwork-edu` and is registered as a sibling
repository alongside the other applications.

## Consequences

- `Cargo.toml` uses `path = "../sdkwork-*"` for platform crates.
- `pnpm-workspace.yaml` declares each sibling package once.
- Every sibling referenced by either manifest has a matching `agent.workflow.json`
  `dependencies[]` entry, so CI materializes the same layout.
- `check-workspace-path-portability` must stay green: no machine-absolute paths.