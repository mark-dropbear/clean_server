import 'dart:convert';
import 'dart:math';
import 'package:shelf/shelf.dart';

/// Middleware that generates a CSP nonce and adds CSP headers.
///
/// It generates a unique nonce for each request and adds it to the request
/// context. It also adds the 'Content-Security-Policy-Report-Only' header
/// to HTML responses.
Middleware cspProtection() {
  final random = Random.secure();

  return (Handler innerHandler) {
    return (Request request) async {
      // 1. Generate a cryptographically strong random nonce
      final bytes = List<int>.generate(16, (_) => random.nextInt(256));
      final nonce = base64.encode(bytes);

      // 2. Add the nonce to the request context
      final updatedRequest = request.change(context: {'cspNonce': nonce});

      // 3. Proceed to the inner handler
      final response = await innerHandler(updatedRequest);

      // 4. Add the CSP header to successful HTML responses
      final contentType = response.headers['content-type'] ?? '';
      if (response.statusCode == 200 && contentType.contains('text/html')) {
        final policy = [
          "default-src 'none'",
          "script-src 'nonce-$nonce' 'strict-dynamic' 'unsafe-inline' https:",
          "style-src 'self' https://fonts.googleapis.com",
          "font-src 'self' https://fonts.gstatic.com",
          "img-src 'self' data:",
          "connect-src 'self'",
          "base-uri 'self'",
          "form-action 'self'",
          'report-to default',
        ].join('; ');

        return response.change(
          headers: {
            'Content-Security-Policy-Report-Only': policy,
            'Cache-Control': 'no-cache, no-store, must-revalidate',
            'Pragma': 'no-cache', // For HTTP/1.0 compatibility
            'Expires': '0', // Proxies
          },
        );
      }

      return response;
    };
  };
}
