# GEMINI.md - Project Context for `clean_server`

## Project Overview
`clean_server` is a Dart-based server application built with the `shelf` framework. It follows **Clean Architecture** principles to provide a maintainable and testable RESTful API for managing tasks and task lists, as well as server-side rendered (SSR) HTML pages.

### Main Technologies
- **Language**: Dart (SDK ^3.11.0)
- **Framework**: `shelf`, `shelf_router`, `shelf_static`
- **Dependency Injection**: `get_it`
- **Template Engine**: `mustache_template`
- **Data Serialization**: Manual mapping with `Mappers`
- **Testing**: `test`, `http`
- **Linting**: `lints/recommended`

## Architecture
The project is organized into layers to separate concerns:

- **`bin/`**: The application entry point (`clean_server.dart`), which handles CLI argument parsing (port, verbose logging) and initializes the `App`.
- **`lib/api/`**: Contains the `shelf` request handlers, routing logic, and rendering services.
  - `api_router.dart`: Centralized `Router` that wires all endpoints, including static asset serving at `/assets/`.
  - `task_list_handler.dart`: Decoupled logic for task list endpoints.
  - `task_handler.dart`: Decoupled logic for task endpoints.
  - `web_handler.dart`: Handler for HTML pages.
  - `view_renderer.dart`: Service that encapsulates template loading, partial resolution, and rendering using Mustache.
- **`lib/domain/`**: The core business logic, independent of external frameworks.
  - `entities/`: Core data models (e.g., `Task`, `TaskList`).
  - `use_cases/`: Specific business actions (e.g., `CreateTask`, `GetTaskList`).
  - `repositories/`: Abstract interfaces for data persistence.
  - `exceptions.dart`: Custom domain-specific exceptions.
- **`lib/data/`**: Implementation details of the domain layer.
  - `repositories/`: In-memory implementations of the repository interfaces.
  - `mappers/`: Logic for converting between domain entities and Map/JSON structures.
- **`lib/di/`**: `service_locator.dart` defines how dependencies are wired together using `GetIt`.
- **`web/`**: Contains assets and templates for the web front end.
  - `assets/`: Static files (CSS, JS) served at `/assets/`. Uses **ImportMaps** for modern module resolution without a build pipeline.
  - `templates/`: Mustache templates for SSR. Includes a `partials/` subdirectory for reusable components.

## Building and Running

### Commands
- **Run the Server**: `dart run bin/clean_server.dart`
  - *Defaults to port 8080.*
  - *Use `--port <port>` to change the port.*
  - *Use `--verbose" or `-v` for request logging.*
- **Run Tests**: `dart test`
- **Static Analysis**: `dart analyze`
- **Format Code**: `dart format .`

### Dependencies
Dependencies are managed via `pubspec.yaml`. Run `dart pub get` to install them.

## Development Conventions

### Web & Frontend Strategy
- **Server-Side Rendering (SSR)**: Use Mustache templates located in `web/templates/`. Prefer partials for shared components like the `importmap`.
- **Modern Frontend**: No front-end build pipeline is used. Use native JavaScript modules and `ImportMaps` (located in a shared partial) to manage dependencies.
- **Security**: Templates default to `htmlEscapeValues: true` in the `ViewRenderer` to prevent XSS.

### Coding Style
- Follows the [Official Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Naming**: `PascalCase` for classes, `camelCase` for variables/methods, `snake_case` for files.
- **Lints**: Adheres to `package:lints/recommended.yaml`.

### Testing Practices
- **Domain Tests**: Located in `test/domain/`, focusing on entities and use case logic.
- **API Tests**: Located in `test/api/`, using `http` to perform end-to-end integration tests against the running or mocked handlers. Includes tests for HTML rendering and static asset delivery.

### Key Patterns
- **Dependency Injection**: All handlers, services (like `ViewRenderer`), use cases, and repositories should be registered in `lib/di/service_locator.dart` and accessed via `getIt<T>()`.
- **Routing**: Centralized routing in `ApiRouter` using flat, explicit parameters. Static files are mounted at `/assets/`.
- **Error Handling**: 
    - API: Throw domain-specific exceptions in use cases and catch them in handlers to return HTTP status codes.
    - Web: Handlers catch rendering errors and display a custom `error_500.mustache` page.
- **Immutability**: Domain entities should generally be immutable (final fields) where possible.
