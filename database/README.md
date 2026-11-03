# database/

Authoritative database lifecycle assets (DATABASE_FRAMEWORK_SPEC.md section 5.1).

| Path | Purpose |
| --- | --- |
| `database.manifest.json` | Module identity, engine, prefix, lifecycle defaults, paths |
| `contract/schema.yaml` | Canonical schema contract (table inventory, ownership) |
| `contract/prefix-registry.json` | Registered table prefixes |
| `contract/table-registry.json` | Per-table owner, compliance level, lifecycle status |
| `ddl/baseline/postgres/` | Full initialization DDL |
| `ddl/generated/` | Engine DDL emitted by `sdkwork-db` (never authored by hand) |
| `migrations/postgres/` | Post-GA deltas only |
| `seeds/` | Seed manifest, common fixtures and locale bundles |
| `drift/policy.yaml` | Drift detection policy |
| `fixtures/` | Deterministic test data |

Module: `edu` | prefix: `edu_` | service code: `EDU` | role: `authoritative-server`.

## Initialization state

The module uses `baselineStrategy: baseline-plus-migrations`:

1. **Baseline** — `ddl/baseline/postgres/0001_edu_baseline.sql` is the authoritative
   greenfield DDL snapshot.
2. **Migrations** — `migrations/postgres/` carries ordered, idempotent post-baseline
   changes for already-initialized databases. Applied migrations are never edited.
3. **Contract** — `contract/schema.yaml`, `contract/prefix-registry.json`, and
   `contract/table-registry.json` are the module inventory consumed by the lifecycle
   and drift checks.

## Commands

```bash
pnpm db:validate            # framework standard check
pnpm db:plan                # show pending lifecycle work
pnpm db:init                # create schema and apply the baseline
pnpm db:migrate             # apply migrations
pnpm db:seed                # apply the default seed profile and locale
pnpm db:status              # applied revisions and state
pnpm db:drift:check         # compare live schema with the contract
```

Never edit an applied migration, and never run `db:init` against a database that already
holds data.