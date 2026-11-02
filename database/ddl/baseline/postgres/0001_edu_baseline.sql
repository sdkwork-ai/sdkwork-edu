-- SDKWork Edu consolidated initialization baseline (postgres)
--
-- Strategy: baseline-plus-migrations (database.manifest.json).
-- This file is the full initialization DDL. `migrations/postgres/` is reserved
-- for post-GA deltas.
--
-- Wire contract notes:
--   * identity columns (id / tenant_id / organization_id / *_id) are BIGINT
--     snowflake values, never serial; the API exposes them as int64 strings.
--   * timestamps are TIMESTAMPTZ, UTC, server-owned.
--   * Drive-owned files are referenced by drive_space_id + drive_node_id +
--     drive_uri; no bucket, object key, or presigned URL is ever stored.

CREATE TABLE IF NOT EXISTS edu_term (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  academic_year TEXT NOT NULL,
  term_no INTEGER NOT NULL DEFAULT 1,
  starts_on DATE NOT NULL,
  ends_on DATE NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_term_code UNIQUE (tenant_id, organization_id, code)
);
CREATE INDEX IF NOT EXISTS idx_edu_term_scope ON edu_term (tenant_id, organization_id, status);

CREATE TABLE IF NOT EXISTS edu_student (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  student_no TEXT NOT NULL,
  display_name TEXT NOT NULL,
  gender TEXT,
  birth_date DATE,
  guardian_name TEXT,
  guardian_phone TEXT,
  avatar_snapshot_json JSONB,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_student_no UNIQUE (tenant_id, organization_id, student_no)
);
CREATE INDEX IF NOT EXISTS idx_edu_student_scope ON edu_student (tenant_id, organization_id, status);

CREATE TABLE IF NOT EXISTS edu_teacher (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  teacher_no TEXT NOT NULL,
  user_id BIGINT,
  display_name TEXT NOT NULL,
  title TEXT,
  subjects_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  avatar_snapshot_json JSONB,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_teacher_no UNIQUE (tenant_id, organization_id, teacher_no)
);
CREATE INDEX IF NOT EXISTS idx_edu_teacher_scope ON edu_teacher (tenant_id, organization_id, status);

CREATE TABLE IF NOT EXISTS edu_class (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  term_id BIGINT NOT NULL,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  subject TEXT,
  grade_level TEXT,
  head_teacher_id BIGINT,
  capacity INTEGER NOT NULL DEFAULT 0,
  cover_snapshot_json JSONB,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_class_code UNIQUE (tenant_id, organization_id, term_id, code)
);
CREATE INDEX IF NOT EXISTS idx_edu_class_term ON edu_class (tenant_id, organization_id, term_id, status);
CREATE INDEX IF NOT EXISTS idx_edu_class_head_teacher ON edu_class (head_teacher_id);

CREATE TABLE IF NOT EXISTS edu_class_member (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  class_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  member_role TEXT NOT NULL DEFAULT 'student',
  joined_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_class_member UNIQUE (tenant_id, organization_id, class_id, student_id)
);
CREATE INDEX IF NOT EXISTS idx_edu_class_member_student ON edu_class_member (tenant_id, organization_id, student_id);

CREATE TABLE IF NOT EXISTS edu_enrollment (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  student_id BIGINT NOT NULL,
  class_id BIGINT NOT NULL,
  term_id BIGINT NOT NULL,
  source TEXT,
  note TEXT,
  applied_at TIMESTAMPTZ NOT NULL,
  decided_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_enrollment UNIQUE (tenant_id, organization_id, student_id, class_id)
);
CREATE INDEX IF NOT EXISTS idx_edu_enrollment_status ON edu_enrollment (tenant_id, organization_id, status, applied_at);

