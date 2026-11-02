# .sdkwork

Source-controlled SDKWork workspace metadata for this application root.

Allowed content:

- `skills/` - local agent skills owned by this repository.
- `plugins/` - local agent plugin manifests owned by this repository.
- Repository-scoped AI workspace metadata that must be reviewed like code.

Never store credentials, tokens, local caches, or generated artifacts here. Those paths
are gitignored: `local/`, `secrets/`, `cache/`, `tmp/`, `manual-backups/`.