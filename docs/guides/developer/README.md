# Developer Guide

## First run

```bash
pnpm install
cargo build --workspace
pnpm db:validate
pnpm check
```

## Layout rules

- Backend layers: `routes -> service -> repository -> database host`. Never skip a layer.
- One HTTP ingress. New routes are declared through `HttpRoute`, not `Router::route`.
- Platform behaviour (identity, storage, utilities) is consumed, never re-implemented.
- Generated SDK output is never edited; change `apis/` and regenerate.

## Adding an endpoint

1. Add the operation to `apis/<surface>/edu/operations.json`.
2. Add the `HttpRoute` declaration in the matching route crate.
3. Implement the service method and repository query (SQL-side pagination).
4. Regenerate route manifests, OpenAPI and SDKs.
5. Run `pnpm check` and the contract tests.