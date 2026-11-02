# Common Seeds

Engine-agnostic, locale-independent reference data applied by every seed profile that
lists a file from this directory.

Rules:

- Idempotent: `INSERT ... ON CONFLICT DO NOTHING`, never an unconditional insert.
- No personal data and no secrets.
- File names are zero-padded ordinals: `001_<description>.sql`.
- A file must be listed in `seed.manifest.json` to be applied.