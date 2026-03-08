import 'package:shelf/shelf.dart';

/// Middleware that removes trailing slashes from the request URL.
///
/// This performs an internal rewrite by creating a new [Request] with a
/// normalized requestedUri.
///
/// This can be added to a [Pipeline].
Middleware stripTrailingSlash() {
  return (Handler innerHandler) {
    return (Request request) {
      final path = request.url.path;

      // If the path ends with a slash (and isn't just the root path)
      if (path.isNotEmpty && path.endsWith('/')) {
        final newRequestedPath = request.requestedUri.path.substring(
          0,
          request.requestedUri.path.length - 1,
        );

        final newRequestedUri = request.requestedUri.replace(
          path: newRequestedPath,
        );

        // We create a new Request object to normalize the URL while
        // preserving the handlerPath and other request properties.
        final normalizedRequest = Request(
          request.method,
          newRequestedUri,
          protocolVersion: request.protocolVersion,
          headers: request.headersAll,
          body: request.read(),
          context: request.context,
          handlerPath: request.handlerPath,
        );

        return innerHandler(normalizedRequest);
      }

      return innerHandler(request);
    };
  };
}
