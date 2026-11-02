# Fixtures

Deterministic, non-secret datasets used by contract and integration tests.

Rules:

- No production data, no personal data, no credentials.
- Fixtures are loaded into an initialized database; they never replace `seeds/`.
- Keep them small enough to run inside a single test transaction.