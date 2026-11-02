# etc/

Checked-in, non-secret runtime profiles and deployment configuration.

| Path | Purpose |
| --- | --- |
| `topology/` | Ten topology profiles (`<deploymentProfile>.<environment>.env`) |
| `sdkwork.deployment.config.json` | Component deployment manifest for the repository root |
| `client-env.materialization.json` | Browser runtime-env materialization matrix |
| `examples/` | Annotated configuration examples |

Rules:

- No credentials, tokens, or machine-specific paths.
- Profile ids must match `specs/topology.spec.json` `profileFiles`.
- Local overrides use `*.local.*` and are gitignored.
<!-- SDKWORK-DEPLOY-LAYOUT: v1 -->
## Installed Runtime Paths

Authority: `APPLICATION_DEPLOY_LAYOUT_SPEC.md` (`../sdkwork-specs/`).

| Item | Value |
| --- | --- |
| `appId` | `sdkwork-edu` |
| `runtimeCode` | `edu` |
| Config root | `/etc/sdkwork/edu/` |
| Runtime TOML | `/etc/sdkwork/edu/config.toml` |
| Secrets | `/etc/sdkwork/edu/secrets/` |
| Override | `SDKWORK_EDU_CONFIG_FILE` |

Source profiles live under `etc/` (`sdkwork.deployment.config.json` index). Deploy manifest: `deployments/deploy.yaml`. Web data-plane source: `deployments/webserver/` (`SDKWORK_WEBSERVER_SPEC.md` layout v3).

```bash
node ../sdkwork-specs/tools/check-source-config-standard.mjs --root .
node ../sdkwork-specs/tools/check-application-deploy-layout.mjs --root .
node ../sdkwork-specs/tools/check-webserver-toml-standard.mjs --root deployments/webserver
```
<!-- /SDKWORK-DEPLOY-LAYOUT -->