# jobs/

Scheduled and queued work declarations. Rust workers stay in `crates/`.

| Directory | Purpose |
| --- | --- |
| `schedules/` | Cron-like schedules and their owning worker |
| `queues/` | Queue definitions, retry and dead-letter policy |
| `batches/` | Batch jobs and their idempotency keys |
| `runbooks/` | What to do when a job fails |
| `packages/` | Job payload schemas |