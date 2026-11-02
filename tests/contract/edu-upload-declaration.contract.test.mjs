#!/usr/bin/env node
// Repository-local contract test for the Drive upload declaration
// (DRIVE_SPEC.md section 18). The fleet gate
// `sdkwork-specs/tools/check-upload-declaration-standard.mjs --workspace ..`
// audits every repository at once; this test keeps THIS repository
// self-verifying regardless of sibling debt.

import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import path from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");

const ENTRY_FIELDS = new Set([
  "appResourceType",
  "appResourceIdKind",
  "scene",
  "source",
  "uploadProfileCode",
  "retention",
  "retentionTtlSeconds",
  "purpose",
]);
const TOP_LEVEL_FIELDS = new Set(["schemaVersion", "appId", "declarations"]);
const APP_RESOURCE_TYPE = /^[a-z][a-z0-9]*(?:\.[a-z][a-z0-9_]*)+$/u;
const KEBAB_CASE = /^[a-z0-9]+(?:-[a-z0-9]+)*$/u;
const RESOURCE_ID_KINDS = new Set(["application", "entity", "draft"]);
const RETENTION_MODES = new Set(["long_term", "temporary"]);
const RESERVED_SCENES = new Set(["im"]);
const STANDARD_PROFILES = new Set([
  "generic",
  "video",
  "image",
  "audio",
  "document",
  "archive",
  "text",
  "dataset",
  "attachment",
  "avatar",
  "thumbnail",
]);

const declaration = JSON.parse(
  readFileSync(path.join(ROOT, "specs", "upload.declaration.json"), "utf8"),
);
const appConfig = JSON.parse(
  readFileSync(path.join(ROOT, "agent.app.config.json"), "utf8"),
);

test("declaration uses schemaVersion 1 and only known top-level fields", () => {
  assert.equal(declaration.schemaVersion, 1);
  for (const key of Object.keys(declaration)) {
    assert.ok(TOP_LEVEL_FIELDS.has(key), `unknown top-level field: ${key}`);
  }
});

test("appId equals agent.app.config.json backend.appId", () => {
  assert.equal(declaration.appId, appConfig.backend.appId);
});

test("every entry declares only known fields with valid shapes", () => {
  assert.ok(Array.isArray(declaration.declarations) && declaration.declarations.length > 0);
  for (const [index, entry] of declaration.declarations.entries()) {
    const where = `declarations[${index}]`;
    for (const key of Object.keys(entry)) {
      assert.ok(ENTRY_FIELDS.has(key), `${where}: unknown field ${key}`);
    }
    assert.match(entry.appResourceType, APP_RESOURCE_TYPE, `${where}: appResourceType`);
    assert.ok(RESOURCE_ID_KINDS.has(entry.appResourceIdKind), `${where}: appResourceIdKind`);
    assert.match(entry.scene, KEBAB_CASE, `${where}: scene`);
    assert.match(entry.source, KEBAB_CASE, `${where}: source`);
    assert.ok(!RESERVED_SCENES.has(entry.scene), `${where}: scene 'im' is reserved for Drive`);
    assert.ok(STANDARD_PROFILES.has(entry.uploadProfileCode), `${where}: uploadProfileCode`);
    assert.ok(RETENTION_MODES.has(entry.retention), `${where}: retention`);
    assert.ok(
      typeof entry.purpose === "string" && entry.purpose.length > 0,
      `${where}: purpose is required`,
    );
  }
});

test("temporary retention declares a positive TTL, long-term declares none", () => {
  for (const [index, entry] of declaration.declarations.entries()) {
    const where = `declarations[${index}]`;
    if (entry.retention === "temporary") {
      assert.ok(
        Number.isInteger(entry.retentionTtlSeconds) && entry.retentionTtlSeconds > 0,
        `${where}: temporary retention requires retentionTtlSeconds`,
      );
    } else {
      assert.equal(entry.retentionTtlSeconds, undefined, `${where}: TTL only for temporary`);
    }
  }
});

test("(appResourceType, scene, uploadProfileCode) triples are unique", () => {
  const seen = new Set();
  for (const entry of declaration.declarations) {
    const key = `${entry.appResourceType}|${entry.scene}|${entry.uploadProfileCode}`;
    assert.ok(!seen.has(key), `duplicate declaration triple: ${key}`);
    seen.add(key);
  }
});

test("appResourceType is namespaced by the application code", () => {
  for (const entry of declaration.declarations) {
    assert.ok(
      entry.appResourceType.startsWith(`${appConfig.app.capability}.`),
      `${entry.appResourceType} must be namespaced by '${appConfig.app.capability}.'`,
    );
  }
});