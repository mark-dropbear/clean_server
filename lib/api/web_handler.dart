import 'package:shelf/shelf.dart';
import 'view_renderer.dart';

/// Handler for web-related endpoints (HTML pages).
class WebHandler {
  final ViewRenderer _view;

  WebHandler(this._view);

  /// Renders the home page.
  ///
  /// Accepts an optional 'name' query parameter.
  Future<Response> home(Request request) async {
    final name = request.url.queryParameters['name'] ?? 'World';

    try {
      final output = await _view.render('home', {'name': name});
      return Response.ok(output, headers: {'Content-Type': 'text/html'});
    } catch (e) {
      final errorOutput = await _view.render('error_500', {
        'message': e.toString(),
      });
      return Response.internalServerError(
        body: errorOutput,
        headers: {'Content-Type': 'text/html'},
      );
    }
  }
}
