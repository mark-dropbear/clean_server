import 'dart:io';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'api/api_router.dart';
import 'api/feedback_handler.dart';
import 'api/middleware/url_normalization.dart';
import 'api/task_handler.dart';
import 'api/task_list_handler.dart';
import 'api/web_handler.dart';
import 'di/service_locator.dart';

/// The main application class that manages the server lifecycle.
class App {
  static final _logger = Logger('App');

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
      feedbackHandler: getIt<FeedbackHandler>(),
    );

    // 3. Configure the middleware and handler
    var pipeline = const Pipeline().addMiddleware(stripTrailingSlash());

    // Use custom logging middleware if verbose
    if (verbose) {
      pipeline = pipeline.addMiddleware(_logRequests);
    }

    final handler = pipeline.addHandler(router.call);

    // 4. Start the server
    final server = await serve(handler, InternetAddress.anyIPv4, port);
    _logger.info('Server listening on port ${server.port}');
    return server;
  }

  Middleware get _logRequests {
    final logger = Logger('HTTP');
    return (Handler innerHandler) {
      return (Request request) async {
        final watch = Stopwatch()..start();
        try {
          final response = await innerHandler(request);
          watch.stop();
          final duration = watch.elapsed.inMilliseconds;
          final message =
              '${request.method} ${request.url.path} '
              '${response.statusCode} (${duration}ms)';

          if (response.statusCode >= 500) {
            logger.severe(message);
          } else if (response.statusCode >= 400) {
            logger.warning(message);
          } else {
            logger.info(message);
          }

          return response;
        } catch (e, st) {
          watch.stop();
          final duration = watch.elapsed.inMilliseconds;
          logger.severe(
            '${request.method} ${request.url.path} ERROR (${duration}ms)',
            e,
            st,
          );
          rethrow;
        }
      };
    };
  }
}