CREATE TABLE IF NOT EXISTS edu_schedule (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  class_id BIGINT NOT NULL,
  term_id BIGINT NOT NULL,
  teacher_id BIGINT,
  weekday SMALLINT NOT NULL,
  starts_at TIME NOT NULL,
  ends_at TIME NOT NULL,
  room TEXT,
  effective_from DATE,
  effective_to DATE,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT
);
CREATE INDEX IF NOT EXISTS idx_edu_schedule_class ON edu_schedule (tenant_id, organization_id, class_id, weekday);
CREATE INDEX IF NOT EXISTS idx_edu_schedule_teacher ON edu_schedule (tenant_id, organization_id, teacher_id);

CREATE TABLE IF NOT EXISTS edu_attendance (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  schedule_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  attendance_status TEXT NOT NULL,
  checked_at TIMESTAMPTZ NOT NULL,
  checked_by BIGINT,
  remark TEXT,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_attendance UNIQUE (tenant_id, organization_id, schedule_id, student_id, checked_at)
);
CREATE INDEX IF NOT EXISTS idx_edu_attendance_student ON edu_attendance (tenant_id, organization_id, student_id, checked_at);

CREATE TABLE IF NOT EXISTS edu_leave_request (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  student_id BIGINT NOT NULL,
  schedule_id BIGINT,
  reason TEXT NOT NULL,
  starts_on DATE NOT NULL,
  ends_on DATE NOT NULL,
  evidence_snapshot_json JSONB,
  decided_by BIGINT,
  decided_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT
);
CREATE INDEX IF NOT EXISTS idx_edu_leave_request_student ON edu_leave_request (tenant_id, organization_id, student_id, status);

CREATE TABLE IF NOT EXISTS edu_assessment (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  class_id BIGINT NOT NULL,
  name TEXT NOT NULL,
  assessment_kind TEXT NOT NULL,
  held_on DATE,
  full_score NUMERIC(10, 2) NOT NULL DEFAULT 100,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT
);
CREATE INDEX IF NOT EXISTS idx_edu_assessment_class ON edu_assessment (tenant_id, organization_id, class_id, status, held_on);

CREATE TABLE IF NOT EXISTS edu_score (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  assessment_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  score NUMERIC(10, 2),
  grade TEXT,
  rank_no INTEGER,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_score UNIQUE (tenant_id, organization_id, assessment_id, student_id)
);
CREATE INDEX IF NOT EXISTS idx_edu_score_student ON edu_score (tenant_id, organization_id, student_id);

CREATE TABLE IF NOT EXISTS edu_assignment (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  class_id BIGINT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  due_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT
);
CREATE INDEX IF NOT EXISTS idx_edu_assignment_class ON edu_assignment (tenant_id, organization_id, class_id, status, due_at);

CREATE TABLE IF NOT EXISTS edu_submission (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  assignment_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  submitted_at TIMESTAMPTZ,
  attachment_snapshot_json JSONB,
  score NUMERIC(10, 2),
  feedback TEXT,
  graded_by BIGINT,
  graded_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT,
  CONSTRAINT uq_edu_submission UNIQUE (tenant_id, organization_id, assignment_id, student_id)
);
CREATE INDEX IF NOT EXISTS idx_edu_submission_student ON edu_submission (tenant_id, organization_id, student_id, status);

CREATE TABLE IF NOT EXISTS edu_material (
  id BIGINT PRIMARY KEY,
  tenant_id BIGINT NOT NULL,
  organization_id BIGINT NOT NULL DEFAULT 0,
  class_id BIGINT NOT NULL,
  title TEXT NOT NULL,
  drive_space_id TEXT NOT NULL,
  drive_node_id TEXT NOT NULL,
  drive_uri TEXT NOT NULL,
  mime_type TEXT,
  size_bytes BIGINT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  created_by BIGINT,
  updated_at TIMESTAMPTZ NOT NULL,
  updated_by BIGINT,
  version INTEGER NOT NULL DEFAULT 0,
  deleted_at TIMESTAMPTZ,
  deleted_by BIGINT
);
CREATE INDEX IF NOT EXISTS idx_edu_material_class ON edu_material (tenant_id, organization_id, class_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_edu_material_drive_node ON edu_material (drive_node_id);