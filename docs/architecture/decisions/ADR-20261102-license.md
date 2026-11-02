# ADR-20261102: License

- Status: Accepted
- Date: 2026-11-02

## Context

SDKWork repositories are licensed `AGPL-3.0-or-later` at the workspace root, but at least
one sibling mixes `Apache-2.0` into individual crates, which makes the effective license of
those crates ambiguous.

## Decision

`AGPL-3.0-or-later` everywhere: the root `LICENSE`, `[workspace.package].license`, every
crate that declares its own license, and every `package.json`.

## Consequences

- `cargo metadata` reports one license for every workspace member.
- Vendored or generated third-party code must be license-compatible before it is added.