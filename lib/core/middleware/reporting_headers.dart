import 'dart:convert';
import 'package:shelf/shelf.dart';

/// Middleware that adds reporting-related headers to HTML responses.
///
/// This includes:
/// - 'Reporting-Endpoints': The modern destination for reports.
/// - 'NEL': Network Error Logging configuration.
/// - 'Report-To': Legacy destination for older browsers/NEL.
/// - 'Permissions-Policy-Report-Only': Opt-in for permission violation reports.
/// - 'Document-Policy-Report-Only': Opt-in for document policy reports.
/// - 'Cross-Origin-Opener-Policy-Report-Only': Detect COOP violations.
/// - 'Cross-Origin-Embedder-Policy-Report-Only': Detect COEP violations.
Middleware reportingHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      // Only add the headers to successful HTML responses
      final contentType = response.headers['content-type'] ?? '';
      if (response.statusCode == 200 && contentType.contains('text/html')) {
        // 1. Modern Reporting API endpoint
        const endpoints = 'default="/_reports/default"';

        // 2. Network Error Logging (NEL) config
        final nel = jsonEncode({
          'report_to': 'default',
          'max_age': 2592000, // 30 days
          'include_subdomains': true,
          'failure_fraction': 1.0,
        });

        // 3. Legacy Report-To config (needed by NEL in many browsers)
        final reportTo = jsonEncode({
          'group': 'default',
          'max_age': 2592000,
          'endpoints': [
            {'url': '/_reports/default'},
          ],
        });

        // 4. Feature opt-ins (Structured Headers syntax)
        const permissions = 'geolocation=(self), camera=()';
        const document = 'sync-xhr=?0;report-to=default';
        const coop = 'same-origin; report-to="default"';
        const coep = 'require-corp; report-to="default"';

        return response.change(
          headers: {
            'Reporting-Endpoints': endpoints,
            'NEL': nel,
            'Report-To': reportTo,
            'Permissions-Policy-Report-Only': permissions,
            'Document-Policy-Report-Only': document,
            'Cross-Origin-Opener-Policy-Report-Only': coop,
            'Cross-Origin-Embedder-Policy-Report-Only': coep,
          },
        );
      }

      return response;
    };
  };
}
