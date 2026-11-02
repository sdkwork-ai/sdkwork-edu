# Database Contract Snapshots

Materialized snapshots of the database contract, derived from
`database/contract/schema.yaml` and `database/ddl/baseline/postgres/`.

Produced by the database contract materializer in plan phase P2:

```bash
node ../sdkwork-specs/tools/materialize-database-contract-from-baseline.mjs --root . \
  --baseline database/ddl/baseline/postgres/0001_edu_baseline.sql \
  --module-id edu --owner edu-platform --prefixes edu_ --engines postgres
```

Never hand-edit the snapshot; change the baseline DDL or `contract/schema.yaml`.