# API Contracts

Authored, hand-maintained API operation contracts. This directory is the source of
truth for route manifests, OpenAPI authorities and generated SDKs.

| Path | Surface | API authority |
| --- | --- | --- |
| `app-api/edu/operations.json` | `/app/v3/api` | `sdkwork-edu-app-api` |
| `backend-api/edu/operations.json` | `/backend/v3/api` | `sdkwork-edu-backend-api` |

Rules:

- One surface per directory; the leaf directory is the capability (`edu`).
- `operationId` is dotted `resource.action` and must be unique per surface.
- Paths use the locked surface prefix, plural `lower_snake_case` collection nouns,
  and `lowerCamelCase` path parameters.
- List operations use `page` / `page_size` (max 200) or `cursor` / `page_size`;
  never `pageSize`, `limit`, `per_page`.
- `backend-api` operations declare `permission` (`edu.<resource>.<action>`) and
  `authTier`; `app-api` tier 0-2 operations must not declare a permission.
- Never edit generated SDK output; change the contract here and regenerate.

Pipeline: `operations.json` -> route manifest (`sdks/_route-manifests/`) ->
OpenAPI authority (`sdks/<family>/openapi/`) -> `sdkgen` -> generated clients.