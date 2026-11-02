# SDKWork Edu

repository-kind: application

SDKWork Edu is the education administration and teaching operation application of the
SDKWork platform: academic terms, classes, students, teachers, enrollment, scheduling,
attendance, assessments, assignments and teaching materials.

This repository is the application root. Platform capabilities are consumed as sibling
SDKWork repositories; they are never forked or re-implemented here.

## Principal Dependencies

| Capability | Dependency | Status |
| --- | --- | --- |
| HTTP framework | `sdkwork-web-framework` (`sdkwork-web-core`, `-axum`, `-contract`, `-bootstrap`) | Required |
| Database | `sdkwork-database` (`-config`, `-lifecycle`, `-spi`, `-sqlx`, `sdkwork-db` CLI) | Required |
| Utilities | `sdkwork-utils` (`sdkwork-utils-rust`, `@sdkwork/utils`) | Required |
| Identity | `sdkwork-iam` (`sdkwork-iam-web-adapter`) | Required |
| File upload and storage | `sdkwork-drive` (`sdkwork-drive-uploader-service`, `@sdkwork/drive-app-sdk`) | Required |
| Service discovery | `sdkwork-discovery` | Not required (no RPC services yet) |

`sdkwork-discovery` is deliberately absent: this application ships HTTP surfaces only.
Add it when an RPC server crate or a multi-instance RPC consumer appears, and wire
`sdkwork-rpc-framework` first. See `docs/architecture/decisions/ADR-20261102-discovery-deferred.md`.

## Commands

```bash
pnpm install
pnpm dev              # standalone development profile
pnpm build
pnpm test
pnpm check
pnpm verify
```

Rust workspace: `cargo build --workspace`, `cargo test --workspace`,
`cargo clippy --workspace --tests -- -D warnings`, `cargo fmt --all --check`.

Database lifecycle: `pnpm db:validate`, `pnpm db:plan`, `pnpm db:init`, `pnpm db:migrate`,
`pnpm db:seed`, `pnpm db:status`, `pnpm db:drift:check`.

## Documentation Canon

- [docs/README.md](docs/README.md)
- [docs/product/prd/PRD.md](docs/product/prd/PRD.md)
- [docs/architecture/tech/TECH_ARCHITECTURE.md](docs/architecture/tech/TECH_ARCHITECTURE.md)

## Layout

| Path | Purpose |
| --- | --- |
| `apis/` | Authored API operation contracts (app-api, backend-api) |
| [`apps/`](apps/README.md) | Client application roots (`sdkwork-edu-pc`, `sdkwork-edu-h5`, `sdkwork-edu-common`) |
| `bin/` | Standard nine-entrypoint build/package/deploy family |
| `crates/` | Rust workspace: service, repository, routes, assembly, gateway, hosts |
| `database/` | Authoritative lifecycle assets (contract, DDL, migrations, seeds, drift) |
| `deployments/` | Docker image, webserver profiles, deployment manifest |
| `docs/` | Product, architecture, engineering and operations Canon |
| `etc/` | Checked-in topology profiles and deployment configuration |
| `sdks/` | SDK families, route manifests and generated clients |
| `specs/` | Machine-readable application contracts |
| `tests/` | Contract, integration and end-to-end verification |

## Standards

All work follows `../sdkwork-specs`. Read `AGENTS.md` first; it indexes the required
specs per task type. Do not copy standard text into this repository.