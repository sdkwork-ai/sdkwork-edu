# Locale Bundle: zh-CN

Localized seed content for `zh-CN`. Files are applied only when the active seed locale or
the fallback chain selects this bundle.

Rules:

- One file per domain object; file names mirror `database/seeds/common` ordinals where a
  translation corresponds to a common row.
- No fallback text duplication inside content rows; the loader falls back through
  `fallbackLocale`.
- No personal data and no secrets.