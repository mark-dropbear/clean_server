# Modification Implementation: Reporting API

This plan outlines the steps to implement the Reporting API (Deprecation Reports) in the `clean_server` project.

## Journal

| Date | Phase | Notes |
| :--- | :--- | :--- |
| 2026-03-08 | Initial | Plan created and approved. |
| 2026-03-08 | Phase 1 | Existing tests passed. |
| 2026-03-08 | Phase 2 | Implemented domain layer entities, repository interface, and use case. Fixed inference issues in tests. |
| 2026-03-08 | Phase 3 | Implemented data layer mappers and in-memory repository. Added unit tests. |

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
- [ ] Create `lib/features/reporting/presentation/handlers/report_handler.dart`.
  - Implement `handleDeprecation` method.
  - Add logic to parse `application/reports+json` (JSON array).
- [ ] **Validation**:
  - [ ] Create unit tests for `ReportHandler`.
  - [ ] Run `dart_fix --apply`.
  - [ ] Run `dart analyze`.
  - [ ] Run `dart test`.
  - [ ] Run `dart format .`.
  - [ ] Update Journal and commit changes.

### Phase 5: Infrastructure & Wiring
- [ ] Modify `lib/core/middleware/csrf_protection.dart` to exclude paths starting with `/_reports/`.
- [ ] Update `lib/di/service_locator.dart` to register reporting dependencies:
  - `ReportRepository` (InMemory)
  - `SubmitDeprecationReports` (Use Case)
  - `ReportHandler`
- [ ] Update `lib/app_router.dart` to include the `POST /_reports/deprecation` route.
- [ ] Update `lib/app.dart` to pass the new `ReportHandler` to `AppRouter`.
- [ ] **Validation**:
  - [ ] Create integration tests for the new endpoint `POST /_reports/deprecation`.
  - [ ] Run `dart_fix --apply`.
  - [ ] Run `dart analyze`.
  - [ ] Run `dart test`.
  - [ ] Run `dart format .`.
  - [ ] Update Journal and commit changes.

### Phase 6: Finalization
- [ ] Update `README.md` if necessary with information about the Reporting API.
- [ ] Update `GEMINI.md` to reflect the new feature and project structure.
- [ ] Run all tests one last time.
- [ ] Ask the user to inspect the implementation and verify satisfaction.

---

**Note**: After completing each phase, ensure all `TODO`s are resolved or tracked as new tasks. Update the implementation plan with any learnings or deviations in the Journal section.
