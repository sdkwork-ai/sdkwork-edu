# Migrations (postgres)

`baseline-plus-migrations` strategy: `ddl/baseline/postgres/0001_edu_baseline.sql`
holds the full initialization DDL, and this directory holds post-GA deltas only.

Rules:

- One logical change per migration; file name `<ordinal>_<description>.up.sql`.
- Never edit an applied migration; add a new one.
- Every migration is reversible in plan, forward-only in execution.