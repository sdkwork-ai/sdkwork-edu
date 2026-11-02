# sdkwork-edu 标准对齐审计与完整执行计划

- 审计对象：`<repo-root>`
- 基准规范：`../sdkwork-specs`（v4 应用运行时拓扑、API v3、SDK v3、DB 框架 v2）
- 同域参考实现：`../sdkwork-course`（`domain: content`，最接近的合规姊妹仓）
- 结构基准（`bin/`、部署）：`sdkwork-drive` / `sdkwork-cms` / `sdkwork-community` / `sdkwork-mall` / `sdkwork-aiot`
- 审计时间：2026-11-02
- 结论级别：**绿地（greenfield）** —— 当前仓库为空目录，6 项"是否接入"全部为"尚未建立"，不属于"偏离规范"，属于"尚未开工"。

---

## 0. 审计结论（先给结论）

### 0.1 现状事实

| 检查项 | 证据 | 判定 |
|---|---|---|
| 目录内容 | `Get-ChildItem -Force` → 0 项 | 空目录 |
| Git 归属 | 不在 `sdkwork-space/.gitmodules`；`git ls-files sdkwork-edu` 无输出；无 `.git` | 未纳入工作区版本控制 |
| 工作区引用 | `sdkwork-specs/**`、`sdkwork-space/*.json` 中检索 `sdkwork-edu` → 0 命中 | 无任何契约、拓扑、CI 引用 |
| 同名/近名仓 | 仅有 `sdkwork-course`（在线课程内容平台） | 无重复实现可复用 |

### 0.2 逐项回答用户提出的 6 个问题

| # | 要求 | 现状 | 目标 | 依据规范 |
|---|---|---|---|---|
| 1 | 对齐 sdkwork-specs | ❌ 未建立：无 `AGENTS.md`/根字典、无 `specs/`、无目录骨架、无门禁 | ✅ 22 项 workspace 门禁 + 应用级 check 全绿 | `REPOSITORY_BASELINE_SPEC.md`、`gates.manifest.json`、`QUALITY_GATE_SPEC.md` |
| 2 | 接入 sdkwork-web-framework | ❌ 未接入（无 `Cargo.toml`） | ✅ 依赖 `sdkwork-web-core/-axum/-contract/-bootstrap` 并实现单 HTTP 入口 | `WEB_FRAMEWORK_SPEC.md`、`APPLICATION_LAYERED_ARCHITECTURE_SPEC.md` |
| 3 | 接入 sdkwork-database | ❌ 未接入（无 `database/`、无 manifest、无 CLI 脚本） | ✅ `schemaVersion:2` 模块清单 + contract/DDL/migrations/seeds/drift + `sdkwork-database-cli` 全流程 | `DATABASE_FRAMEWORK_SPEC.md`、`DATABASE_SPEC.md` |
| 4 | 接入 sdkwork-utils | ❌ 未接入（Rust/TS 均无依赖） | ✅ Rust `sdkwork-utils-rust`（含 `serde_int64`）+ TS `@sdkwork/utils` 子路径；删除自造工具函数 | `MODULE_SPEC.md`、`CODE_STYLE_SPEC.md` |
| 5 | 接入 sdkwork-discovery | ✅ **不接入**（当前无 RPC 服务，无需接入，与规范一致） | ⏸ 保持不接入，写入"未来触发条件" | `DISCOVERY_SPEC.md`、`RPC_FRAMEWORK_SPEC.md` |
| 6 | 文件上传经 sdkwork-drive | ❌ 未接入，若直接实现上传即违规 | ✅ 声明 `specs/upload.declaration.json`；前端 `@sdkwork/drive-app-sdk/uploader`；Rust `sdkwork-drive-app-sdk-generated-rust` | `DRIVE_SPEC.md` §8/§9/§18、`MEDIA_RESOURCE_SPEC.md` |

> 第 6 项是本计划中唯一的**强约束性架构红线**：上传是平台能力而非应用功能，应用只声明身份与场景（`appResourceType`/`scene`/`uploadProfileCode`/`retention`），调用点必须复用声明值，不得出现本地硬编码或自建存储。

### 0.3 完成定义（DoD）

一个"对齐完成"的 `sdkwork-edu` 必须同时满足：

1. `node ../sdkwork-specs/tools/run-gate-matrix.mjs --workspace ..` 22 项门禁全部通过（含 `sdkwork-edu` 项）。
2. `node ../sdkwork-specs/tools/verify-repo.mjs --root .` 无违规（文档 Canon、`apps` 索引、组合、组件规格）。
3. `pnpm check` / `pnpm verify` / `cargo test --workspace` / `cargo clippy -- -D warnings` / `cargo fmt --all --check` 全绿。
4. `pnpm db:validate`、`pnpm api:assembly:validate`、`pnpm check:openapi-drift`、`pnpm check:api-envelope`、`pnpm topology:validate` 全绿。
5. `sdkwork-discovery` 仍未接入，且仓库内不存在任何 RPC/注册中心残留。

---

## 1. 基座事实（已核实，计划直接引用）

| 事实 | 值 / 位置 |
|---|---|
| 门禁清单 | `sdkwork-specs/gates.manifest.json`，22 项，字段 `{id, tool, scope, argv, tier, baseline}` |
| 门禁执行器 | `sdkwork-specs/tools/run-gate-matrix.mjs`，度量口径 `measure-gate-items.mjs` |
| 必填根脚本 | `dev`、`dev:standalone`、`dev:cloud`、`build`、`test`、`check`、`verify`、`clean`，暴露 `dev` 必须同时暴露 `stop` |
| 私有生命周期钩子 | `_sdkwork:{build,test,check,verify,clean}`，与 `pnpm exec sdkwork-app <verb>` 成对出现 |
| 禁用脚本名 | 任何 `<application-code>:<verb>`（如 `edu:dev`） |
| `bin/` 九入口 | `docker-image.sh`、`docker-deploy.sh`、`apps-build.sh`、`apps-package.sh`、`apps-deploy.sh`、`apps-pkg-installer.sh`、`config.sh`、`doctor.sh`、`backup.sh`（+ `bin/lib/{module.sh,bootstrap.sh}`、`README.md`） |
| 文档 Canon | `docs/README.md`、`docs/product/prd/PRD.md`、`docs/architecture/tech/TECH_ARCHITECTURE.md`（+ 各自 `README.md`）；ADR 在 `docs/architecture/decisions/`（禁 `docs/adr/`） |
| 文档 ID | `REQ-YYYY-MM-DD-*.md`、`ADR-YYYYMMDD-*.md`、`PLAN-YYYY-MM-DD-*.md`、`REVIEW-YYYYMMDD-*.md`；PRD/TECH 分片 `PRD-*.md` / `TECH-*.md` |
| 应用清单 | `agent.app.config.json`，`schemaVersion: 3`，`kind: "agent.app"` |
| 拓扑清单 | `specs/topology.spec.json`，`schemaVersion: 5`，`kind: "sdkwork.app.topology"`；`profileRoot: etc/topology`，`profilePattern: {deploymentProfile}.{environment}.env` |
| 拓扑原型 | `application-http-gateway`（`sdkwork-drive`、`sdkwork-course` 同型） |
| 部署档 | `standalone` / `cloud` × `development,test,staging,production,demo` = 10 个 profile |
| DB 清单 | `database/database.manifest.json`，`schemaVersion: 2`，`kind: "sdkwork.database.module"` |
| 响应信封 | `{code: 0, data, traceId}`（`additionalProperties:false`） |
| 错误体 | `application/problem+json` + `ProblemDetail{type,title,status,code,traceId,instance,...}` |
| int64 | 线上一律 string：`type:string, format:int64, pattern:"^-?[0-9]+$", x-sdkwork-int64-string:true` |
| 路由前缀 | app `/app/v3/api`，backend `/backend/v3/api`，internal `/internal/v3/api`，open 为域名前缀 |
| 分页 | `page`/`page_size`（默认 20，上限 **200**）/`cursor`；`data.items + data.pageInfo{mode}` |
| 上传声明 | `specs/upload.declaration.json`，`schemaVersion:1`，`{schemaVersion, appId, declarations[]}` |
| 上传条目 | 仅允许 `appResourceType, appResourceIdKind, scene, source, uploadProfileCode, retention, retentionTtlSeconds, purpose`；`appResourceIdKind ∈ {application,entity,draft}`；`retention ∈ {long_term,temporary}` |
| `appResourceType` 形态 | `^[a-z][a-z0-9]*(?:\.[a-z][a-z0-9_]*)+$`（≥2 段，如 `edu.material`） |
| 标准上传档 | `generic, video, image, audio, document, archive, text, dataset, attachment, avatar, thumbnail` |
| 保留 scene | `im` 为 Drive 专用，应用禁用 |
| DB CLI | 二进制 `sdkwork-db`（crate `sdkwork-database-cli`），子命令 `validate|init|plan|migrate|seed|bootstrap|status|drift|drift-check` |
| 框架版本 | `sdkwork-web-framework`/`sdkwork-database`/`sdkwork-drive` 均 `0.1.0`，`sdkwork-utils-rust` `0.11.0`，`@sdkwork/utils` `0.11.1`，`@sdkwork/drive-app-sdk` `0.1.4`；**全部以 `path` 依赖兄弟仓，未发布 registry** |
| 上传声明生态现状 | 工作区内 **0 个**仓库存在 `specs/upload.declaration.json`；既有 `appResourceType` 多为下划线写法，不符合点分正则 |

