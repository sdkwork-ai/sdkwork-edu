# SDKWork Edu Documentation

Documentation Canon for the SDKWork Edu application root. Prose lives here;
machine-readable contracts live in `../specs/`.

## Canon

| Document | Purpose |
| --- | --- |
| [Product PRD](product/prd/PRD.md) | What SDKWork Edu is, for whom, and what it must do |
| [Technical Architecture](architecture/tech/TECH_ARCHITECTURE.md) | How it is built, deployed and verified |
| [Architecture Decisions](architecture/decisions/README.md) | Immutable decision records |
| [Engineering](engineering/README.md) | Plans and reviews |
| [Guides](guides/README.md) | Developer, integrator and operator guides |
| [Runbooks](runbooks/README.md) | Deploy, backup/restore, troubleshooting, logs |
| [Domains](domains/README.md) | Domain ownership and boundaries |

## Index

- `product/` - PRD, requirements, roadmap.
- `architecture/` - technical architecture, ADRs, views.
- `domains/` - domain boundary notes.
- `engineering/` - plans (`PLAN-YYYY-MM-DD-*.md`) and reviews (`REVIEW-YYYYMMDD-*.md`).
- `guides/` - audience-specific onboarding.
- `runbooks/` - operational procedures (bilingual where noted).
- `changelogs/`, `migrations/`, `releases/`, `archive/` - change history and retired material.

## Rules

- The three Canon entrypoints above MUST stay reachable from this index.
- Requirement records use `REQ-YYYY-MM-DD-*.md`, plans `PLAN-YYYY-MM-DD-*.md`,
  reviews `REVIEW-YYYYMMDD-*.md`, decisions `ADR-YYYYMMDD-*.md`.
- Decisions are append-only: supersede, never rewrite.
- Do not duplicate standard text from `../sdkwork-specs`; link to it instead.