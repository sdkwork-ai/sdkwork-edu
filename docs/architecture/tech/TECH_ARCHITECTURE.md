# SDKWork Edu - Technical Architecture

- Status: draft
- Owner: sdkwork-edu
- Version: 0.1.0
- Related: [PRD](../../product/prd/PRD.md), [ADRs](../decisions/README.md)
- Decision standard: `../sdkwork-specs/ARCHITECTURE_DECISION_SPEC.md`
- Architecture standard: `../sdkwork-specs/APPLICATION_LAYERED_ARCHITECTURE_SPEC.md`

## 1. Architecture Overview

SDKWork Edu is an `application-http-gateway`: one application HTTP ingress serving an
`app-api` surface (`/app/v3/api`) and a `backend-api` surface (`/backend/v3/api`), with the
SDKWork platform gateway providing identity and cross-application SDKs.

```
browser (PC / H5)
   |  HTTPS
   v
webserver (nginx)  --  distribution/{standalone,cloud}/{dev,test,staging,prod}
   |
   v
sdkwork-api-edu-standalone-gateway   (single process, single listen socket)
   |
   +-- sdkwork-api-edu-assembly      route crate composition + hosted router
   |     +-- sdkwork-routes-edu-app-api
   |     +-- sdkwork-routes-edu-backend-api
   |     +-- sdkwork-routes-edu-http-auth   (dual token, error mapping, envelope)
   |
   +-- sdkwork-content-edu-service          domain models + application ports
   +-- sdkwork-content-edu-repository-sqlx  sqlx implementations
   +-- sdkwork-edu-database-host            lifecycle + process-local pool
   +-- sdkwork-edu-embedded-bootstrap       IAM / Drive / audit / notify adapters
```

## 2. Layering

| Layer | Crate | May depend on | Must not depend on |
| --- | --- | --- | --- |
| Binary | `sdkwork-api-edu-standalone-gateway` | assembly, web-bootstrap, iam adapter | sqlx, service internals |
| Assembly | `sdkwork-api-edu-assembly` | routes, web-bootstrap | repository |
| Routes | `sdkwork-routes-edu-{app,backend}-api`, `-http-auth` | service, web-contract, utils | repository, sqlx |
| Service | `sdkwork-content-edu-service` | utils, serde | axum, sqlx, repository |
| Repository | `sdkwork-content-edu-repository-sqlx` | service, database-sqlx | axum, routes |
| Database host | `sdkwork-edu-database-host` | sdkwork-database | routes, service |
| Bootstrap | `sdkwork-edu-embedded-bootstrap` | all of the above, drive uploader | - |

Dependency direction is one-way; `check-application-layering` enforces it.

## 3. Technology Choices

| Concern | Framework | Integration |
| --- | --- | --- |
| HTTP | `sdkwork-web-framework` | `HttpRoute` declarations, `WebRequestContext`, one hosted router |
| Persistence | `sdkwork-database` | `DatabaseConfig::from_env("EDU")`, `LifecycleOrchestrator`, `sdkwork-db` CLI |
| Utilities | `sdkwork-utils` | `serde_int64`, `service_base_url`, `http_api` pagination helpers |
| Identity | `sdkwork-iam` | `build_web_framework_builder`, dual-token context, permission tiers |
| Files | `sdkwork-drive` | uploader service (server bytes) + app SDK (clients) + download grants |
| Discovery | - | Intentionally absent; no RPC surface (ADR-20261102-discovery-deferred) |

## 4. API Contract

- Success: `{ "code": 0, "data": ..., "traceId": "..." }`; list payloads carry
  `data.items` + `data.pageInfo{mode}`.
- Failure: HTTP 4xx/5xx `application/problem+json` with numeric `code`, `traceId`,
  `instance`; no 2xx business failures.
- Identifiers: `int64` on the wire is a string (`x-sdkwork-int64-string`), serialized in
  Rust through `sdkwork_utils_rust::serde_int64`.
- Pagination: `page` / `page_size` (max 200) or `cursor` / `page_size`, pushed to SQL.
- Permissions: `edu.<resource>.<action>`; `backend-api` declares them, `app-api` tier 0-2
  does not.

Authored contracts live in `apis/<surface>/edu/operations.json`; route manifests, OpenAPI
authorities and SDKs are materialized from them (never hand-edited).

## 5. Data

- PostgreSQL only, one process-local pool per normalized database identity.
- Prefix `edu_`, module id `edu`, contract version 1.0.0, `authoritative-server`.
- `database/ddl/baseline/postgres/0001_edu_baseline.sql` is the initialization DDL;
  `migrations/postgres/` holds post-GA deltas only.
- Drive-owned files are referenced by `drive_space_id` + `drive_node_id` + `drive_uri`.

## 6. Deployment

| Profile | Ingress | Platform | Storage |
| --- | --- | --- | --- |
| `standalone` | `127.0.0.1:3910` behind webserver | embedded IAM/Drive adapters | local PostgreSQL |
| `cloud` | container ingress behind platform gateway | managed gateway + IAM | managed PostgreSQL |

Ten profiles are declared in `specs/topology.spec.json` and realized in
`etc/topology/<deploymentProfile>.<environment>.env`. Images are built by
`bin/docker-image.sh` from `deployments/docker/Dockerfile` and are multi-stage, single
binary, non-root.

## 7. Security

- Dual token: `Authorization: Bearer` + `Access-Token`; tenant and organization resolve
  from validated token claims only - never from a client header, query or body.
- Permission tiers: 0 public, 1 authenticated, 2 ownership, 3 role/scope.
- Idempotency (`Idempotency-Key` + `x-sdkwork-idempotent`) on retriable creates;
  `If-Match` for concurrency.
- CORS allow-list and security headers per `CORS_SPEC.md`; secrets only from environment.

## 8. Verification

```bash
pnpm check                      # app composition, CORS, topology, database framework
pnpm verify                     # typecheck + cargo test + check
node ../sdkwork-specs/tools/run-gate-matrix.mjs --workspace ..
```

## 9. Open Questions

- Domain taxonomy for education (ADR-20261102-domain-taxonomy).
- Whether a future RPC surface justifies `sdkwork-discovery` (ADR-20261102-discovery-deferred).