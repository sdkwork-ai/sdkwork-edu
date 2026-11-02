# Runbook: Deploy

1. Confirm the release exists and its artifacts carry checksums.
2. Verify the target profile: `standalone` or `cloud`, and the environment.
3. Build the image (never reuse a tag): `bin/docker-image.sh build <version>`.
4. Apply database lifecycle: `pnpm db:plan` then `pnpm db:migrate`.
5. Deploy: `bin/docker-deploy.sh deploy <profile> <environment> <version>`.
6. Verify: `/healthz` and `/ready` return 200; the gateway serves `/app/v3/api` and
   `/backend/v3/api`.
7. Record the deployed version, image digest and the trace id of the smoke request.

Rollback is forward-fix by policy: deploy the previous version, do not rewrite history.