# ADR-20261102: Domain Taxonomy Placement

- Status: Accepted
- Date: 2026-11-02
- Related: `DOMAIN_SPEC.md`, `IAM_MODULE_MANIFEST_SPEC.md`

## Context

`DOMAIN_SPEC.md` defines eleven platform domains: `iam`, `platform`, `system`, `drive`,
`content`, `communication`, `intelligence`, `commerce`, `integration`, `device`,
`ecosystem`. Education is not one of them.

Two different axes are in play:

1. `agent.app.config.json` `app.domain` names the platform domain the application extends.
2. IAM module manifests use `domain` as the permission-code prefix, which must match every
   permission the module owns.

## Decision

- `agent.app.config.json`: `app.domain = "content"`, `app.capability = "edu"`.
  Education administration is a product-specific extension of the `content` domain, which
  `DOMAIN_SPEC.md` explicitly permits ("Product-specific behavior MAY extend a standard
  domain through an extension package").
- `specs/iam.module.manifest.json`: `moduleId = "edu"`, `domain = "edu"`, so permission
  codes are `edu.<resource>.<action>` and the module owns only its own namespace.

## Consequences

- No upstream spec change is required to ship 0.1.0.
- Permissions read `edu.classes.read`, not `content.classes.read`; the module manifest and
  the route permission annotations stay consistent by construction.
- If the platform later introduces an `education` domain, this ADR is superseded and the
  permission prefix migrates in a dedicated, reviewed change.

## Alternatives Considered

- **Add an `education` domain to `DOMAIN_SPEC.md`.** Semantically cleaner, but it mutates a
  cross-repository governance spec and its gates, and blocks this repository on an upstream
  change. Deferred, not rejected.
- **Use `content.classes.read`.** Violates the three-segment permission format
  (`{domain}.{resource}.{action}`) unless the resource itself contains a dot.