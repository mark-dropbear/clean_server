import 'package:shelf/shelf.dart';

/// Middleware that adds common security headers to all responses.
///
/// This includes:
/// - 'Referrer-Policy: strict-origin-when-cross-origin' for privacy.
/// - 'Strict-Transport-Security': Only allow HTTPS (skipped for localhost).
/// - 'Cross-Origin-Resource-Policy: same-origin' to protect resources.
Middleware securityHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      final headers = {
        'Referrer-Policy': 'strict-origin-when-cross-origin',
        'Cross-Origin-Resource-Policy': 'same-origin',
      };

      // Only add HSTS if we are not on localhost to avoid dev friction.
      // Browsers usually ignore this for localhost anyway, but this is safer.
      if (request.requestedUri.host != 'localhost' &&
          request.requestedUri.host != '127.0.0.1') {
        headers['Strict-Transport-Security'] =
            'max-age=63072000; includeSubDomains; preload';
      }

      return response.change(headers: headers);
    };
  };
}
