# Migrations

Notes for changes that require operator action beyond applying a release: data backfills,
permission remaps, table renames, credential rotations.

Each note states: what changed, why, the affected versions, the procedure, and the
verification. Schema DDL itself lives in `database/migrations/postgres/`.