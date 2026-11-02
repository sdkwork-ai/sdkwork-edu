# sdks/

SDK families, route manifests, OpenAPI authorities and generated clients.

| Path | Purpose |
| --- | --- |
| `_route-manifests/` | Normalized route manifests per surface (generated from `apis/`) |
| `_shared/` | Handwritten shared contract packages (`@sdkwork/edu-contracts`) |
| `sdkwork-edu-app-sdk/` | App API SDK family (`@sdkwork/edu-app-sdk`) |
| `sdkwork-edu-backend-sdk/` | Backend API SDK family (`@sdkwork/edu-backend-sdk`) |

Rules:

- Everything under `generated/` is owned by `../sdkwork-sdk-generator/bin/sdkgen.js`.
  Never hand-edit generated output; regenerate from the upstream contract.
- The composed facade lives at `<family>/<family>-typescript/src/index.ts` and its
  `package.json#name` is the scoped consumer package (`@sdkwork/edu-app-sdk`).
- Consumers import the composed package only, never transport package names and never
  deep paths into `generated/server-openapi/src/*`.
- `sdk-manifest.json` at the family root is the single source of truth for package
  names, transport names, generation input and discovery surface.