---

## 2. 目标架构

### 2.1 应用身份（`agent.app.config.json` → schemaVersion 3）

```jsonc
{
  "schemaVersion": 3,
  "kind": "agent.app",
  "app": {
    "name": "sdkwork-edu",
    "displayName": "SDKWork Edu",
    "version": "0.1.0",
    "description": "Education administration and teaching operation platform",
    "owner": "sdkwork-edu",
    "domain": "content",          // 见 D1 裁决
    "capability": "edu",
    "key": "sdkwork-edu",        // 不可变
    "appType": "APP_HTML",
    "officialWebsiteUrl": "https://sdkwork.com/apps/sdkwork-edu"
  },
  "backend": {
    "profileKey": "backend-root-admin",
    "appId": "sdkwork-edu",
    "accessTokenPermissionScope": ["iam.users.read","iam.organizations.read","iam.roles.read","iam.permissions.read"],
    "tenantId": "100001",
    "organizationId": "0"
  },
  "runtime": {
    "apiBaseUrl": "http://localhost:3910",
    "appApiPrefix": "/app/v3/api",
    "backendApiPrefix": "/backend/v3/api",
    "supportedDeploymentProfiles": ["standalone","cloud"],
    "defaultDeploymentProfile": "cloud",
    "family": "server",
    "framework": "rust-axum"
  }
}
```

> 端口裁决：工作区已被占用的应用入口包括 `3900`（多家共用 gateway）、`8080`、`3901`、`10240`、`4080`、`18090-18093`、`4100`、`18079`、`8095`、`8460`、`3800`、`18797`。`sdkwork-edu` 取 **`3910`**（standalone 开发入口），内部端口沿用 course 的 `5249/5250` 之外的空位（建议 `5251/5252`）。

### 2.2 领域能力蓝图（D2 待产品确认，下为可落地基线）

`application-http-gateway` 单入口，两类面：**app-api**（学员/家长/教师自助）与 **backend-api**（教务管理台）。

| capability | 聚合 | 核心表（`edu_` 前缀） | 上传资源 |
|---|---|---|---|
| `term` | 学年学期 | `edu_term` | — |
| `class` | 教学班、班成员 | `edu_class`、`edu_class_member` | 班级封面 `edu.cover` |
| `student` | 学员档案、监护人 | `edu_student`、`edu_guardian` | 头像 `edu.avatar` |
| `teacher` | 教师档案、任课 | `edu_teacher`、`edu_teacher_subject` | 头像 `edu.avatar` |
| `enrollment` | 报名、分班、退费申请 | `edu_enrollment` | 报名材料 `edu.material` |
| `schedule` | 课程计划、排课、课表 | `edu_schedule`、`edu_schedule_slot` | 课件 `edu.material` |
| `attendance` | 考勤签到、请假 | `edu_attendance`、`edu_leave_request` | 请假凭证 `edu.evidence` |
| `assessment` | 考试、成绩、成绩单 | `edu_assessment`、`edu_score` | 试卷/成绩单 `edu.material` |
| `assignment` | 作业布置与提交 | `edu_assignment`、`edu_submission` | 作业附件 `edu.submission` |
| `material` | 教学资料（仅存 Drive 引用） | `edu_material`（存 `drive_node_id`） | 资料 `edu.material` |

**不实现**：身份/租户/组织（走 IAM）、文件存储（走 Drive）、支付（走 commerce/payment）、通知（走 communication）。

### 2.3 后端分层与 crate 清单（9 个 crate，与 course 同构）

| crate 目录 | cargo package | 层 | 职责 | 关键依赖 |
|---|---|---|---|---|
| `crates/sdkwork-content-edu-service` | `sdkwork-content-edu-service` | service | 领域模型、命令、`EduApplicationService` 端口 trait；不含 DB、不含 axum | `async-trait`、`serde`、`sdkwork-utils-rust` |
| `crates/sdkwork-content-edu-repository-sqlx` | `sdkwork-content-edu-repository-sqlx` | repository | 端口 trait 的 sqlx 实现、`db/`、`repository/` | `sdkwork-edu-database-host`、`sdkwork-database-{config,spi,sqlx}`、`sqlx 0.9` |
| `crates/sdkwork-edu-database-host` | `sdkwork-edu-database-host` | database-host | `DatabaseAssetProvider` / `LifecycleOrchestrator` 装配、连接池 | `sdkwork-database-{config,lifecycle,spi,sqlx}`、`dotenvy` |
| `crates/sdkwork-routes-edu-http-auth` | `sdkwork-routes-edu-http-auth` | routes(bridge) | dual-token 请求上下文、错误映射、信封helper、`gateway_mount()` | `sdkwork-iam-web-adapter`、`sdkwork-web-{core,axum,contract}` |
| `crates/sdkwork-routes-edu-app-api` | `sdkwork-routes-edu-app-api` | routes | app-api 路由 + `http_route_manifest` + mapper | service、http-auth、`sdkwork-web-contract`、`sdkwork-utils-rust` |
| `crates/sdkwork-routes-edu-backend-api` | `sdkwork-routes-edu-backend-api` | routes | backend-api 路由（每 operation 带 permission + auditEvent） | 同上 |
| `crates/sdkwork-api-edu-assembly` | `sdkwork-api-edu-assembly` | api-assembly | 生成式装配：`assemble_api_router*`、`assembly-manifest.json`（routeCrates + mountOrder） | 上述 routes + `sdkwork-web-bootstrap` |
| `crates/sdkwork-edu-embedded-bootstrap` | `sdkwork-edu-embedded-bootstrap` | bootstrap(embedded) | 进程内装配 IAM/Drive/Audit/Notify 适配器（`DrivePort` 实现） | **`sdkwork-drive-uploader-service`**、**`sdkwork-drive-app-sdk-generated-rust`**、`sdkwork-utils-rust`、repository |
| `crates/sdkwork-api-edu-standalone-gateway` | `sdkwork-api-edu-standalone-gateway` | binary | 唯一 HTTP 入口：`main.rs` 绑定 `SDKWORK_EDU_APPLICATION_PUBLIC_INGRESS_BIND` | assembly、`sdkwork-iam-web-adapter`、`sdkwork-web-bootstrap` |

层间规则（`APPLICATION_LAYERED_ARCHITECTURE_SPEC.md`）：`routes → service → repository → database-host`，单向；`service` 不得依赖 axum/sqlx 实现；唯一 HTTP 入口，禁止第二监听端口。

### 2.4 依赖矩阵（**逐条对接用户 6 项要求**）

| 框架 | Rust 坐标（`[workspace.dependencies]` 写法） | TS 坐标 | 用途 |
|---|---|---|---|
| sdkwork-web-framework | `sdkwork-web-core`、`sdkwork-web-axum`、`sdkwork-web-contract`、`sdkwork-web-bootstrap` ← `../sdkwork-web-framework/crates/*` | — | 路由、信封、请求上下文、bootstrap、`/health` 等运维端点 |
| sdkwork-database | `sdkwork-database-config`、`-lifecycle`、`-spi`、`-sqlx` ← `../sdkwork-database/crates/*`；CLI `-p sdkwork-database-cli` | — | 迁移/种子/漂移/连接池 |
| sdkwork-utils | `sdkwork-utils-rust` ← `../sdkwork-utils/packages/sdkwork-utils-rust` | `@sdkwork/utils`（23 子路径：`/string`、`/datetime`、`/id`、`/money`、`/pagination`、`/validation`、`/result`、`/i18n`、`/crypto` …） | 通用方法去重 |
| sdkwork-drive（后端上传） | `sdkwork-drive-uploader-service` ← `../sdkwork-drive/crates/sdkwork-drive-uploader-service`；`sdkwork-drive-workspace-service` ← `../sdkwork-drive/crates/sdkwork-drive-workspace-service` | — | **服务端字节写入**（§9.1 强制，禁止 HTTP 自调 App API） |
| sdkwork-drive（后端读取） | `sdkwork-drive-app-sdk-generated-rust` ← `../sdkwork-drive/sdks/sdkwork-drive-app-sdk/sdkwork-drive-app-sdk-rust/generated/server-openapi` | — | 下载授权 `download_grants_create`、节点元数据 `nodes_retrieve` |
| sdkwork-drive（前端） | — | `@sdkwork/drive-app-sdk`（含 `.uploader.*`）、子路径 `/uploader` | 上传会话、分片、下载 URL |
| sdkwork-iam | `sdkwork-iam-web-adapter` ← `../sdkwork-iam/crates/sdkwork-iam-web-adapter` | `@sdkwork/iam-credential-entry` 等 | `build_web_framework_builder`、双 token、tier、权限 |
| sdkwork-discovery | **不接入** | **不接入** | 无 RPC 服务 |

