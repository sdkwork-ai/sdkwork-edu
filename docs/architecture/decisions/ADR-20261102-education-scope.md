# ADR-20261102: Scope Is Education Administration

- Status: Accepted
- Date: 2026-11-02
- Related: `../product/prd/PRD.md`, sibling repository `sdkwork-course`

## Context

`sdkwork-course` already owns course catalogs, lessons, learning progress and content
authoring. A second repository that also publishes courses would duplicate its contract,
its tables and its SDK surface.

## Decision

SDKWork Edu owns **education administration**: terms, classes, rosters, enrollment,
scheduling, attendance, assessments, scores, assignments and teaching materials. It does
not own course content authoring, lesson playback or learning progress.

## Consequences

- No overlap with `sdkwork-course` tables or API resources.
- Teaching materials are attachments (`edu_material` -> Drive), not a content library.
- Cross-application links go through Drive node references or platform IDs, never a shared
  table.

## Alternatives Considered

- **Online learning platform.** Rejected: duplicates `sdkwork-course`.
- **Both.** Rejected: two bounded contexts in one repository without a phase boundary.