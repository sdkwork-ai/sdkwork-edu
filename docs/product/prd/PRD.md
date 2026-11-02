# SDKWork Edu - Product Requirements

- Status: Draft for bootstrap
- Owner: sdkwork-edu
- Version: 0.1.0
- Related: [Technical Architecture](../../architecture/tech/TECH_ARCHITECTURE.md)
- Requirement standard: `../sdkwork-specs/REQUIREMENTS_SPEC.md`
- Requirement records: `../requirements/` (`REQ-YYYY-MM-DD-*.md`)

## 1. Problem

Education providers run their academic operations on spreadsheets and disconnected tools:
term setup, class rosters, enrollment, timetables, attendance, assessments, assignments and
teaching materials each live in a different place. The result is duplicated records,
reconciled-by-hand grades, and no reliable answer to "who attended what, and what were they
taught".

SDKWork Edu is the administrative system of record for that operation, built on the SDKWork
platform so identity, storage and integration behaviour are inherited rather than rebuilt.

## 2. Users

| Persona | Needs | Primary surface |
| --- | --- | --- |
| Education administrator | Set up terms and classes, enroll students, schedule teaching, publish results | `backend-api` console |
| Teacher | See the timetable, take attendance, publish assessments and assignments, share materials | PC and H5 |
| Student | See classes, timetable, assignments and scores; submit work | H5 first |
| Guardian | Follow attendance, assignments and scores | H5 |

## 3. Scope (0.1.0)

In scope:

1. **Terms** - academic year and term lifecycle.
2. **Classes** - class identity, roster, head teacher, capacity.
3. **Students and teachers** - tenant-scoped profiles and status.
4. **Enrollment** - application, decision and class assignment.
5. **Scheduling** - weekly timetable per class with teacher and room.
6. **Attendance** - per-session attendance and leave requests.
7. **Assessments and scores** - assessment definition, score entry and publication.
8. **Assignments** - assignment definition, student submission, grading.
9. **Materials** - teaching material attachments stored in SDKWork Drive.

Out of scope for 0.1.0 (owned elsewhere):

- Identity, tenant, organization, roles, permissions: `sdkwork-iam`.
- File bytes, upload sessions, download grants: `sdkwork-drive`.
- Payments, refunds, invoices: commerce domain.
- Chat, notifications, announcements: communication domain.
- Course catalog and learning-content authoring: `sdkwork-course`.

## 4. Capability Map

| Capability | Aggregates | Tables |
| --- | --- | --- |
| `term` | Term | `edu_term` |
| `class` | Class, ClassMember | `edu_class`, `edu_class_member` |
| `student` | Student | `edu_student` |
| `teacher` | Teacher | `edu_teacher` |
| `enrollment` | Enrollment | `edu_enrollment` |
| `schedule` | Schedule | `edu_schedule` |
| `attendance` | Attendance, LeaveRequest | `edu_attendance`, `edu_leave_request` |
| `assessment` | Assessment, Score | `edu_assessment`, `edu_score` |
| `assignment` | Assignment, Submission | `edu_assignment`, `edu_submission` |
| `material` | Material | `edu_material` |

## 5. Requirements

| ID | Requirement | Verification |
| --- | --- | --- |
| R1 | An administrator can create a term, create classes in it, and enroll students. | Backend contract test |
| R2 | A teacher sees only the classes they teach; a student sees only their own classes. | Authorization test per tier |
| R3 | Attendance is recorded per scheduled session and is immutable once the day is closed. | Repository + route test |
| R4 | Scores are invisible to students until published. | Route test on publication state |
| R5 | Every uploaded file lives in Drive; the application stores only `drive_node_id`. | `check-upload-declaration-standard` |
| R6 | Every list endpoint paginates at the store; no in-memory slicing. | `check-pagination` |
| R7 | Every identifier is a string on the wire, never a JS number. | `check-api-operation-patterns` |
| R8 | A standalone deployment serves PC, H5 and both APIs from one ingress. | `check-single-http-ingress` |

## 6. Success Criteria

- 0.1.0 ships with all 22 workspace gates and the application gate bundle green.
- An administrator completes the R1 flow on a clean database with seeded profiles.
- No application-owned object storage, upload session, or file URL column exists.