# ADR-20261102: Service Discovery Is Deferred

- Status: Accepted
- Date: 2026-11-02
- Related: `DISCOVERY_SPEC.md`, `RPC_FRAMEWORK_SPEC.md`

## Context

`sdkwork-discovery` provides registry and resolution for RPC services. SDKWork Edu ships
HTTP surfaces only: no `sdkwork-rpc-framework` dependency, no `.proto`, no gRPC server
crate. No application repository in the workspace integrates discovery today, and the
reference repositories document it as not required.

## Decision

`sdkwork-discovery` is **not** integrated in 0.1.0. `README.md` records it as
`Not required (no RPC services yet)`.

## Trigger To Revisit

Either condition reopens this decision:

1. The repository gains an RPC server crate (`sdkwork-edu-rpc` or equivalent); or
2. Any RPC caller must resolve peers across more than one instance.

Integration order, once triggered: wire `sdkwork-rpc-framework` first (client resolver),
then `sdkwork-discovery` with `resolver profile = discovery` (or `composite` with discovery
primary), implement `startup -> register -> renew` and
`shutdown -> deregister -> drain`, use PostgreSQL storage (SQLite is rejected), and pass
`check-discovery-standard` and `check-rpc-framework-standard`.

## Consequences

- One fewer moving part and no registration lifecycle to operate.
- Adding an RPC surface later is a reviewed change, not an incidental one.