### 2.5 部署架构

`application-http-gateway` 单入口，两种部署档：

| 档位 | 形态 | 入口 | 平台依赖 |
|---|---|---|---|
| `standalone` | 单二进制 + 内嵌 IAM/Drive 适配器 + webserver(nginx) 反代 | `SDKWORK_EDU_APPLICATION_PUBLIC_INGRESS_BIND=0.0.0.0:3910` | 本地 postgres，`SDKWORK_DATABASE_*` |
| `cloud` | 容器镜像 + Kubernetes/nginx，外部平台网关 | 同 bind，`SDKWORK_EDU_PLATFORM_API_GATEWAY_HTTP_URL` | 托管 postgres + 平台网关 |

- 拓扑 profile 文件：`etc/topology/{standalone,cloud}.{development,test,staging,production,demo}.env`（10 个，缺失即门禁失败）
- webserver：`deployments/webserver/server.common.toml` + `server.<env>.toml` + `server.{standalone,cloud}.toml`，合并规则 `effective(profile.env) = common + environment + profile`
- nginx 旁挂：`nginx.<profile>.<env>.conf` × 10 + `snippets/`（adaptive-web、gateway-locations）
- 交付：`deployments/deploy.yaml`（`deliveryKind: container-image|host-package`，`install.layout: binary-package`，`packages[]` 与 `agent.app.config.json#artifacts.installConfig.packages` 对齐）
- 镜像：多阶段 `rust:1-bookworm` → `debian:bookworm-slim`，仅拷贝 `sdkwork-api-edu-standalone-gateway` 单二进制，`EXPOSE 3910`

### 2.6 分包策略

| 层 | 包 | 说明 |
|---|---|---|
| 客户端应用 | `apps/sdkwork-edu-pc`、`apps/sdkwork-edu-h5` | **Adaptive Web 成对交付**（`check-adaptive-web-standard`），各自含 `src/composition/` 核心包 |
| 共享前端 | `apps/sdkwork-edu-common/packages/{sdkwork-edu-runtime,sdkwork-edu-sdk-ports,sdkwork-edu-mobile-react-*}` | 跨端复用，`@sdkwork/edu-*` |
| SDK | `sdks/sdkwork-edu-app-sdk`、`sdks/sdkwork-edu-backend-sdk`、`sdks/_route-manifests/`、`sdks/_shared/edu-contracts` | 生成物 vs 手写边界严格分离 |
| 后端 | `crates/*`（见 2.3） | 层内高内聚 |
| 数据库 | `database/`（contract/ddl/migrations/seeds/drift） | 单一权威 schema |
| API 契约 | `apis/{app-api,backend-api}/edu/operations.json` | 手写权威输入 |

---

## 3. 目标仓库骨架

```text
sdkwork-edu/
├── .github/workflows/{verify.yml, package.yml}      # 薄封装，调用 sdkwork-ai 可复用 CI
├── .sdkwork/{README.md, .gitignore, skills/README.md, plugins/README.md}
├── apis/
│   ├── app-api/edu/operations.json                  # 学员/家长/教师侧 operation 契约
│   ├── backend-api/edu/operations.json              # 教务管理侧 operation 契约
│   └── README.md
├── apps/
│   ├── sdkwork-edu-pc/                              # Vite + React 19，src/composition/
│   ├── sdkwork-edu-h5/                              # Vite + React 19，src/composition/
│   ├── sdkwork-edu-common/packages/{sdkwork-edu-runtime, sdkwork-edu-sdk-ports, sdkwork-edu-mobile-react-*}
│   └── README.md                                    # 目录索引（每个 app root 一行）
├── bin/                                             # 九入口 + lib/
│   ├── docker-image.sh docker-deploy.sh apps-build.sh apps-package.sh
│   ├── apps-deploy.sh apps-pkg-installer.sh config.sh doctor.sh backup.sh
│   ├── lib/{module.sh, bootstrap.sh}
│   └── README.md
├── config/host/postgres.env.example                 # (gitignored 实际 postgres.env)
├── crates/                                          # 9 个 crate（见 2.3）
├── database/
│   ├── database.manifest.json
│   ├── contract/{schema.yaml, prefix-registry.json, table-registry.json}
│   ├── ddl/{baseline/postgres/0001_edu_baseline.sql, generated/README.md}
│   ├── migrations/postgres/{0000_init.up.sql, ...}
│   ├── seeds/{seed.manifest.json, common/*.sql, locales/{zh-CN,en-US}/}
│   ├── drift/policy.yaml
│   └── fixtures/README.md
├── deployments/
│   ├── deploy.yaml
│   ├── docker/Dockerfile
│   ├── webserver/{README.md, server.common.toml, server.{development,test,staging,production,demo}.toml,
│   │              server.{standalone,cloud}.toml, nginx.<profile>.<env>.conf × 10, snippets/, static/}
│   └── kubernetes/                                  # 显式创建（course 缺失此项，勿复制其缺陷）
├── docs/
│   ├── INDEX.yaml
│   ├── README.md
│   ├── product/{README.md, prd/{README.md, PRD.md, PRD-*.md}}
│   ├── architecture/{README.md, tech/{README.md, TECH_ARCHITECTURE.md, TECH-*.md},
│   │                 decisions/{README.md, ADR-20261102-*.md}, views/README.md}
│   ├── domains/README.md  engineering/{README.md, plans/, reviews/}  guides/{README.md, developer/, integrator/, operator/}
│   ├── runbooks/{README.md, deploy.md, backup-restore.md, troubleshooting.md, log-reference.md}（中英双语）
│   └── changelogs/ migrations/ releases/ archive/
├── etc/
│   ├── sdkwork.deployment.config.json
│   ├── client-env.materialization.json
│   ├── topology/*.env                               # 10 个 profile
│   └── examples/config.toml.example
├── examples/ jobs/ plugins/ tools/                  # 各自 README.md（预留）
├── scripts/                                         # 薄入口 + 契约测试
│   ├── sdkwork-command.mjs
│   ├── materialize-edu-openapi.mjs
│   └── edu-*-contract.test.mjs
├── sdks/
│   ├── sdkwork-edu-app-sdk/{openapi/, specs/, bin/generate-sdk.ps1, sdk-manifest.json,
│   │                        sdkwork-edu-app-sdk-typescript/{src/index.ts, generated/server-openapi/}}
│   ├── sdkwork-edu-backend-sdk/…（同构）
│   ├── _route-manifests/{app-api/, backend-api/}    # *.route-manifest.json
│   └── _shared/edu-contracts/                       # @sdkwork/edu-contracts（private）
├── specs/
│   ├── topology.spec.json                           # schemaVersion 5
│   ├── component.spec.json                          # 每个手写模块一份
│   ├── upload.declaration.json                      # 上传声明（DRIVE_SPEC §18）
│   ├── iam.module.manifest.json
│   ├── edu-capabilities.yaml
│   ├── openapi/edu-operation-schemas.contract.json
│   └── database/edu-schema.contract.json
├── tests/{contract/, integration/, e2e/, fixtures/, static/}
├── AGENTS.md CLAUDE.md CODEX.md GEMINI.md           # 根字典 + 兼容 shim
├── README.md                                        # 必须含 repository-kind: application
├── Cargo.toml Cargo.lock
├── package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc
├── tsconfig.json tsconfig.base.json
├── agent.app.config.json agent.workflow.json
├── .gitignore LICENSE
```

**禁止出现**：根级 `packages/`、`api/`、`sdk/`、`deploy/`、`deployment/`、`tooling/`、`.runtime/`、非根 `pnpm-workspace.yaml`、`docs/adr/`。

---

## 4. 六项对齐细则

### 4.1 对齐 sdkwork-specs（第 1 项）

- **根字典**：`AGENTS.md`（含 `<!-- SDKWORK-AGENTS-GENERATED: v1 -->` 与内嵌 `SDKWORK-*-STANDARD: v1` 区块）+ `CLAUDE.md`/`CODEX.md`/`GEMINI.md` 三个**只指向不复制**的 shim。
- **规格解析顺序**写入 `AGENTS.md`：本仓 `AGENTS.md` → `agent.app.config.json` → `specs/README.md` + `specs/component.spec.json` → `.sdkwork/` → `../sdkwork-specs/README.md` → 实现文件。
- **组件规格**：每个手写模块（9 crate + 每个前端包 + 每个 SDK 家族）必须有 `specs/component.spec.json`，含 `component.{name,type,root,domain,capability,languages}` 与 `contracts.{layerRole,publicExports,providedPorts,requiredPorts}`、`verification.commands`。
- **脚本规范**：根 `package.json` 必填 8 动词 + `stop`；`dev` 字面委托 `dev:standalone`；`build/test/check/verify/clean` 委托 `pnpm exec sdkwork-app <verb>` 并各自提供 `_sdkwork:<verb>`；禁止 `edu:*` 前缀。
- **分支/粒度**：默认分支 `main`（`audit-repository-baseline` 强校验）；工作区路径禁止机器绝对路径。

