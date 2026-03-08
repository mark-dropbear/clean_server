# GEMINI.md - Project Context for `clean_server`

## Project Overview
`clean_server` is a Dart-based server application built with the `shelf` framework. It follows **Clean Architecture** principles to provide a maintainable and testable RESTful API for managing tasks and task lists, as well as server-side rendered (SSR) HTML pages.

### Main Technologies
- **Language**: Dart (SDK ^3.11.0)
- **Framework**: `shelf`, `shelf_router`, `shelf_static`
- **Dependency Injection**: `get_it`
- **Template Engine**: `mustache_template`
- **Data Serialization**: Extension-based `toMap` and top-level `fromMap` functions.
- **Testing**: `test`, `http`
- **Linting**: Custom strict configuration (see `analysis_options.yaml`).

## Architecture
The project is organized into layers to separate concerns:

- **`bin/`**: CLI entry point (`clean_server.dart`). Uses `developer.log` for instrumentation.
- **`lib/api/`**: Request handlers, routing logic, and rendering services.
  - `api_router.dart`: Centralized `Router` with static asset mounting at `/assets/`.
  - `task_list_handler.dart`: JSON logic for task list endpoints.
  - `task_handler.dart`: JSON logic for task endpoints.
  - `web_handler.dart`: Handler for SSR HTML pages.
  - `view_renderer.dart`: Centralized template/partial resolution and rendering.
- **`lib/domain/`**: Pure business logic (entities, use cases, repository interfaces).
  - `entities/`: `@immutable` models (using `package:meta`).
  - `use_cases/`: Orchestrate domain logic and handle existence/validation checks.
- **`lib/data/`**: Implementation details.
  - `repositories/`: In-memory implementations of domain interfaces.
  - `mappers/`: Mapping logic decoupled from entities via extensions.
- **`lib/di/`**: `service_locator.dart` manages dependency wiring with `GetIt`.
- **`web/`**: Assets and templates for the web frontend.

## Building and Running

### Commands
- **Run the Server**: `dart run bin/clean_server.dart`
- **Run Tests**: `dart test`
- **Static Analysis**: `dart analyze`
- **Format Code**: `dart format .`

## Development Conventions

### Web & Frontend Strategy
- **SSR**: Mustache templates in `web/templates/`. Partial resolution is handled by `ViewRenderer`.
- **Modern Frontend**: Native JS modules and `ImportMaps` (via shared partial). No build pipeline.
- **Security**: Mandatory HTML escaping in templates and explicit exception handling (`on Exception catch (e)`).

### Coding Style
- Follows the [Official Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Strict Linting**: The project uses a high-bar linting configuration. Always run `dart analyze` and `dart fix` before committing.
- **Documentation**: All public members must have concise `///` doc comments.
- **Logging**: Use `dart:developer`'s `log` function instead of `print` in production code.

### Key Patterns
- **Standardized Repositories**: Use consistent naming (e.g., `getById`, `save`, `delete`).
- **Use Case Responsibility**: Use cases are responsible for domain logic, including existence checks and throwing domain exceptions. Handlers focus on HTTP orchestration.
- **Immutability**: All domain entities are `@immutable`. Use `copyWith` for creating modified instances.
- **Data Mapping**: Mapping logic lives in the `data` layer. Entities are extended with `toMap()` for serialization, while top-level `fromMap` functions handle de-serialization.
