# Review: Repository Bootstrap (P0 + P1)

- Date: 2026-11-02
- Reviewer: agent session
- Plan: [PLAN-2026-1102-edu-bootstrap](../plans/PLAN-2026-1102-edu-bootstrap.md)
- Scope: repository baseline initialization only (plan phases P0 and P1, plus the
  data/contract artefacts that are pure files).

## What Was Built

| Area | Artefacts |
| --- | --- |
| Root dictionary | `AGENTS.md`, `CLAUDE.md`, `CODEX.md`, `GEMINI.md`, `README.md`, `LICENSE`, `.gitignore`, `.npmrc` |
| Workspace | `package.json` (34 scripts, 8 lifecycle verbs + `_sdkwork:*` hooks), `pnpm-workspace.yaml`, `tsconfig{,.base}.json`, `Cargo.toml`, `Cargo.lock` |
| Crates | 9 members: assembly, standalone gateway, embedded bootstrap, database host, service, repository-sqlx, three route crates |
| Platform metadata | `agent.app.config.json` (v3), `agent.workflow.json`, 10 `etc/topology/*.env` profiles, `etc/sdkwork.deployment.config.json`, `etc/client-env.materialization.json`, `config/host/postgres.env.example` |
| Machine contracts | `specs/topology.spec.json` (v5), `component.spec.json`, `iam.module.manifest.json` (36 permissions), `upload.declaration.json` (5 targets), `process-database-pool.spec.json`, `edu-capabilities.yaml` |
| Database | `database.manifest.json` (v2), `contract/{schema.yaml,prefix-registry.json,table-registry.json}`, `ddl/baseline/postgres/0001_edu_baseline.sql` (14 `edu_*` tables), `seeds/` with 7 locale sets, `drift/policy.yaml` |
| API contracts | `apis/app-api/edu/operations.json` (19 ops), `apis/backend-api/edu/operations.json` (58 ops) |
| Delivery | `bin/` nine entrypoints (scaffolded by `sdkwork-specs/tools/scaffold-module-bin.mjs`), `deployments/deploy.yaml`, `deployments/docker/Dockerfile`, `deployments/webserver/*`, `.github/workflows/{verify,package}.yml` |
| Docs Canon | 37 files: index, PRD, TECH_ARCHITECTURE, 6 ADRs, guides, runbooks, changelogs, plan |

## Verification Evidence

Run from the repository root on 2026-11-02.

| Command | Result |
| --- | --- |
| `check-workspace-layout.mjs --workspace ..` | pass |
| `check-pnpm-script-standard.mjs --root .` | pass (34 root scripts) |
| `check-module-bin.mjs --root .` | pass |
| `check-script-placement.mjs --root .` | pass (11 scripts) |
| `check-gitignore-standard.mjs --root .` | pass |
| `check-identity-naming.mjs --root .` | pass |
| `check-application-layering.mjs --root .` | pass |
| `check-rust-crate-naming-standard.mjs --root .` | pass (9 crates, 0 errors, 0 warnings) |
| `check-rust-manifest-standard.mjs --root .` | pass |
| `check-rust-backend-composition.mjs --root .` | pass |
| `check-rust-http-header-standard.mjs --root .` | pass |
| `check-database-framework-standard.mjs --root .` | pass |
| `check-unified-postgres-profile.mjs --root .` | pass |
| `check-topology-deployment-profiles.mjs --root .` | pass |
| `sdkwork-topology.mjs validate --root . --spec specs/topology.spec.json` | valid |
| `check-deploy-standard.mjs --root .` | pass |
| `check-webserver-toml-standard.mjs --root .` | pass |
| `check-env-file-naming.mjs --root .` | pass |
| `check-application-deploy-layout.mjs --root .` | pass |
| `check-source-config-standard.mjs --root .` | pass |
| `check-app-manifest-standard.mjs --root .` | pass |
| `check-app-manifest-deployment-standard.mjs --root .` | pass |
| `check-apps-directory-index.mjs --root .` | pass |
| `check-app-assets-standard.mjs --root .` | pass |
| `check-app-permission-tiers.mjs --workspace .` | pass |
| `check-i18n-standard.mjs --root .` | pass |
| `check-repository-docs-standard.mjs --root .` | pass (profile=application) |
| `check-workspace-member-protocol.mjs --root .` | pass |
| `check-dependency-list-completeness.mjs --root .` | pass |
| `check-workspace-path-portability.mjs --root .` | pass (177 files) |
| `check-repository-baseline-content.mjs --root .` | pass |
| `check-component-port-bindings.mjs --root .` | pass |
| `check-permission-composition.mjs --root .` | pass |
| `check-destructive-operation-patterns.mjs --root .` | pass |
| `check-agent-workflow-standard.mjs --root .` | pass |
| `check-web-module-adoption.mjs --workspace .` | pass |
| `check-api-operation-patterns.mjs --workspace .` | pass |
| `check-api-response-envelope.mjs --workspace .` | pass |
| `check-pagination.mjs --workspace .` | pass |
| `check-route-path-collisions.mjs --root .` | pass |
| `check-sdk-standard.mjs --workspace .` | pass |
| `check-sdkwork-subpath-exports.mjs --root .` | pass |
| `check-base-url-resolution.mjs --workspace .` | pass |
| `check-single-http-ingress.mjs --root .` | pass |
| `check-iam-application-bootstrap-standard.mjs --root .` | pass |
| `check-cors-standard.mjs --root .` | pass |
| `check-theme-conformance.mjs --root .` | pass |
| `check-application-cloud-gateway-boundary.mjs --root .` | pass |
| `verify-repo.mjs --root .` | pass |
| `node --test tests/contract/edu-upload-declaration.contract.test.mjs` | 6/6 pass |

