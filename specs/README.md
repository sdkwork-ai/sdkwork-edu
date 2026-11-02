# specs/

Machine-readable contracts for this application root. Prose belongs in `docs/`.

| File | Purpose |
| --- | --- |
| `topology.spec.json` | Runtime topology (schemaVersion 5, archetype `application-http-gateway`) |
| `component.spec.json` | Root workspace component contract and verification commands |
| `iam.module.manifest.json` | Permission catalog, module identity and owned API authorities |
| `upload.declaration.json` | Drive upload declarations (DRIVE_SPEC section 18) |
| `edu-capabilities.yaml` | Capability map: aggregates, tables, permissions, upload targets |
| `openapi/` | Materialized operation schema contracts (generated) |
| `database/` | Materialized database contract snapshots (generated) |

Rules:

- `topology.spec.json` is the only authority for profiles, surfaces and env keys.
- `upload.declaration.json` is the only source of `appResourceType` / `scene` /
  `source` / `uploadProfileCode` literals; call sites must reuse them.
- Generated snapshots are produced by `sdkwork-specs` materializers; never hand-edit.