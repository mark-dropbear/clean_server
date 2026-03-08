import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'di/service_locator.dart';
import 'api/task_handler.dart';

/// The main application class that manages the server lifecycle.
class App {
  final int port;
  final bool verbose;

  App({this.port = 8080, this.verbose = false});

  /// Initializes and starts the server.
  Future<HttpServer> run() async {
    // 1. Setup Dependency Injection
    setupLocator();

    // 2. Build the router
    final router = Router();

    // We mount the task handler under the /tasks prefix
    router.mount('/tasks', getIt<TaskHandler>().router.call);

    // 3. Configure the middleware and handler
    var pipeline = const Pipeline();
    if (verbose) {
      pipeline = pipeline.addMiddleware(logRequests());
    }

    final handler = pipeline.addHandler(router.call);

    // 4. Start the server
    final server = await serve(handler, InternetAddress.anyIPv4, port);
    print('Server listening on port ${server.port}');
    return server;
  }
}