### 4.2 接入 sdkwork-web-framework（第 2 项）

```toml
# Cargo.toml（节选）
[workspace.dependencies]
sdkwork-web-core      = { path = "../sdkwork-web-framework/crates/sdkwork-web-core" }
sdkwork-web-axum      = { path = "../sdkwork-web-framework/crates/sdkwork-web-axum" }
sdkwork-web-contract  = { path = "../sdkwork-web-framework/crates/sdkwork-web-contract" }
sdkwork-web-bootstrap = { path = "../sdkwork-web-framework/crates/sdkwork-web-bootstrap" }
axum = { version = "0.8", features = ["macros"] }
tokio = { version = "1.52", features = ["macros","rt-multi-thread","net","sync"] }
```

标准装配形态（`sdkwork-api-edu-standalone-gateway/src/main.rs`，与 course/drive 同构）：

```rust
let assembly = assemble_api_router().await?;
let framework = build_web_framework_builder(          // 来自 sdkwork-iam-web-adapter
    iam_web_request_context_resolver_from_env().await,
    assembly.route_manifest.clone(),
    infra_public_path_prefixes(),
);
let mut module_registry = ApiModuleRegistry::new();
module_registry.add_modules(vec![assembly]);
let app = module_registry.try_compose("SDKWork Edu API")?
    .into_hosted(framework).router;
sdkwork_web_bootstrap::serve(app, bind_address).await?;
```

路由声明（`sdkwork-routes-edu-app-api/src/http_route_manifest.rs`）：

```rust
use sdkwork_web_contract::{HttpMethod, RouteAuth};
use sdkwork_web_core::{HttpRoute, HttpRouteManifest};
const HTTP_ROUTES: &[HttpRoute] = &[
    HttpRoute::dual_token(HttpMethod::Get, "/app/v3/api/class_schedules", "schedule", "classSchedules.list"),
];
```

规范强制（`WEB_FRAMEWORK_SPEC.md`，均为 MUST）：

- 业务仓必须依赖框架 crate，**不得** fork/复制/重写拦截器链、请求上下文解析、route manifest 契约元数据或安全默认值。
- 受保护路由必须使用 `WebCallInterceptorChain::standard()`（或文档化的严格超集）。
- gateway 必须经 `sdkwork-web-bootstrap` 装配；**禁止**在 route-manifest 绑定之后再另行合并 Router。
- 每个 route manifest 条目必须含 `requestContext: WebRequestContext` 与 `apiSurface`；handler 必须由框架注入 `WebRequestContext`。

落地要点：

1. 路由声明走 `sdkwork_web_contract::HttpRoute`，不手写 `Router::route`：
   `HttpRoute::dual_token(HttpMethod::Get, "/app/v3/api/class_schedules", "schedule", "classSchedules.list")`；
   backend 侧追加 `.with_required_permission("content.edu.schedule.read")`。
2. 响应只用框架信封构造器：成功 `{code:0,data,traceId}`，失败 `ProblemDetail`（`application/problem+json`）。
3. 请求上下文统一 `WebRequestContext`（**不得**用迁移别名 `AppRequestContext`）。
4. `/status`、`/health`、`/ready` 由框架/运维层拥有，业务模块不得声明（`check-route-path-collisions`、`check-api-operation-patterns`）。
5. 唯一 HTTP 监听（`check-single-http-ingress`）；standalone 只起 `sdkwork-api-edu-standalone-gateway` 一个进程。

### 4.3 接入 sdkwork-database（第 3 项）

```jsonc
// database/database.manifest.json
{
  "schemaVersion": 2,
  "kind": "sdkwork.database.module",
  "moduleId": "edu",
  "serviceCode": "EDU",
  "displayName": "EDU Database",
  "owner": "edu-platform",
  "engines": ["postgres"],
  "defaultEngine": "postgres",
  "tablePrefix": "edu_",
  "contractVersion": "1.0.0",
  "baselineStrategy": "baseline-plus-migrations",
  "modules": [],
  "lifecycle": {
    "autoMigrate": false, "seedOnBoot": true,
    "defaultSeedLocale": "zh-CN", "defaultSeedProfile": "standard",
    "supportedSeedLocales": ["zh-CN","en-US","ja-JP","de-DE","fr-FR","ru-RU","ko-KR"],
    "activeSeedLocales": ["zh-CN","en-US"],
    "driftCheckIntervalSec": 60
  },
  "paths": { "contract": "contract/schema.yaml", "migrations": "migrations",
             "seeds": "seeds", "driftPolicy": "drift/policy.yaml" },
  "spi": { "provider": "default", "hooks": [] },
  "databaseRole": "authoritative-server"
}
```

- 契约以 `database/contract/schema.yaml` 为唯一权威，`ddl/baseline/postgres/0001_edu_baseline.sql` 为基线，后续变更只加 `migrations/postgres/*.up.sql`。
- 前缀必须登记：`tools/database-module-registry.json`（父仓）中注册 `edu_`。
- 连接池：进程级共享池（`DATABASE_SPEC_PROCESS_SHARED_POOL.md`，`check-process-shared-database-pool`），SaaS 多租户统一 postgres 档（`check-unified-postgres-profile`）。所有连接池**必须**经 `sdkwork-database` 创建。
- 生命周期：**必须**通过 `sdkwork-database-spi` 扩展，**不得**把编排逻辑复制成自建安装器。
- 应用根：`SDKWORK_EDU_APP_ROOT`，回退 `CARGO_MANIFEST_DIR/../..`。

`crates/sdkwork-edu-database-host/src/lib.rs` 标准形态：

```rust
let module   = Arc::new(DefaultDatabaseModule::from_app_root(&app_root)?);
let manifest = DatabaseManifest::from_file(module.manifest_path())?;
let options  = lifecycle_options_from_env("EDU", &manifest);
let cfg      = DatabaseConfig::from_env("EDU");           // SDKWORK_DATABASE_*
let pool     = create_pool_from_config(cfg)?;
let orchestrator = LifecycleOrchestrator::new(pool.clone(), module.clone())
    .with_applied_by("sdkwork-edu");
orchestrator.init().await?;
if options.auto_migrate { orchestrator.migrate().await?; }
if options.seed_on_boot { orchestrator.seed(&options.seed_locale, &options.seed_profile).await?; }
```

- 所有 DB 操作走 CLI 二进制 **`sdkwork-db`**（`cargo run --manifest-path ../sdkwork-database/Cargo.toml -p sdkwork-database-cli -- --app-root .`）：`validate | init | plan | migrate | seed | bootstrap | status | drift | drift-check`，支持 `--locale zh-CN --profile standard`；不手写 `psql` 脚本。

### 4.4 接入 sdkwork-utils（第 4 项，去重是硬指标）

坐标：`sdkwork-utils-rust = { path = "../sdkwork-utils/packages/sdkwork-utils-rust" }`（crate **0.11.0**）；`"@sdkwork/utils": "workspace:*"`（npm **0.11.1**，25 个模块、`exports` 23 条 = 根 + 22 个子路径）。

关键 API（直接决定代码标准化程度）：

- Rust：`serde_int64` / `serde_uint64`（int64 线上字符串）、`service_base_url::{ServiceMode, BaseUrlSource}`、`http_api::{parse_offset_list_cursor, offset_limit_page_from_iter, OffsetLimitPage}`、`id`、`datetime`、`string::{trim, is_blank}`、`validation`、`crypto`、`result`。
- TS：`SdkWorkApiResponse`、`SdkWorkResultCode`、`SdkWorkProblemDetail`、`unwrapSdkWorkApiResponse`、`readSdkWorkProblemMessage`、`isSdkWorkSuccessCode`、`SDKWORK_TRACE_ID_HEADER`；`@sdkwork/utils/id → uuid()`、`@sdkwork/utils/pagination`。

规范强制（`APP_SDK_INTEGRATION_SPEC.md` / `NAMING_SPEC.md`）：

- baseURL 解析**只允许**在 `sdkwork-utils-rust::service_base_url` 实现一次，消费模块不得重写优先级、不得内联 bind/env 解析。
- 应用**必须**经包 `exports` 正常解析消费 `@sdkwork/utils`，**不得**在 Vite/tsconfig 里用 path alias 绕过缺失子路径。
- `http_api` 的 offset/cursor helper **仅**用于已有索引支撑的迭代器。

