import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:shelf/shelf.dart';

/// Middleware that provides CSRF protection using the Double Submit Cookie pattern.
///
/// It sets an 'XSRF-TOKEN' cookie and validates that state-changing requests
/// include an 'X-XSRF-TOKEN' header with a matching value.
Middleware csrfProtection() {
  final random = Random.secure();

  return (Handler innerHandler) {
    return (Request request) async {
      // 1. Extract the token from the cookie
      final cookies = request.headers['cookie'] ?? '';
      final csrfCookie = cookies
          .split(';')
          .map((c) => c.trim())
          .where((c) => c.startsWith('XSRF-TOKEN='))
          .map((c) => c.substring('XSRF-TOKEN='.length))
          .firstOrNull;

      // 2. Validate state-changing requests
      const stateChangingMethods = {'POST', 'PUT', 'DELETE', 'PATCH'};
      final isReportingPath = request.url.path.startsWith('_reports/');

      if (stateChangingMethods.contains(request.method) && !isReportingPath) {
        final csrfHeader = request.headers['x-xsrf-token'];

        if (csrfCookie == null ||
            csrfHeader == null ||
            csrfCookie != csrfHeader) {
          return Response.forbidden(
            jsonEncode({'error': 'CSRF token mismatch or missing'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }

      // 3. Ensure a token exists for this request/response
      var token = csrfCookie;
      var isNewToken = false;
      if (token == null) {
        final bytes = List<int>.generate(32, (_) => random.nextInt(256));
        token = base64Url.encode(bytes).replaceAll('=', '');
        isNewToken = true;
      }

      // 4. Pass the token to the inner handler via context
      final updatedRequest = request.change(context: {'csrfToken': token});

      // 5. Proceed to the inner handler
      var response = await innerHandler(updatedRequest);

      // 6. Add Vary: Cookie if it wasn't already there
      final existingVary = response.headers[HttpHeaders.varyHeader];
      final newHeaders = <String, String>{};
      if (existingVary == null) {
        newHeaders[HttpHeaders.varyHeader] = 'Cookie';
      } else if (!existingVary.contains('Cookie')) {
        newHeaders[HttpHeaders.varyHeader] = '$existingVary, Cookie';
      }

      // 7. Add the Set-Cookie header if it's a new token
      if (isNewToken) {
        // We can now use HttpOnly=true since the frontend will get the
        // token via a template attribute instead of reading document.cookie.
        newHeaders['Set-Cookie'] =
            'XSRF-TOKEN=$token; Path=/; SameSite=Lax; Secure; HttpOnly';
      }

      if (newHeaders.isNotEmpty) {
        response = response.change(headers: newHeaders);
      }

      return response;
    };
  };
}
