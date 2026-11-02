# plugins/

Runtime/application plugin sources owned by this repository. Agent plugins belong in
`.sdkwork/plugins/`.

Every plugin ships `specs/component.spec.json` and declares its hook points. Plugins
must not bypass the API, database or Drive standards.