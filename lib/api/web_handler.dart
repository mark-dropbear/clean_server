import 'package:shelf/shelf.dart';
import 'view_renderer.dart';

/// Handler for web-related endpoints (HTML pages).
class WebHandler {
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
    } on Exception catch (e) {
      try {
        final errorOutput = await _renderer.render('error_500', {
          'message': e.toString(),
        });
        return Response.internalServerError(
          body: errorOutput,
          headers: {'Content-Type': 'text/html'},
        );
      } on Exception catch (innerError) {
        // Fallback to plain text if the error page fails to render
        return Response.internalServerError(
          body: 'Failed to render: $e\nInner rendering error: $innerError',
        );
      }
    }
  }
}
