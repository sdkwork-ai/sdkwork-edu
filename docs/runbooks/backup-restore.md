# Runbook: Backup And Restore

Backup:

1. `bin/backup.sh backup <environment>`.
2. Verify the archive checksum and that it contains the schema plus data.
3. Store it outside the host; record the version it was taken at.

Restore (requires explicit human approval, it discards current data):

1. Stop the service to stop writes.
2. Verify the backup matches the intended version.
3. `bin/backup.sh restore <archive>`.
4. Run `pnpm db:drift:check`, then start the service and verify `/ready`.

Deletion and restore are governed by `DESTRUCTIVE_OPERATION_SPEC.md` and
`ROLLBACK_RESTRICTION_SPEC.md`.