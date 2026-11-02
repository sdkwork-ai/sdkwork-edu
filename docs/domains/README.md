# Domains

SDKWork Edu extends the platform domain `content` under capability `edu`
(see [ADR-20261102-domain-taxonomy](../architecture/decisions/ADR-20261102-domain-taxonomy.md)).

## Ownership

| Concern | Owner | Boundary |
| --- | --- | --- |
| Academic terms, classes, enrollment | `sdkwork-edu` | `edu_*` tables, `edu.*` permissions |
| Student and teacher profiles | `sdkwork-edu` | Tenant-scoped; identity stays in IAM |
| Attendance and leave | `sdkwork-edu` | Session-scoped records |
| Assessment, scores, assignments | `sdkwork-edu` | Publication state owned here |
| Identity, tenant, organization | `sdkwork-iam` | Consumed through the web adapter |
| File bytes, upload sessions, grants | `sdkwork-drive` | Referenced by node id only |
| Course content, lessons, progress | `sdkwork-course` | Separate application |

## Rules

- One owner per table, one owner per permission prefix.
- Cross-domain references use platform ids or Drive node references, never a foreign table.
- A new capability requires an ADR and a `specs/edu-capabilities.yaml` entry.