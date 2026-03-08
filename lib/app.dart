import 'dart:developer' as developer;
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'api/api_router.dart';
import 'api/middleware/url_normalization.dart';
import 'api/task_handler.dart';
import 'api/task_list_handler.dart';
import 'api/web_handler.dart';
import 'di/service_locator.dart';

/// The main application class that manages the server lifecycle.
class App {
  /// The port to listen on.
  final int port;

  /// Whether to enable verbose logging.
  final bool verbose;

  /// Creates a new [App] instance.
  App({this.port = 8080, this.verbose = false});

  /// Initializes and starts the server.
  Future<HttpServer> run() async {
    // 1. Setup Dependency Injection
    setupLocator();

    // 2. Build the router
    final router = ApiRouter(
      taskListHandler: getIt<TaskListHandler>(),
      taskHandler: getIt<TaskHandler>(),
      webHandler: getIt<WebHandler>(),
    );

    // 3. Configure the middleware and handler
    var pipeline = const Pipeline().addMiddleware(stripTrailingSlash());
    if (verbose) {
      pipeline = pipeline.addMiddleware(logRequests());
    }

    final handler = pipeline.addHandler(router.call);

    // 4. Start the server
    final server = await serve(handler, InternetAddress.anyIPv4, port);
    developer.log('Server listening on port ${server.port}');
    return server;
  }
}
