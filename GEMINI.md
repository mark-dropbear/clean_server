# GEMINI.md - Project Context for `clean_server`

## Project Overview
`clean_server` is a Dart-based server application built with the `shelf` framework. It follows **Clean Architecture** principles to provide a maintainable and testable RESTful API for managing tasks and task lists.

### Main Technologies
- **Language**: Dart (SDK ^3.11.0)
- **Framework**: `shelf`, `shelf_router`
- **Dependency Injection**: `get_it`
- **Data Serialization**: Manual mapping with `Mappers`
- **Testing**: `test`, `http`
- **Linting**: `lints/recommended`

## Architecture
The project is organized into layers to separate concerns:

- **`bin/`**: The application entry point (`clean_server.dart`), which handles CLI argument parsing (port, verbose logging) and initializes the `App`.
- **`lib/api/`**: Contains the `shelf` request handlers and routing logic.
  - `api_router.dart`: Centralized `Router` that wires all endpoints.
  - `task_list_handler.dart`: Decoupled logic for task list endpoints.
  - `task_handler.dart`: Decoupled logic for task endpoints.
- **`lib/domain/`**: The core business logic, independent of external frameworks.
  - `entities/`: Core data models (e.g., `Task`, `TaskList`).
  - `use_cases/`: Specific business actions (e.g., `CreateTask`, `GetTaskList`).
  - `repositories/`: Abstract interfaces for data persistence.
  - `exceptions.dart`: Custom domain-specific exceptions.
- **`lib/data/`**: Implementation details of the domain layer.
  - `repositories/`: In-memory implementations of the repository interfaces.
  - `mappers/`: Logic for converting between domain entities and Map/JSON structures.
- **`lib/di/`**: `service_locator.dart` defines how dependencies are wired together using `GetIt`.

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

### Coding Style
- Follows the [Official Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Naming**: `PascalCase` for classes, `camelCase` for variables/methods, `snake_case` for files.
- **Lints**: Adheres to `package:lints/recommended.yaml`.

### Testing Practices
- **Domain Tests**: Located in `test/domain/`, focusing on entities and use case logic.
- **API Tests**: Located in `test/api/`, using `http` to perform end-to-end integration tests against the running or mocked handlers.

### Key Patterns
- **Dependency Injection**: All handlers, use cases, and repositories should be registered in `lib/di/service_locator.dart` and accessed via `getIt<T>()`.
- **Routing**: Centralized routing in `ApiRouter` using flat, explicit parameters (e.g., `<taskListId>`).
- **Error Handling**: Throw domain-specific exceptions (from `lib/domain/exceptions.dart`) in use cases and catch them in the `api/` handlers to return appropriate HTTP status codes.
- **Immutability**: Domain entities should generally be immutable (final fields) where possible.
