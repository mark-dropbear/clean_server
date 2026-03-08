# GEMINI.md - Project Context for `clean_server`

## Project Overview
`clean_server` is a Dart-based server application built with the `shelf` framework. It follows **Clean Architecture** principles to provide a maintainable and testable RESTful API for managing tasks and task lists, as well as server-side rendered (SSR) HTML pages.

### Main Technologies
- **Language**: Dart (SDK ^3.11.0)
- **Framework**: `shelf`, `shelf_router`, `shelf_static`
- **Dependency Injection**: `get_it`
- **Template Engine**: `mustache_template`
- **Logging**: `package:logging` with hierarchical levels and stdout/stderr output.
- **Data Serialization**: Extension-based `toMap`, `toJsonLd` and top-level `fromMap` functions.
- **Frontend**: Lit components in a dedicated npm package (`frontend/`), integrated via native ESM and import maps (JSPM).
- **Testing**: `test`, `http`
- **Linting**: Custom strict configuration (see `analysis_options.yaml`).

## Architecture
The project is organized into layers to separate concerns:

- **`bin/`**: CLI entry point (`clean_server.dart`). Initializes the logging system.
- **`lib/api/`**: Request handlers, routing logic, and rendering services.
  - `api_router.dart`: Centralized `Router` with static asset mounting at `/assets/` and `/frontend/`.
  - `task_list_handler.dart`: JSON logic for task list endpoints.
  - `task_handler.dart`: JSON logic for task endpoints.
  - `web_handler.dart`: Handler for SSR HTML pages.
  - `view_renderer.dart`: Centralized template/partial resolution and rendering.
- **`lib/domain/`**: Pure business logic (entities, use cases, repository interfaces).
  - `entities/`: `@immutable` models (using `package:meta`).
  - `use_cases/`: Orchestrate domain logic and handle existence/validation checks.
- **`lib/data/`**: Implementation details.
  - `repositories/`: In-memory implementations of domain interfaces.
  - `mappers/`: Mapping logic decoupled from entities via extensions. Supports standard JSON and JSON-LD (Schema.org).
- **`lib/di/`**: `service_locator.dart` manages dependency wiring with `GetIt`.
- **`lib/core/`**: Shared infrastructure logic like logging.
- **`web/`**: Assets and templates for the web frontend.
- **`frontend/`**: Dedicated npm package for frontend components.
  - `src/`: Source JS/CSS files for Lit components.
  - `dist/`: Generated assets and dynamic import map (`importmap.js`).

## Building and Running

### Commands
- **Run the Server**: `dart run bin/clean_server.dart`
  - Use `--verbose` or `-v` to set the log level to `ALL` (includes request logs and database access).
  - Default log level is `INFO`.
- **Build Frontend**:
  - `cd frontend && npm install`
  - Development: `npm run build:dev`
  - Production: `npm run build:prod`
- **Run Tests**: `dart test`
  - To generate a coverage report: `dart test --coverage=coverage/`
- **Static Analysis**: `dart analyze`
- **Format Code**: `dart format .`

## Development Conventions

### Testing Strategy
- **Layered Coverage**: The project maintains comprehensive test coverage across all Clean Architecture layers:
  - **Domain**: Unit tests for entities (`test/domain/entities/`) and use cases (`test/domain/use_cases/`).
  - **Data**: Unit tests for mappers (`test/data/mappers/`) and repository implementations (`test/data/repositories/`).
  - **API**: Integration-style unit tests for handlers (`test/api/`) and the central router.
- **In-Memory Dependencies**: Tests leverage real in-memory repository implementations instead of mocks for speed and reliability.
- **Direct Handler Testing**: API handlers are tested by passing `shelf.Request` objects directly, verifying logic and routing without the overhead of a real HTTP server.

### JSON-LD Support
- **Schema.org Integration**: Entities support JSON-LD serialization via `toJsonLd()` extension methods.
- **Mapping**:
  - `TaskList` $\rightarrow$ `https://schema.org/ItemList`
  - `Task` $\rightarrow$ `https://schema.org/Action`
- **Context**: All JSON-LD outputs include the `@context: https://schema.org`.

### Frontend Development (Lit & JSPM)
- **Component Development**: Build UI components using **Lit** in the `frontend/` directory.
- **Import Maps**: The project uses **JSPM** to automatically generate a dynamic import map (`importmap.js`). This script is loaded in templates to resolve bare specifiers like `lit` and `frontend` at runtime.
- **Integration**: The server mounts `frontend/dist/` to serve these assets. Components are loaded in templates using standard ESM `import` statements.

### Global and Page Components
- **Global App Container**: The `<app-container>` Lit component handles global concerns (e.g., auth, theme, progressive enhancement) and is present on all pages.
- **Page Components**: Each page has a dedicated Lit component (e.g., `<home-page>`, `<demo-page>`) that handles page-specific logic, event handlers, and importing page specific CSS and JavaScript modules.
- **Progressive Enhancement**: The `<app-container>` updates the `data-js` attribute on the `<body>` tag to `true` upon initialization, signaling that JavaScript is active.

### Web & Frontend Strategy
- **SSR**: Mustache templates in `web/templates/`. Partial resolution is handled by `ViewRenderer`.
- **Modern Frontend**: Native JS modules and dynamic `ImportMaps` (via shared partial). No heavy build pipeline for production delivery.
- **Security**: Mandatory HTML escaping in templates and explicit exception handling (`on Exception catch (e, st)`).

### Logging Strategy
- **Library**: Always use `package:logging`. Initialize it via `initLogging()` in the entry point.
- **Levels**:
  - `INFO`: Significant application events (server start, creation of resources).
  - `WARNING`: Handled errors or missing resources (404s).
  - `SEVERE`: Unhandled exceptions or critical failures (500s).
  - `FINE`/`FINEST`: Detailed tracing for debugging (SQL/Data access, URL normalization, template loading).
- **Format**: Logs are timestamped and include the logger name and level.
- **Output**:
  - Levels below `WARNING` go to `stdout`.
  - `WARNING` and above go to `stderr`.
- **Usage**:
  ```dart
  static final _logger = Logger('MyClassName');
  _logger.info('Something happened');
  _logger.severe('Critical error', error, stackTrace);
  ```

### Coding Style
- Follows the [Official Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Strict Linting**: The project uses a high-bar linting configuration. Always run `dart analyze` and `dart fix` before committing.
- **Documentation**: All public members must have concise `///` doc comments.

### Key Patterns
- **Standardized Repositories**: Use consistent naming (e.g., `getById`, `save`, `delete`).
- **Use Case Responsibility**: Use cases are responsible for domain logic, including existence checks and throwing domain exceptions. Handlers focus on HTTP orchestration.
- **Immutability**: All domain entities are `@immutable`. Use `copyWith` for creating modified instances.
- **Data Mapping**: Mapping logic lives in the `data` layer. Entities are extended with `toMap()` for serialization, while top-level `fromMap` functions handle de-serialization.