| 场景 | 必须使用 | 禁止自造 |
|---|---|---|
| int64 ↔ string 序列化 | `sdkwork_utils_rust::serde_int64`（`#[serde(with = ...)]`） | 自定义 `to_string` 字段 |
| ID 生成/解析 | `sdkwork_utils_rust::id`、`@sdkwork/utils/id` | 自写 snowflake/uuid 包装 |
| 时间/时区/格式化 | `::datetime`、`@sdkwork/utils/datetime` | `chrono` 手工拼装 |
| 金额 | `::money` + `::decimal_math`、`@sdkwork/utils/money` | `f64` 计算金额 |
| 分页参数解析 | `::http_api` 分页 helper、`@sdkwork/utils/pagination` | 自定义 `pageSize` 解析 |
| 响应构建 | `::http_api`、`::result`（`@sdkwork/utils/result`） | 本地 envelope 工具 |
| 校验 | `::validation`、`@sdkwork/utils/validation` | 正则散落业务层 |
| 字符串/集合/对象 | `::string` `::collection` `::object` `::compare` | 工具类大杂烩 |
| 加密/编码 | `::crypto` `::encoding`、`@sdkwork/utils/crypto` | 直接引 `sha2`/`aes-gcm` 到业务层 |
| 基础 URL 解析 | `::service_base_url`、`@sdkwork/utils/gatewayEndpoint` | 硬编码域名 |

验收口径：`check-application-layering`（禁止 `fetch`/`axios`/原生 HTTP 直连）+ 新 PR 出现 `*_util.*`/`*_helper.*` 自造文件即评审打回；TS 侧必须走 `@sdkwork/utils/<module>` 子路径导入（`check-sdkwork-subpath-exports`）。

### 4.5 接入 sdkwork-drive（第 6 项，上传红线）

**声明（唯一身份源）** — `specs/upload.declaration.json`：

```jsonc
{
  "schemaVersion": 1,
  "appId": "sdkwork-edu",
  "declarations": [
    { "appResourceType": "edu.material",   "appResourceIdKind": "entity", "scene": "material",   "source": "edu-material",     "uploadProfileCode": "document",   "retention": "long_term", "purpose": "教学资料" },
    { "appResourceType": "edu.submission", "appResourceIdKind": "entity", "scene": "homework",   "source": "edu-assignment",   "uploadProfileCode": "attachment", "retention": "long_term", "purpose": "作业附件" },
    { "appResourceType": "edu.avatar",     "appResourceIdKind": "entity", "scene": "avatar",     "source": "edu-profile",      "uploadProfileCode": "avatar",     "retention": "long_term", "purpose": "头像" },
    { "appResourceType": "edu.cover",      "appResourceIdKind": "entity", "scene": "cover",      "source": "edu-class",        "uploadProfileCode": "image",      "retention": "long_term", "purpose": "班级封面" },
    { "appResourceType": "edu.evidence",   "appResourceIdKind": "draft",  "scene": "leave-proof","source": "edu-attendance",   "uploadProfileCode": "image",      "retention": "temporary", "retentionTtlSeconds": 7776000, "purpose": "请假凭证" }
  ]
}
```

**前端**（PC/H5 共用同一封装包，禁止裸 `fetch`/`axios`）：

```ts
import { createClient, type SdkworkDriveAppClient } from "@sdkwork/drive-app-sdk";
import { uuid } from "@sdkwork/utils/id";

const drive: SdkworkDriveAppClient = createClient({
  baseUrl, accessToken, authToken, platform: "pc", tokenManager,
});
const result = await drive.uploader.upload({
  file,
  appResourceType: "edu.material",   // 必须与声明字面量完全一致
  appResourceId: materialId,
  scene: "material",
  source: "edu-material",
  uploadProfileCode: "document",
  originalFileName: file.name,
  contentType: file.type || "application/octet-stream",
});
const nodeId = result.uploadItem.nodeId;
```

SDK 内部完成 prepare → 分片预签 → 单次 PUT 直传对象存储 → markUploaded → complete；这次对预签 URL 的 PUT 是**唯一**被允许的裸字节上传。`@sdkwork/drive-app-sdk/uploader` 子路径（`createDriveUploaderClient`、`planUploaderParts`、`createInMemoryUploaderStateStore`）用于需要自管分片状态的场景。

**后端（Rust）分为两条路径，不可混用**：

| 场景 | 必须依赖 | 禁止 |
|---|---|---|
| 服务端写字节（导出报表、合并 PDF、生成证书） | **`sdkwork-drive-uploader-service`**：`DriveUploaderService` + `PrepareUploaderUploadCommand` + `UploadBytesCommand` + `SqlUploaderStore`，`app_id = "sdkwork-edu"`，`UploaderTarget::AutoUploadSpace`，`UploaderRetention::{LongTerm,Temporary}` | 自建 `/upload`、`/presign`、`/complete` 路由；直接调 S3/OSS/MinIO SDK；`std::fs` 落盘当持久内容；HTTP 回调自家 Drive App API |
| 服务端读/授权（预览链接、下载票据） | **`sdkwork-drive-app-sdk-generated-rust`**：`SdkworkAppClient::new_with_base_url` → `.drive().nodes_retrieve(id)`、`.drive().download_grants_create(id, &CreateDownloadGrantRequest { requested_ttl_seconds })` | 自行拼下载 URL |

```rust
// 上传：sdkwork-memory/.../uploader.rs 同构写法
let uploader = DriveUploaderService::new(SqlUploaderStore::new(pool));
let cmd = PrepareUploaderUploadCommand {
    tenant_id, organization_id: None,
    actor: UploaderActor::User { user_id },
    app_id: "sdkwork-edu".to_string(),
    app_resource_type: "edu.material".to_string(),   // 与声明一致
    app_resource_id: material_id,
    upload_profile_code: "document".to_string(),
    target: UploaderTarget::AutoUploadSpace { parent_node_id: None },
    retention: UploaderRetention::LongTerm,
    // file_fingerprint / original_file_name / content_type / content_length
    // chunk_size_bytes / operator_id / now_epoch_ms / id / task_id
    ..
};
```

**业务表落库规则**（`DRIVE_SPEC.md` §5.2 / `MEDIA_RESOURCE_SPEC.md`）：

- **只存** `drive_space_id`、`drive_node_id`、`drive_uri`（`drive://spaces/{spaceId}/nodes/{nodeId}`）或 `MediaResource` 快照。
- **禁止**存 `bucket`、`object_key`、provider endpoint、凭据引用、预签 URL、`*_url`（如 `avatar_url`、`file_url`）作为真相源。
- 业务 API 只接收 `{ driveNodeId }` / `driveUri`，客户端不得传 `appId`/`tenantId`/`organizationId`/`userId`（由 `WebRequestContext` 注入）。

**生态现状提醒**：工作区内**尚无任何仓库**存在 `specs/upload.declaration.json`，且既有调用点普遍使用下划线字面量（如 `course_media_asset`），不符合 `^[a-z][a-z0-9]*(?:\.[a-z][a-z0-9_]*)+$` 的点分要求。`sdkwork-edu` 应作为**首个合规实现**，不得复制既有下划线写法。

**验收**：`node ../sdkwork-specs/tools/check-upload-declaration-standard.mjs --workspace ..` 通过（校验 `appId` 与 `agent.app.config.json#backend.appId` 一致、字段封闭、三元组 `(appResourceType, scene, uploadProfileCode)` 唯一、调用点字面量全部来自声明、`scene≠im`、`temporary` 必须带 TTL）。

### 4.6 不接入 sdkwork-discovery（第 5 项）

- 当前**无 RPC 服务**（无 `sdkwork-rpc-framework` 依赖、无 `.proto`、无 gRPC server crate），按 `DISCOVERY_SPEC.md` §12 不应接入；接入即为死重量。
- **生态事实**：工作区内没有任何应用仓在 `Cargo.toml` 中引入 `sdkwork-discovery`；`sdkwork-community`、`sdkwork-web-framework` 的 README 均以 `| sdkwork-discovery | Not required (no RPC services yet) |` 明示。`sdkwork-edu` 沿用该行，写在 `README.md` 的依赖表中。
- **未来触发条件（任一满足即开 ADR 并接入）**：
  1. 仓库出现 gRPC server crate（`sdkwork-edu-rpc` 类）或 RPC 二进制；
  2. 任一 RPC 调用方需要在 **>1 实例**间动态解析对端。
- 接入顺序（不可跳步）：先接 `sdkwork-rpc-framework`（客户端 resolver）→ 再以 `resolver profile = discovery`（或 `composite` 且 discovery 为主）接 `sdkwork-discovery-core/-rpc` → 实现 `startup → register → renew loop` 与 `shutdown → deregister → 停 renew → drain in-flight` → 存储必须 postgres（拒绝 SQLite）→ `check-discovery-standard` + `check-rpc-framework-standard` 通过 → 更新 `TECH_ARCHITECTURE.md`。

