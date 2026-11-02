# Runbook: Log Reference

| Field | Meaning |
| --- | --- |
| `traceId` | Server-owned correlation id; matches the response body |
| `operationId` | Dotted `resource.action` of the handled route |
| `apiSurface` | `app-api` or `backend-api` |
| `tenantId`, `organizationId` | Resolved from the token, never from the request |
| `durationMs` | Handler duration |

Levels: `error` for failed invariants and unmapped errors, `warn` for retries and
degradation, `info` for request completion, `debug` for development only. Never log tokens,
secrets, full request bodies, or personal data.