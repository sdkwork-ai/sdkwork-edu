# Operator Guide

## Profiles

`standalone` runs one binary plus the webserver on a host. `cloud` runs the same binary as a
container behind the platform gateway. Environments: `development`, `test`, `staging`,
`demo`, `production`.

## Health

| Endpoint | Meaning |
| --- | --- |
| `/healthz` | Process liveness |
| `/ready` | Database and dependency readiness |

## Database

```bash
pnpm db:plan      # show pending lifecycle work
pnpm db:status    # applied revisions and drift state
pnpm db:drift:check
```

Never run `db:init` against a database that already holds data.

## Image

```bash
bin/docker-image.sh build 0.1.0
bin/docker-deploy.sh deploy standalone production 0.1.0
```