### 4.7 API 契约（输入/输出严格标准）

**成功**：

```json
{ "code": 0, "data": { "item": { "id": "12884901888", "displayName": "2026 秋季一班" } },
  "traceId": "0195f2a0-7c44-7b2e-9f3a-2a6f5d8e91ab" }
```

`data` 四种形态：`{item}`、`{items, pageInfo}`、`{accepted}`、`{accepted, operationId, status, pollUrl?}`。

**失败**：HTTP 4xx/5xx + `application/problem+json`：

```json
{ "type": "about:blank", "title": "Validation failed", "status": 422, "code": 40001,
  "traceId": "0195f2a0-...", "i18nKey": "errors.result.40001", "locale": "zh-CN",
  "instance": "POST /backend/v3/api/classes", "operationId": "classes.create",
  "errors": [{ "field": "termId", "message": "must not be blank", "code": 40011 }] }
```

强制项：

| 维度 | 规则 |
|---|---|
| 状态码 | retrieve/list/search/update `200`，create `201`，delete `204`（无体），async `202`，bulk `200/202` |
| 错误码 | 数字 `status*100+seq`；`40001-49999` 客户端、`50001-59999` 服务端、`60001-69999` 领域业务、`70001-79999` 集成 |
| 命名 | JSON `lowerCamelCase`；query/DB/Rust `lower_snake_case`；schema `PascalCase`；`operationId` 点分 `resource.action` |
| int64 | 一律 string + `x-sdkwork-int64-string: true` |
| 租户/组织 | **仅来自 token**；禁止任何客户端 header/query/body 传入 `tenant_id`/`tenantId` |
| locale | 仅 `Accept-Language`（`X-SdkWork-Locale` 已退役） |
| 幂等 | `Idempotency-Key`（1–128）+ `x-sdkwork-idempotent: true`；并发用 `If-Match` |
| 分页 | `page`（1 起）/`page_size`（≤200）/`cursor`，二者互斥；禁 `pageSize`/`limit`/`per_page`；禁内存分页 |
| 权限 | 码 `{domain}.{resource}.{action}`；app-api tier 0–2 **不得**声明 `x-sdkwork-permission`；backend-api 必须声明并映射为 `required_permission` |

**SDK 生成链路**（禁止手改生成物）：

```text
apis/<surface>/edu/operations.json
  → sdks/_route-manifests/<surface>/sdkwork-routes-edu-<surface>.route-manifest.json
  → sdks/sdkwork-edu-<surface>-sdk/openapi/sdkwork-edu-<surface>-api.openapi.yaml      （authority）
  → sdks/sdkwork-edu-<surface>-sdk/openapi/sdkwork-edu-<surface>-api.sdkgen.yaml      （generation input）
  → node ../sdkwork-sdk-generator/bin/sdkgen.js generate -i <sdkgen> -o <generated/server-openapi> \
        -n sdkwork-edu-<surface>-sdk -t <app|backend> -l typescript --standard-profile sdkwork-v3 \
        --api-prefix /<surface>/v3/api --package-name @sdkwork/edu-<surface>-sdk
  → sdks/sdkwork-edu-<surface>-sdk/<pkg>-typescript/src/index.ts（composed facade）
```

---

## 5. 执行计划（P0 → P8）

> 每阶段都有**硬退出条件**；未满足不得进入下一阶段。估算为单人日，括号为并行后的关键路径。

### P0 决策与治理（0.5d）

| 任务 | 产出 |
|---|---|
| D1 `domain` 裁决 | `docs/architecture/decisions/ADR-20261102-domain-taxonomy.md` |
| D2 领域能力范围冻结 | `specs/edu-capabilities.yaml` |
| D3 端口/主机名分配（bind `3910`，`edu.sdkwork.com` 及 4 环境） | ADR + `specs/topology.spec.json` 草案 |
| D4 许可证统一（`AGPL-3.0-or-later`） | `LICENSE` + 全 `Cargo.toml`/`package.json` |
| D5 工作区注册（`.gitmodules`/拓扑登记） | 父仓变更说明 |
| D6 discovery 延后归档 | ADR（记录触发条件，见 4.6） |
| 初始化 `git init` + 分支 `main` | `.git` |

**退出**：6 份 ADR 合入；`git branch --show-current` = `main`。

### P1 仓库骨架与平台元数据（1.5d）

| 任务 | 产出 |
|---|---|
| 根字典与 shim | `AGENTS.md`、`CLAUDE.md`、`CODEX.md`、`GEMINI.md`、`.sdkwork/**` |
| 根清单 | `README.md`（含 `repository-kind: application`）、`.gitignore`、`.npmrc`、`tsconfig.base.json`、`tsconfig.json` |
| `package.json` 全量脚本 | 8 动词 + `stop` + `_sdkwork:*` + `topology:validate` + `api:assembly:*` + `db:*` + `check:*` |
| `pnpm-workspace.yaml`（含 `catalog:`） | 子包 glob + 兄弟仓 `workspace:*` 声明（每项只声明一次） |
| `bin/` 九入口 + `lib/` | 从 `sdkwork-drive` 复制后仅改 `bin/lib/module.sh` 身份变量 |
| `apps/README.md`、`examples|jobs|plugins|tools/README.md` | 目录索引 |
| 文档 Canon 全套 | 见 §3 `docs/` 树，含 `docs/INDEX.yaml` |
| 平台元数据 | `agent.app.config.json`(v3)、`agent.workflow.json`、`etc/sdkwork.deployment.config.json`、`etc/client-env.materialization.json`、`etc/topology/*.env` ×10、`config/host/postgres.env.example` |
| CI | `.github/workflows/{verify,package}.yml`（薄封装、pinned ref） |

**退出**：
```powershell
node ../sdkwork-specs/tools/check-workspace-layout.mjs --workspace ..
node ../sdkwork-specs/tools/check-pnpm-script-standard.mjs --workspace ..
node ../sdkwork-specs/tools/check-module-bin.mjs --workspace ..
node ../sdkwork-specs/tools/check-script-placement.mjs --workspace ..
node ../sdkwork-specs/tools/check-gitignore-standard.mjs --workspace ..
node ../sdkwork-specs/tools/check-identity-naming.mjs --root .
node ../sdkwork-specs/tools/verify-repo.mjs --root .
```

### P2 数据库骨架（2d，先库后码）

| 任务 | 产出 |
|---|---|
| 模块清单 | `database/database.manifest.json`（§4.3） |
| 契约与注册 | `contract/schema.yaml`（10 张 `edu_*` 表）、`prefix-registry.json`、`table-registry.json` |
| 基线 DDL | `ddl/baseline/postgres/0001_edu_baseline.sql` |
| 迁移目录 | `migrations/postgres/0000_init.up.sql` + README |
| 种子 | `seeds/seed.manifest.json`（`minimal`/`standard`）、`common/*.sql`、`locales/{zh-CN,en-US}/` |
| 漂移策略 | `drift/policy.yaml` |
| database-host crate | `crates/sdkwork-edu-database-host`（`DatabaseAssetProvider`/`LifecycleOrchestrator`） |
| 契约测试 | `tests/contract/database-framework.contract.test.mjs` |
| `tools/database-module-registry.json` 注册 `edu_` | 父仓 PR |

**退出**：`pnpm db:validate`、`pnpm db:plan`、`pnpm test:contract:database`、`check-database-framework-standard`、`check-process-shared-database-pool`、`check-unified-postgres-profile`、`check-database-bootstrap-references` 全绿。

### P3 Rust 后端分层（3d）

| 任务 | 产出 |
|---|---|
| workspace 清单 | `Cargo.toml`/`Cargo.lock`（9 crate，`[workspace.package]`+`[workspace.lints]`，每 crate `[lints] workspace = true`） |
| service | `sdkwork-content-edu-service`：领域模型 + `EduApplicationService` 端口 |
| repository | `sdkwork-content-edu-repository-sqlx`：sqlx 实现（`edu_*`） |
| routes | `sdkwork-routes-edu-http-auth`、`-app-api`、`-backend-api`（`HttpRoute` 声明 + `http_route_manifest` + mapper） |
| assembly | `sdkwork-api-edu-assembly` + `assembly-manifest.json` |
| 入口 | `sdkwork-api-edu-standalone-gateway/src/main.rs`（单入口，bind `SDKWORK_EDU_APPLICATION_PUBLIC_INGRESS_BIND`） |
| 嵌入式适配 | `sdkwork-edu-embedded-bootstrap`（IAM/Drive/Audit/Notify 端口实现；Drive 写入走 `sdkwork-drive-uploader-service`，读取走 `sdkwork-drive-app-sdk-generated-rust`） |

**退出**：`cargo fmt --all --check`、`cargo clippy --workspace --tests -- -D warnings`、`cargo test --workspace`、`check-application-layering`、`check-rust-backend-composition`、`check-rust-crate-naming-standard`、`check-rust-manifest-standard`、`check-web-module-adoption`、`check-single-http-ingress`。

