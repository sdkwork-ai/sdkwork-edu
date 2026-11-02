# apps/

Application: sdkwork-edu
Status: bootstrap
Owner: sdkwork-edu
Specs: APPLICATION_SPEC.md, SDKWORK_WORKSPACE_SPEC.md

## Primary App Surface

The repository root is the primary runnable app surface. The repository root
`agent.app.config.json` governs the primary application manifest.

## Directory Index

| Directory | Surface role | Runnable | Purpose | Entry |
| --- | --- | --- | --- | --- |
| _(none yet)_ | - | - | Client application roots are added in plan phase P5. | - |

Planned roots, in landing order:

| Directory | Surface role | Purpose |
| --- | --- | --- |
| `sdkwork-edu-pc` | pc | Desktop browser console and administration surfaces |
| `sdkwork-edu-h5` | h5 | Mobile browser surfaces (learner, guardian, teacher) |
| `sdkwork-edu-common` | shared | Cross-client packages: runtime, SDK ports, mobile React features |

Every child directory of `apps/` must be listed in the table above with its surface
role, runnable flag, purpose and entry path (DOCUMENTATION_SPEC.md section 3.3).

## Allowed Content

- One directory per application root: `sdkwork-<application-code>-<client-arch>/`.
- Architecture-local `src/`, `lib/`, `entry/`, `packages/`, `config/` live only inside
  an app root.
- Public browser UI ships the `-pc/` + `-h5/` Adaptive Web pair; neither is optional.