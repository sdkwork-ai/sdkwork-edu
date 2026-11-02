# OpenAPI Operation Schemas

Materialized operation-schema contracts derived from `apis/<surface>/edu/operations.json`
and the route crates.

Produced by the API materializer in plan phase P4:

```bash
pnpm api:assembly:materialize
pnpm api:assembly:validate
pnpm check:api-envelope
```

Never hand-edit the materialized files; change the authored contract in `apis/` or the
route crate manifest and re-run the materializer.