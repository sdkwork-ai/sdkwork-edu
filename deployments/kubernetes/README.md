# Kubernetes

Reference manifests for the `cloud` deployment profile. `deployments/deploy.yaml`
declares `overrides.kubernetes.reference: deployments/kubernetes/`; the manifests here
are the materialization target for that override.

Rules:

- No secrets in manifests; secrets come from the cluster secret store.
- Images are pinned by digest; never `latest`.
- Resource limits, probes (`/healthz`), and pod disruption budgets are mandatory.