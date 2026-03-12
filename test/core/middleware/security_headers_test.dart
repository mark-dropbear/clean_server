import 'package:clean_server/core/middleware/security_headers.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('Security Headers Middleware', () {
    test('should add common headers to all responses', () async {
      final handler = const Pipeline()
          .addMiddleware(securityHeaders())
          .addHandler((request) => Response.ok('OK'));

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(
        response.headers['Referrer-Policy'],
        equals('strict-origin-when-cross-origin'),
      );
      expect(
        response.headers['Cross-Origin-Resource-Policy'],
        equals('same-origin'),
      );
    });

    test('should NOT add HSTS on localhost', () async {
      final handler = const Pipeline()
          .addMiddleware(securityHeaders())
          .addHandler((request) => Response.ok('OK'));

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.headers['Strict-Transport-Security'], isNull);
    });

    test('should add HSTS on non-localhost hosts', () async {
      final handler = const Pipeline()
          .addMiddleware(securityHeaders())
          .addHandler((request) => Response.ok('OK'));

      final response = await handler(
        Request('GET', Uri.parse('http://example.com/')),
      );

      expect(
        response.headers['Strict-Transport-Security'],
        contains('max-age='),
      );
    });
  });
}
