# Architecture Decisions

One record per decision: `ADR-YYYYMMDD-<slug>.md`. Decisions are append-only. To change a
decision, add a new ADR that supersedes the old one and link both directions.

| ADR | Decision | Status |
| --- | --- | --- |
| [ADR-20261102-domain-taxonomy](ADR-20261102-domain-taxonomy.md) | App domain `content`, capability `edu`, permission prefix `edu` | Accepted |
| [ADR-20261102-education-scope](ADR-20261102-education-scope.md) | Scope is education administration, not course content | Accepted |
| [ADR-20261102-discovery-deferred](ADR-20261102-discovery-deferred.md) | `sdkwork-discovery` is not integrated until an RPC surface exists | Accepted |
| [ADR-20261102-ports-and-hosts](ADR-20261102-ports-and-hosts.md) | Single ingress on `3910`, public hosts `edu[-env].<domain>` | Accepted |
| [ADR-20261102-license](ADR-20261102-license.md) | `AGPL-3.0-or-later` across the workspace | Accepted |
| [ADR-20261102-workspace-registration](ADR-20261102-workspace-registration.md) | Repository joins the `sdkwork-space` sibling layout | Accepted |