import 'dart:convert';
import 'package:clean_server/api/middleware/csrf_protection.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('CSRF Protection Middleware', () {
    late Handler handler;

    setUp(() {
      handler = const Pipeline()
          .addMiddleware(csrfProtection())
          .addHandler((request) => Response.ok('OK'));
    });

    test('GET request should set XSRF-TOKEN cookie if missing', () async {
      final request = Request('GET', Uri.parse('http://localhost/'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(response.headers['Set-Cookie'], contains('XSRF-TOKEN='));
      expect(response.headers['Set-Cookie'], contains('SameSite=Lax'));
    });

    test(
      'GET request should NOT set XSRF-TOKEN cookie if already present',
      () async {
        final request = Request(
          'GET',
          Uri.parse('http://localhost/'),
          headers: {'Cookie': 'XSRF-TOKEN=existing-token'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(200));
        expect(response.headers.containsKey('Set-Cookie'), isFalse);
      },
    );

    test('POST request should fail if XSRF-TOKEN cookie is missing', () async {
      final request = Request('POST', Uri.parse('http://localhost/api/test'));
      final response = await handler(request);

      expect(response.statusCode, equals(403));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['error'], contains('CSRF token mismatch or missing'));
    });

    test(
      'POST request should fail if X-XSRF-TOKEN header is missing',
      () async {
        final request = Request(
          'POST',
          Uri.parse('http://localhost/api/test'),
          headers: {'Cookie': 'XSRF-TOKEN=token123'},
        );
        final response = await handler(request);

        expect(response.statusCode, equals(403));
      },
    );

    test('POST request should fail if header and cookie mismatch', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/test'),
        headers: {'Cookie': 'XSRF-TOKEN=token123', 'X-XSRF-TOKEN': 'token456'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(403));
    });

    test('POST request should succeed if header and cookie match', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/test'),
        headers: {'Cookie': 'XSRF-TOKEN=token123', 'X-XSRF-TOKEN': 'token123'},
      );
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(await response.readAsString(), equals('OK'));
    });
  });
}
