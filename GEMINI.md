# GEMINI.md - Project Context for `clean_server`

## Project Overview
`clean_server` is a Dart-based server application built with the `shelf` framework. It follows **Clean Architecture** principles within a **Feature-First** structure to provide a maintainable and testable RESTful API for managing tasks and task lists, as well as server-side rendered (SSR) HTML pages. It also features a "Contact Us" end-to-end implementation with built-in CSRF protection and an implementation of the official web platform **Reporting API** for receiving browser reports.

### Main Technologies
- **Language**: Dart (SDK ^3.11.0)
- **Framework**: `shelf`, `shelf_router`, `shelf_static`
- **Dependency Injection**: `get_it`
- **Template Engine**: `mustache_template`
- **Logging**: `package:logging` with hierarchical levels and stdout/stderr output.
- **Data Serialization**: Extension-based `toMap`, `toJsonLd` and top-level `fromMap` functions.
- **Frontend**: Lit components in a dedicated npm package (`web/frontend/`), integrated via native ESM and import maps (JSPM).
- **Testing**: `test`, `http`
- **Linting**: Custom strict configuration (see `analysis_options.yaml`).

## Architecture
The project is organized using a **Feature-First** approach with layered concerns inside each feature:

- **`bin/`**: CLI entry point (`clean_server.dart`). Initializes the logging system.
- **`lib/`**:
  - `app.dart`: Main application class and server setup.
  - `app_router.dart`: Centralized `AppRouter` with static asset mounting at `/frontend/`.
  - **`lib/core/`**: Shared infrastructure logic.
    - `exceptions.dart`: Centralized domain exceptions.
    - `logging.dart`: Logger configuration.
    - `view_renderer.dart`: Centralized template/partial resolution and rendering. (Injects CSRF tokens and CSP nonces).
    - **`lib/core/middleware/`**: Shared middleware logic (`csrf_protection.dart`, `csp_protection.dart`, `reporting_headers.dart`, `url_normalization.dart`).
    - **`lib/features/`**: Business functionality grouped by feature.
    - **`reporting/`**: Logic for browser reporting via the official Reporting API.
      - `domain/`: `Report` base class and a comprehensive suite of entities (e.g., `DeprecationReport`, `CrashReport`, `CspViolationReport`, `NetworkErrorReport`), Use Case, and Repository interface.
      - `data/`: In-memory Repository and Mapper.
      - `presentation/`: `ReportHandler`.
    - **`tasks/`**: Logic for managing tasks and task lists.
      - `domain/`: Entities (`task.dart`, `task_list.dart`), Use Cases, and Repository interfaces.
      - `data/`: In-memory Repositories and Mappers.
      - `presentation/`: `TaskHandler` and `TaskListHandler`.
    - **`feedback/`**: Logic for processing user feedback.
      - `domain/`: `FeedbackForm` entity, Use Case, and Repository interface.
      - `data/`: In-memory Repository and Mapper.
      - `presentation/`: `FeedbackHandler`.
    - **`pages/`**: Logic for server-side rendered pages.
      - `presentation/`: `WebHandler`.
  - **`lib/di/`**: `service_locator.dart` manages dependency wiring with `GetIt`.
- **`web/`**: Assets, templates, and frontend source code.
  - `templates/`: SSR Mustache templates.
  - `frontend/`: Lit components and frontend assets.

## Building and Running

### Commands
- **Run the Server**: `dart run bin/clean_server.dart`
  - Use `--verbose` or `-v` to set the log level to `ALL` (includes request logs and database access).
  - Default log level is `INFO`.
- **Build Frontend**:
  - `cd web/frontend && npm install`
  - Development: `npm run build:dev`
  - Production: `npm run build:prod`
- **Run Tests**: `dart test`
  - To generate a coverage report: `dart test --coverage=coverage/`
- **Static Analysis**: `dart analyze`
- **Format Code**: `dart format .`

## Development Conventions

### Feature-First Organization
- Always group new functionality into a dedicated feature folder under `lib/features/`.
- Maintain the layered structure (`domain`, `data`, `presentation`) within each feature.
- Shared cross-cutting concerns (e.g., auth, global models) belong in `lib/core/`.

### Testing Strategy
- **Layered Coverage**: The project maintains comprehensive test coverage across all features and layers, mirrored in the `test/` directory.
- **Organization**: Tests are organized by feature (e.g., `test/features/tasks/`) and then by layer (`domain`, `data`, `presentation`).
- **In-Memory Dependencies**: Tests leverage real in-memory repository implementations instead of mocks for speed and reliability.
- **Direct Handler Testing**: API handlers are tested by passing `shelf.Request` objects directly.
- **Integration Tests**: Feature-level and app-level integration tests reside in their respective feature folders or the root of `test/`.

### JSON-LD Support
- Entities support JSON-LD serialization via `toJsonLd()` extension methods mapping to Schema.org types (e.g., `ItemList`, `Action`, `Message`).

### Security
- Mandatory HTML escaping in templates.
- **CSRF Protection**: Double Submit Cookie pattern (`csrf_protection.dart`).
- **CSP Protection**: Nonce-based Strict Content Security Policy (`csp_protection.dart`). Nonces are injected into templates via `ViewRenderer`.
- **Reporting & Monitoring**: Extensive use of the W3C Reporting API (`reporting_headers.dart`) to collect telemetry on CSP violations, Network Error Logging (NEL), Permissions Policy, and Document Policy violations without breaking functionality (using `-Report-Only` headers).

### Logging Strategy
- Use `package:logging`.
- `INFO`: Significant events.
- `WARNING`: Handled errors (404s).
- `SEVERE`: Unhandled exceptions.
- `FINE`/`FINEST`: Tracing (SQL, middleware).

### Coding Style
- Follows the [Official Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Strict Linting**: High-bar configuration. Run `dart analyze` and `dart fix` before committing.
