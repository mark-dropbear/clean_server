# Modification Implementation: Reporting API

This plan outlines the steps to implement the Reporting API (Deprecation Reports) in the `clean_server` project.

## Journal

| Date | Phase | Notes |
| :--- | :--- | :--- |
| 2026-03-08 | Initial | Plan created and approved. |
| 2026-03-08 | Phase 1 | Existing tests passed. |
| 2026-03-08 | Phase 2 | Implemented domain layer entities, repository interface, and use case. Fixed inference issues in tests. |
| 2026-03-08 | Phase 3 | Implemented data layer mappers and in-memory repository. Added unit tests. |
| 2026-03-08 | Phase 4 | Implemented presentation layer handler. Added unit tests. |
| 2026-03-08 | Phase 5 | Modified CSRF middleware to exclude reporting paths. Wired up dependencies in service locator and router. Added integration tests. |
| 2026-03-08 | Phase 6 | Updated README.md and GEMINI.md. Final test run passed. Manually verified with curl request. Removed manual test trigger from frontend. |
| 2026-03-08 | Refactor | Plan to refactor to a single 'default' reporting endpoint. |

## Phases

### Phase 1: Preparation & Verification
- [x] Run all existing tests to ensure the project is in a good state.
  - `dart test`
- [x] Verify the current git branch is `feature/reporting-api`.

### Phase 2: Domain Layer Implementation
- [x] Create `lib/features/reporting/domain/entities/report.dart` (Base class).
- [x] Create `lib/features/reporting/domain/entities/deprecation_report.dart`.
- [x] Create `lib/features/reporting/domain/repositories/report_repository.dart` (Interface).
- [x] Create `lib/features/reporting/domain/use_cases/submit_deprecation_reports.dart`.
- [x] **Validation**:
  - [x] Create unit tests for `DeprecationReport` entity and `SubmitDeprecationReports` use case.
  - [x] Run `dart_fix --apply`.
  - [x] Run `dart analyze`.
  - [x] Run `dart test`.
  - [x] Run `dart format .`.
  - [x] Update Journal and commit changes.

### Phase 3: Data Layer Implementation
- [x] Create `lib/features/reporting/data/mappers/report_mapper.dart`.
- [x] Create `lib/features/reporting/data/repositories/in_memory_report_repository.dart`.
- [x] **Validation**:
  - [x] Create unit tests for `ReportMapper` and `InMemoryReportRepository`.
  - [x] Run `dart_fix --apply`.
  - [x] Run `dart analyze`.
  - [x] Run `dart test`.
  - [x] Run `dart format .`.
  - [x] Update Journal and commit changes.

### Phase 4: Presentation Layer Implementation
- [x] Create `lib/features/reporting/presentation/handlers/report_handler.dart`.
  - Implement `handleDeprecation` method.
  - Add logic to parse `application/reports+json` (JSON array).
- [x] **Validation**:
  - [x] Create unit tests for `ReportHandler`.
  - [x] Run `dart_fix --apply`.
  - [x] Run `dart analyze`.
  - [x] Run `dart test`.
  - [x] Run `dart format .`.
  - [x] Update Journal and commit changes.

### Phase 5: Infrastructure & Wiring
- [x] Modify `lib/core/middleware/csrf_protection.dart` to exclude paths starting with `/_reports/`.
- [x] Update `lib/di/service_locator.dart` to register reporting dependencies:
  - `ReportRepository` (InMemory)
  - `SubmitDeprecationReports` (Use Case)
  - `ReportHandler`
- [x] Update `lib/app_router.dart` to include the `POST /_reports/deprecation` route.
- [x] Update `lib/app.dart` to pass the new `ReportHandler` to `AppRouter`.
- [x] **Validation**:
  - [x] Create integration tests for the new endpoint `POST /_reports/deprecation`.
  - [x] Run `dart_fix --apply`.
  - [x] Run `dart analyze`.
  - [x] Run `dart test`.
  - [x] Run `dart format .`.
  - [x] Update Journal and commit changes.

### Phase 6: Finalization & Refactoring
- [x] Update `README.md` if necessary with information about the Reporting API.
- [x] Update `GEMINI.md` to reflect the new feature and project structure.
- [ ] Refactor Reporting API to use a single `/_reports/default` endpoint.
  - [ ] Rename/Update `SubmitDeprecationReports` to `SubmitReports`.
  - [ ] Use pattern matching in Use Case or Handler to support multiple report types.
  - [ ] Update `AppRouter` and `ReportingHeaders` middleware.
  - [ ] Update all tests to use the new endpoint and generic use case.
- [ ] Run all tests one last time.
- [ ] Ask the user to inspect the implementation and verify satisfaction.

---

**Note**: After completing each phase, ensure all `TODO`s are resolved or tracked as new tasks. Update the implementation plan with any learnings or deviations in the Journal section.
