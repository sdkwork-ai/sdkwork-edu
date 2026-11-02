# tools/

Reusable logic behind `scripts/` entrypoints.

| Directory | Purpose |
| --- | --- |
| `validators/` | Repository-local contract validators |
| `generators/` | Materializers (route manifests, OpenAPI, database contract) |
| `migrations/` | One-off data or schema migrations |
| `operators/` | Operational helpers (drift reports, seed audits) |

Rules: `scripts/` holds thin entrypoints only; logic lives here and is unit tested.