### P4 API 契约与 SDK 生成（2.5d）

| 任务 | 产出 |
|---|---|
| operation 契约 | `apis/{app-api,backend-api}/edu/operations.json`（含 `operationId` 点分、`x-sdkwork-*` 扩展） |
| 路由清单 | `sdks/_route-manifests/{app-api,backend-api}/*.route-manifest.json` |
| authority OpenAPI | `sdks/*/openapi/sdkwork-edu-*-api.openapi.yaml` + `.sdkgen.yaml` |
| SDK 生成 | `sdks/sdkwork-edu-{app,backend}-sdk/**`（`@sdkwork/edu-app-sdk`、`@sdkwork/edu-backend-sdk`） |
| SDK 清单 | `sdk-manifest.json`（`schemaVersion 1`，`standardProfile: sdkwork-v3`，`discoverySurface.apiPrefix`） |
| 装配校验 | `api:assembly:materialize` / `api:assembly:validate` |
| 共享契约 | `sdks/_shared/edu-contracts`（`@sdkwork/edu-contracts`） |

**退出**：`pnpm api:materialize && pnpm check:openapi-drift`、`pnpm api:assembly:validate`、`check:api-envelope`、`check-api-operation-patterns`、`check-pagination`、`check-route-path-collisions`、`check-app-permission-tiers`、`check-sdk-standard`、`check-sdkwork-subpath-exports`、`check-api-assembly-integration-closure`、`check-api-runtime-parity`。

### P5 前端应用 PC + H5（4d）

| 任务 | 产出 |
|---|---|
| 两个 app root | `apps/sdkwork-edu-{pc,h5}`（Vite 8 + React 19 + Tailwind 4），各含 `src/composition/` 核心包与标准 `exports` 子路径 |
| 共享包 | `apps/sdkwork-edu-common/packages/{runtime, sdk-ports, mobile-react-*}` |
| 运行时环境 | `etc/client-env.materialization.json` + 每 app `etc/sdkwork.deployment.config.json`（10 profile → `browser/runtime-env.<profile>.json`） |
| 上传 | 抽 `packages/sdkwork-edu-drive-uploader`：内部只调 `@sdkwork/drive-app-sdk` 的 `createClient(...).uploader.upload(...)`，`appResourceType/scene/source/uploadProfileCode` 字面量全部来自 `specs/upload.declaration.json` |
| i18n | `<locale>/<domain>/<capability>/<fragment>` 分片；无仓库级 i18n 单体 |
| 主题 | light/dark 双模 + `THEME_CONFORMANCE_MATRIX` 对齐 |

**退出**：`pnpm typecheck:apps`、`pnpm build:pc:{dev,prod}`、`pnpm build:h5:{dev,prod}`、`check-frontend-composition`、`check-client-host-packages`、`check-adaptive-web-standard`、`check-tailwind-integration`、`check-theme-conformance`、`check-i18n-standard`、`check-browser-build-scripts`、`check-vite-workspace-aliases`、`check-app-sdk-consumer-imports`、**`check-upload-declaration-standard`**。

### P6 部署与打包（2d）

| 任务 | 产出 |
|---|---|
| 部署清单 | `deployments/deploy.yaml`（`cloud.production` 默认；`install.layout: binary-package`；`packages[]`） |
| 镜像 | `deployments/docker/Dockerfile`（多阶段，单二进制，`EXPOSE 3910`） |
| webserver | `server.common.toml` + `server.<env>.toml` ×5 + `server.{standalone,cloud}.toml` + `nginx.<profile>.<env>.conf` ×10 + `snippets/` |
| K8s | `deployments/kubernetes/`（补 course 缺失项） |
| 发布 | `agent.app.config.json#artifacts.installConfig.packages` 双档 tar.gz + sha256；`release.notes[0]` = 0.1.0 |

**退出**：`pnpm topology:validate`、`check-deploy-standard`、`check-app-manifest-standard`、`check-app-manifest-deployment-standard`、`check-webserver-toml-standard`、`check-application-deploy-layout`、`check-topology-deployment-profiles`、`check-env-file-naming`、`check-component-port-bindings`、`check-application-cloud-gateway-boundary`。

### P7 测试 / 安全 / 性能 / 可观测（2.5d）

| 维度 | 内容 | 门禁 |
|---|---|---|
| 测试 | `tests/contract`（信封、分页、权限 tier、DB 契约、路由集成）、`tests/integration`、`tests/e2e` | `pnpm test`、`check-api-runtime-parity` |
| 安全 | 双 token、租户仅来自 token、`If-Match`、幂等、CORS 白名单、安全响应头、密钥不入库 | `check-cors-standard`、`check-rust-http-header-standard`、`check-token-minimal-claims`、`check-auth-session-retention`、`check-subject-id-alignment`、`check-permission-composition` |
| 供应链 | `pnpm-lock.yaml` 提交、`onlyBuiltDependencies`、`sbom:generate`/`sbom:check` | `check-repository-baseline-content` |
| 性能 | 进程级共享连接池、分页下推 SQL、`edu_*` 索引与复合索引、列表接口默认 20/上限 200、无 N+1 | `PERFORMANCE_SPEC.md` 自查 + `db:plan` 索引评审 |
| 可观测 | `traceId` 贯穿、结构化日志、`/health`/`/ready`、漂移巡检 60s | `OBSERVABILITY_SPEC.md` |

**退出**：`pnpm verify` 全绿。

### P8 门禁收敛与 0.1.0 发布（1.5d）

1. `node ../sdkwork-specs/tools/run-gate-matrix.mjs --workspace ..` → 22 项全绿（对 `sdkwork-edu` 零新增违规）。
2. `node ../sdkwork-specs/tools/audit-repository-baseline.mjs --root .` 与 `audit-repository-docs-workspace.mjs` 通过。
3. `pnpm verify` / `cargo test --workspace` / `cargo build --workspace --release` / `docker build` 通过。
4. 完成 `docs/` Canon 终稿（PRD、TECH_ARCHITECTURE、runbooks 双语、`REVIEW-20261102-*.md`）。
5. 本文件迁移为 `docs/engineering/plans/PLAN-2026-1102-edu-bootstrap.md`。

---

## 6. 门禁与验收矩阵

### 6.1 Workspace 级（`gates.manifest.json`，22 项）

| 门禁 | 本仓关注点 |
|---|---|
| `check:workspace-layout` | 无 `api/ sdk/ deploy/ deployment/ tooling/ .runtime/`；根字典齐全 |
| `check:pnpm-script-standard` | 8 动词 + `stop` + `_sdkwork:*` 成对；无 `edu:*` |
| `check:module-bin` | 九入口齐全且命名正确 |
| `check:script-placement` | 所有脚本在 `bin/` |
| `check:gitignore-standard` | 不忽略 `bin/`、`sdks/**/generated/` |
| `check:rust-crate-naming-standard` | crate 目录 = package 名（kebab）；`[lib] name` 为 snake |
| `check:application-layering` | 无原生 `fetch/axios`、无越层依赖 |
| `check:subject-id-alignment` | `tenant_id/organization_id/user_id` 仅来自 token |
| `check:topology-deployment-profiles` | 10 profile 存在且枚举合法 |
| `check:base-url-resolution` | SDK baseURL 走标准解析 |
| `check:provider-session-identity` | `providerSessionId` 命名 |
| `check:vite-workspace-aliases` | 不在 vite/vitest 里 alias `@sdkwork/*` |
| `check:identity-naming` | 无 `*-pc-product` 等退役命名 |
| `check:shell-portability` | bash 3.2 兼容，无 GNU-only |
| `check:sdkwork-subpath-exports` | `@sdkwork/utils/<module>` 子路径 |
| `check:client-host-packages` | 每架构一个 host 包，独立 manifest |
| `check:workspace-path-portability` | 无机器绝对路径 |
| `check:repository-baseline-content` | 无被跟踪编译产物 / `node_modules/target/dist/.env` |
| `check:agent-workflow-standard` | 薄工作流、pin、lane 名 |
| `check:destructive-operation-patterns` | 无通配/递归删除 |
| `check:theme-conformance` | 主题/暗色一致性 |
| `check:github-workflow-model` / `check:github-workflow-conformance` | 工作流模型一致 |

一键：`node ../sdkwork-specs/tools/run-gate-matrix.mjs --workspace ..`

### 6.2 应用级（本仓 `pnpm` 脚本）

```jsonc
"check": "pnpm run check:api-envelope && pnpm run check:openapi-drift && pnpm run check:app-composition
        && pnpm run check:cors-standard && pnpm run check:browser-build-scripts && pnpm run check:upload-declaration",
"_sdkwork:check": "pnpm run check",
"verify": "pnpm run test && pnpm run typecheck:apps && pnpm run test:contract:database
        && cargo test --workspace && pnpm run check",
"_sdkwork:verify": "pnpm run verify"
```

