# tests/

| Directory | Purpose |
| --- | --- |
| `contract/` | Envelope, pagination, permission-tier, database-framework and route-integration contracts |
| `integration/` | Cross-module tests against an initialized database |
| `e2e/` | Browser end-to-end flows (PC and H5) |
| `fixtures/` | Deterministic, non-secret test data |
| `static/` | Small checked-in fixtures served as static files |

Rules: tests never touch production data, never embed credentials, and never assert on
generated SDK internals. Run `pnpm test` for the fast suite and `pnpm verify` for the
gate-grade suite.