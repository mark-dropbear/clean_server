import 'package:clean_server/core/middleware/csp_protection.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('cspProtection', () {
    test('should generate a nonce and add it to request context', () async {
      final handler = cspProtection()((request) {
        final nonce = request.context['cspNonce'];
        expect(nonce, isNotNull);
        expect(nonce, isA<String>());
        expect((nonce as String).length, greaterThan(10));
        return Response.ok('ok');
      });

      await handler(Request('GET', Uri.parse('http://localhost/')));
    });

    test(
      'should add CSP-Report-Only and Cache-Control headers to successful HTML responses',
      () async {
        final handler = cspProtection()((request) {
          return Response.ok(
            '<html></html>',
            headers: {'Content-Type': 'text/html'},
          );
        });

        final response = await handler(
          Request('GET', Uri.parse('http://localhost/')),
        );

        expect(
          response.headers['Content-Security-Policy-Report-Only'],
          contains("script-src 'nonce-"),
        );
        expect(
          response.headers['Content-Security-Policy-Report-Only'],
          contains('report-to default'),
        );
        expect(
          response.headers['Cache-Control'],
          'no-cache, no-store, must-revalidate',
        );
        expect(response.headers['Pragma'], 'no-cache');
      },
    );

    test('should NOT add CSP header to non-HTML responses', () async {
      final handler = cspProtection()((request) {
        return Response.ok(
          '{"ok": true}',
          headers: {'Content-Type': 'application/json'},
        );
      });

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.headers['Content-Security-Policy-Report-Only'], isNull);
    });
  });
}
