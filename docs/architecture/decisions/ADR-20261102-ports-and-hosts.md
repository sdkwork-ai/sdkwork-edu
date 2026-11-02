# ADR-20261102: Ports And Public Hosts

- Status: Accepted
- Date: 2026-11-02
- Related: `APP_RUNTIME_TOPOLOGY_SPEC.md`, `REGION_SPEC.md`, `CONFIG_SPEC.md`

## Context

Every application needs a stable development ingress port and a public host per
environment. Port `3900` is shared by many applications as a generic gateway bind and is
therefore a poor default for a new standalone profile.

## Decision

| Concern | Value |
| --- | --- |
| Standalone dev ingress | `127.0.0.1:3910` |
| Web dev ingress (vite) | `127.0.0.1:5257` |
| PC internal dev port | `5259` |
| H5 internal dev port | `5260` |
| Public host (production) | `edu.sdkwork.com` |
| Public host (non-production) | `edu-<env>.sdkwork.com` and the mirror domain set |
| Container ingress | `0.0.0.0:3910` |

## Consequences

- No collision with `sdkwork-course` (`3900`), `sdkwork-iam` (`3901`) or the
  `18079`-`18097` range.
- `specs/topology.spec.json`, `etc/topology/*.env`, `deployments/deploy.yaml` and the
  webserver profiles all agree on these values.

## Alternatives Considered

- **Reuse `3900`.** Rejected: multiple applications binding the same development port makes
  local orchestration order-dependent.