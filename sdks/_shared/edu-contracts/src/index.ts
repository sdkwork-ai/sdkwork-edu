/**
 * Handwritten, cross-client contract helpers for SDKWork Edu.
 *
 * Only pure types and constant maps belong here: no transport, no SDK client and no
 * React. Runtime behaviour belongs to the composed SDK families.
 */

/** Application code used in route prefixes, permissions and storage keys. */
export const EDU_APPLICATION_CODE = "edu" as const;

/** Locked HTTP surface prefixes (API_SPEC.md section 6). */
export const EDU_API_PREFIXES = {
  app: "/app/v3/api",
  backend: "/backend/v3/api",
} as const;

/** Capabilities owned by this application. */
export const EDU_CAPABILITIES = [
  "term",
  "class",
  "student",
  "teacher",
  "enrollment",
  "schedule",
  "attendance",
  "assessment",
  "assignment",
  "material",
] as const;

export type EduCapability = (typeof EDU_CAPABILITIES)[number];

/** Drive upload declaration triple, mirrored from `specs/upload.declaration.json`. */
export interface EduUploadTarget {
  readonly appResourceType: string;
  readonly scene: string;
  readonly source: string;
  readonly uploadProfileCode: string;
}

/** Upload targets; every value must exist in `specs/upload.declaration.json`. */
export const EDU_UPLOAD_TARGETS = {
  material: {
    appResourceType: "edu.material",
    scene: "material",
    source: "edu-material",
    uploadProfileCode: "document",
  },
  submission: {
    appResourceType: "edu.submission",
    scene: "homework",
    source: "edu-assignment",
    uploadProfileCode: "attachment",
  },
  avatar: {
    appResourceType: "edu.avatar",
    scene: "avatar",
    source: "edu-profile",
    uploadProfileCode: "avatar",
  },
  cover: {
    appResourceType: "edu.cover",
    scene: "cover",
    source: "edu-class",
    uploadProfileCode: "image",
  },
  evidence: {
    appResourceType: "edu.evidence",
    scene: "leave-proof",
    source: "edu-attendance",
    uploadProfileCode: "image",
  },
} as const satisfies Record<string, EduUploadTarget>;