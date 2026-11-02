# Runbook: Troubleshooting

| Symptom | First checks |
| --- | --- |
| `/ready` returns 503 | Database reachability, `SDKWORK_DATABASE_*`, lifecycle state |
| 401 on every call | Token pair present (`Authorization` and `Access-Token`), clock skew |
| 403 on an admin call | Permission code missing for the role, `loginScope` and `organizationId` |
| Empty list but rows exist | Tenant/organization scope of the token, then filters |
| Upload fails | Drive reachability, `appResourceType` present in `upload.declaration.json` |
| Duplicate records | Idempotency key reuse with a different fingerprint (409) |

Always capture the `traceId` from the response or the `X-SdkWork-Trace-Id` header first.