核心 check 清单：`check:api-envelope`、`check:openapi-drift`、`check:app-composition`（`verify-repo.mjs`）、`check:cors-standard`、`db:validate`、`api:assembly:validate`、`topology:validate`、`check:upload-declaration`、`check:sdk-contract`、`test:route-integration`。

### 6.3 门禁通过顺序（依赖关系）

```text
P1 骨架门禁  →  P2 DB 门禁  →  P3 Rust 门禁  →  P4 API/SDK 门禁
                                          ↘  P5 前端门禁  →  P6 部署门禁  →  P7 测试/安全  →  P8 全量矩阵
```

---

## 7. 测试策略

| 层 | 内容 | 工具 |
|---|---|---|
| 契约 | 信封/分页/错误码/权限 tier/`int64` string 序列化 | `node --test scripts/*.test.mjs` |
| DB 契约 | manifest/契约/迁移/种子与框架约定一致 | `tests/contract/database-framework.contract.test.mjs` |
| 路由集成 | `HttpRoute` 声明 ↔ OpenAPI ↔ route manifest 三方一致 | `check-api-runtime-parity`、`test:route-integration` |
| 单元 | service 层纯逻辑（无 DB/axum） | `cargo test -p sdkwork-content-edu-service` |
| 仓储 | sqlx 对真实 postgres（`db:init` 后） | `cargo test -p sdkwork-content-edu-repository-sqlx` |
| E2E | PC/H5 关键流程（登录→班级→课表→作业→提交） | Playwright |
| 上传 | 声明一致性 + uploader 调用参数来源 | `check-upload-declaration-standard` |

---

## 8. 安全与合规要点

1. **身份**：`Authorization: Bearer` + `Access-Token` 双 token（`x-sdkwork-auth-mode: dual-token`）；bootstrap 登录仅 `AccessToken` + `credential-entry-bootstrap`。
2. **租户隔离**：`tenant_id`/`organization_id` 只从已验签 token 解析；`organization_id = 0` 表示租户级，不得因缺失返回 `40304`。
3. **权限**：app-api tier 0–2 不声明权限码；backend-api 必须 `x-sdkwork-permission` + `required_permission` + `x-sdkwork-auth-tier`。
4. **数据**：敏感字段 `writeOnly: true`；日志脱敏；`seeds`/`fixtures`/`etc` 不含真实密钥（`config/host/postgres.env` 强制 gitignore）。
5. **供应链**：锁定 `pnpm-lock.yaml`/`Cargo.lock`；`onlyBuiltDependencies` 显式声明；SBOM 生成与校验。
6. **HTTP**：CORS 白名单（`CORS_SPEC.md`）、安全响应头（`check-rust-http-header-standard`）、限流 tier。
7. **危险操作**：迁移/删除/回滚受 `DESTRUCTIVE_OPERATION_SPEC.md` 与 `ROLLBACK_RESTRICTION_SPEC.md` 约束，`bin/` 脚本不得出现通配删除。

---

## 9. 性能要点

| 关注点 | 做法 |
|---|---|
| 连接池 | 进程级共享池（`DATABASE_SPEC_PROCESS_SHARED_POOL.md`），standalone 单进程复用 |
| 查询 | 列表一律 SQL 侧分页与过滤；禁止 `collect().skip().take()`；`db:plan` 审索引 |
| 索引 | 每张 `edu_*` 表按 `(tenant_id, organization_id, <业务键>)` 复合索引；课表/考勤按时间区间索引 |
| 缓存 | 遵循 `CACHE_SPEC.md`；热点：学期、班级、课表；失效以事件驱动 |
| 传输 | 上传走 Drive 分片（`uploadPlanner` 默认 chunk），应用侧不中转字节 |
| 前端 | PC/H5 共享 `runtime` 包；路由级拆分；`dist/{standalone,cloud}/{dev,test,staging,prod}` 布局 |

---

## 10. 待裁决事项（必须先决，否则返工）

| ID | 议题 | 选项 | 建议 |
|---|---|---|---|
| **D1** | `domain` 归属 | A. `content`（与 course 同域，零上游改动）<br>B. 新增 `education` 域（需改 `DOMAIN_SPEC.md` + 门禁 + ADR） | **A**，先落地；B 作为后续治理提案（`education` 语义更准，但上游变更成本高且影响全仓门禁） |
| **D2** | 业务范围 | A. 教务管理（班级/排课/考勤/成绩）<br>B. 在线学习（与 course 重叠） | **A**，避免与 `sdkwork-course` 功能重叠 |
| **D3** | 端口/域名 | `3910` / `edu.sdkwork.com` | 采纳 |
| **D4** | 许可证 | `AGPL-3.0-or-later` | 采纳（course 子 crate 出现 `Apache-2.0` 混用，勿复制） |
| **D5** | 是否纳入 `sdkwork-space` 子模块 | A. 是<br>B. 独立仓 | **A**，与其余 100+ 仓一致 |
| **D6** | discovery | 不接入 | 采纳，写明触发条件 |
| **D7** | K8s 目录 | 创建 `deployments/kubernetes/` | 采纳（course 引用但缺失） |

---

## 11. 里程碑与工作量

| 里程碑 | 阶段 | 估算（人日） | 关键产出 |
|---|---|---|---|
| M0 决策冻结 | P0 | 0.5 | 6 份 ADR |
| M1 骨架可门禁 | P1 | 1.5 | 根字典 + `bin/` + docs Canon + 拓扑 |
| M2 库就绪 | P2 | 2 | `database/` 全量 + database-host |
| M3 后端可启动 | P3 | 3 | 9 crate + 单入口进程 |
| M4 API/SDK 冻结 | P4 | 2.5 | OpenAPI + 双 SDK |
| M5 前端可构建 | P5 | 4 | PC + H5 + 上传 |
| M6 可部署 | P6 | 2 | 镜像 + nginx + 部署清单 |
| M7 可发布 0.1.0 | P7+P8 | 4 | 全门禁绿 + 发布物 |

合计 ≈ **19.5 人日**（2 人并行关键路径 ≈ 11–12 个工作日）。

---

## 12. 立即可执行的下一步（按序）

```powershell
cd <repo-root>

# 1) 建立版本控制与分支
git init; git checkout -b main

# 2) 冻结决策（D1/D2）
#    在 docs/architecture/decisions/ 写 ADR-20261102-domain-taxonomy.md / ADR-20261102-scope.md

# 3) 从合规姊妹仓取结构基线（只取结构，不取业务）
Copy-Item ..\sdkwork-course\AGENTS.md, ..\sdkwork-course\CLAUDE.md, ..\sdkwork-course\CODEX.md, ..\sdkwork-course\GEMINI.md .
Copy-Item ..\sdkwork-course\tsconfig.base.json, ..\sdkwork-course\tsconfig.json, ..\sdkwork-course\.gitignore .
Copy-Item -Recurse ..\sdkwork-drive\bin .          # 九入口基准
Copy-Item -Recurse ..\sdkwork-course\docs .        # 再逐个改写为 edu 内容

# 4) 先跑一次空仓门禁，拿到基线违规清单
node ..\sdkwork-specs\tools\verify-repo.mjs --root .
node ..\sdkwork-specs\tools\check-workspace-layout.mjs --workspace ..

# 5) 依次按 P1 → P8 推进，每阶段结束执行该阶段"退出命令"
```

> 注意：`sdkwork-course` 存在已知缺陷，**不可盲抄**——`Cargo.toml` 重复 member、`bin/` 缺九入口、`deployments/kubernetes/` 引用缺失、`operationId` 非点分、`pageSize` 别名、LICENSE 混用。本计划以 `sdkwork-specs` 为准绳，以上述缺陷为反例。

---

## 13. 与用户 6 项要求的最终对照

| 要求 | 本计划落点 | 验收 |
|---|---|---|
| 1. 对齐 sdkwork-specs | §2.1、§3、§4.1、§5 P1/P8、§6 | 22 门禁 + `verify-repo` 全绿 |
| 2. 接入 sdkwork-web-framework | §2.4、§4.2、§5 P3 | `HttpRoute` + 单入口 + 信封，`check-single-http-ingress` |
| 3. 接入 sdkwork-database | §2.4、§4.3、§5 P2 | `db:validate` + `check-database-framework-standard` |
| 4. 接入 sdkwork-utils 去重 | §2.4、§4.4 | 无自造 util；`serde_int64` 等替换到位 |
| 5. 接入 sdkwork-discovery | §4.6、D6 | 未接入（合规），ADR 记录触发条件 |
| 6. 上传经 sdkwork-drive | §4.5、§5 P3/P5 | 前端 `@sdkwork/drive-app-sdk` + 后端 `sdkwork-drive-uploader-service`；`upload.declaration.json`；业务表只存 `drive_node_id`/`drive_uri`；`check-upload-declaration-standard` 通过 |
