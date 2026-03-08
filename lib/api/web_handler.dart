import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import '../data/mappers/task_list_mapper.dart';
import '../domain/entities/task.dart';
import '../domain/entities/task_list.dart';
import 'view_renderer.dart';

/// Handler for web-related endpoints (HTML pages).
class WebHandler {
  static final _logger = Logger('WebHandler');
  final ViewRenderer _renderer;

  /// Creates a [WebHandler].
  WebHandler(this._renderer);

  /// Renders the home page.
  ///
  /// Accepts an optional 'name' query parameter.
  Future<Response> home(Request request) async {
    final name = request.url.queryParameters['name'] ?? 'World';

    try {
      final output = await _renderer.render('home', {'name': name});
      return Response.ok(output, headers: {'Content-Type': 'text/html'});
    } on Exception catch (e, st) {
      _logger.warning(
        'Error rendering home page, attempting error page',
        e,
        st,
      );
      try {
        final errorOutput = await _renderer.render('error_500', {
          'message': e.toString(),
        });
        return Response.internalServerError(
          body: errorOutput,
          headers: {'Content-Type': 'text/html'},
        );
      } on Exception catch (innerError, innerSt) {
        _logger.severe('Failed to render error page', innerError, innerSt);
        // Fallback to plain text if the error page fails to render
        return Response.internalServerError(
          body: 'Failed to render: $e\nInner rendering error: $innerError',
        );
      }
    }
  }

  /// Renders a demo page with Lit components and dummy JSON-LD data.
  Future<Response> demo(Request request) async {
    _logger.info('Rendering demo page');

    final dummyList = TaskList(
      id: 'list-demo-1',
      title: 'Demo Task List',
      description: 'A list of tasks to showcase Lit components and JSON-LD.',
      tasks: [
        Task(
          id: 'task-demo-1',
          taskListId: 'list-demo-1',
          title: 'Learn Lit',
          description: 'Explore Lit templates and reactive properties.',
          isCompleted: true,
        ),
        Task(
          id: 'task-demo-2',
          taskListId: 'list-demo-1',
          title: 'Implement JSON-LD',
          description: 'Map domain entities to Schema.org vocabulary.',
          isCompleted: true,
        ),
        Task(
          id: 'task-demo-3',
          taskListId: 'list-demo-1',
          title: 'Build Awesome Apps',
          description: 'Combine Clean Architecture with modern frontend tech.',
        ),
      ],
    );

    final jsonLd = jsonEncode(dummyList.toJsonLd());

    try {
      final output = await _renderer.render('demo', {'jsonLd': jsonLd});
      return Response.ok(output, headers: {'Content-Type': 'text/html'});
    } on Exception catch (e, st) {
      _logger.severe('Error rendering demo page', e, st);
      return Response.internalServerError(body: 'Error: $e');
    }
  }
}
