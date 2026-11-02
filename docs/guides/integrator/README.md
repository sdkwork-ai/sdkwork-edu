# Integrator Guide

## Consuming SDKs

```ts
import { createClient } from "@sdkwork/edu-app-sdk";
const client = createClient({ baseUrl, accessToken, authToken });
```

Rules:

- Import the composed package (`@sdkwork/edu-app-sdk`, `@sdkwork/edu-backend-sdk`), never a
  transport package and never a deep path into `generated/server-openapi/src/*`.
- Identifiers are strings on the wire; do not convert them to `number`.
- List endpoints take `page` / `page_size` (max 200) or `cursor` / `page_size`.
- Errors are `ProblemDetail` with a numeric `code` and a `traceId`; surface the `traceId` in
  support flows.

## Uploading

Use the Drive app SDK. The application only stores the returned node reference:

```ts
import { EDU_UPLOAD_TARGETS } from "@sdkwork/edu-contracts";
await drive.uploader.upload({ file, ...EDU_UPLOAD_TARGETS.material, appResourceId });
```

Every `appResourceType` / `scene` / `source` / `uploadProfileCode` literal must exist in
`specs/upload.declaration.json`.