Summary: 47 repo-scoped gates pass, plus the repository-local upload contract test.

## Open Items (Deliberately Not Done In This Phase)

1. **`check-process-shared-database-pool`** requires the gateway entrypoint to call
   `enable_process_shared_database_pool` and the pool owner to carry the approved wiring.
   The `specs/process-database-pool.spec.json` declaration is in place and truthful, but the
   Rust wiring lands in phase P3. This gate is expected red until then.
2. **`cargo build` / `cargo test` / `cargo clippy` / `cargo fmt`** cannot run in this
   environment: only the `cargo` shim is installed, `rustc` is absent (`cargo metadata`
   fails with `could not execute process 'rustc -vV'`). `Cargo.lock` was generated
   (351 entries) so resolution is verified; compilation must be validated in CI or on a
   toolchain host.
3. **`check-shell-portability`** fails for the same reason it fails on `sdkwork-course`:
   the checker shells out to `bash -n <windows-absolute-path>` and the path is mangled
   (`D:sdkwork-spacesdkwork-edubin...`). This is an environment limitation, not a defect
   in `bin/`; it must run on Linux.
4. **Fleet-scoped checks** (`check-subject-id-alignment`, `check-database-bootstrap-references`,
   `check-upload-declaration-standard --workspace ..`) report violations owned by sibling
   repositories (`sdkwork-account`, `sdkwork-deployments`, `sdkwork-webserver`,
   `sdkwork-mall`). None cite `sdkwork-edu`; the repository-local upload contract test
   covers this repository instead.
5. **Client app roots** (`apps/sdkwork-edu-pc`, `apps/sdkwork-edu-h5`) do not exist yet, so
   the topology declares server-only orchestration and `deployments/deploy.yaml` exposes
   `mode: api`. Phase P5 restores the adaptive web pair, `web+api` exposure and the
   `browserDeliveries` block.

## Deviations From The Reference Implementation

`../sdkwork-course` was used as the structural reference, with its known defects not copied:

- no duplicated workspace member in `Cargo.toml`;
- `bin/` ships the full nine-entrypoint family (course ships only `lib/`);
- `deployments/kubernetes/` exists (course references a missing directory);
- the cloud webserver upstream no longer points at `sdkwork-api-cloud-gateway`;
- `appResourceType` values are dotted (`edu.material`), not underscore literals;
- one license (`AGPL-3.0-or-later`) across every manifest.

## Decision Records

`ADR-20261102-domain-taxonomy`, `-education-scope`, `-discovery-deferred`,
`-ports-and-hosts`, `-license`, `-workspace-registration`.