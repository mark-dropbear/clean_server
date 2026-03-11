import 'package:clean_server/core/middleware/reporting_headers.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('reportingHeaders', () {
    test(
      'should add all reporting headers to successful HTML responses',
      () async {
        final handler = reportingHeaders()((request) {
          return Response.ok(
            '<html></html>',
            headers: {'Content-Type': 'text/html'},
          );
        });

        final response = await handler(
          Request('GET', Uri.parse('http://localhost/')),
        );

        expect(response.headers['Reporting-Endpoints'], isNotNull);
        expect(response.headers['NEL'], contains('"report_to":"default"'));
        expect(response.headers['Report-To'], contains('"group":"default"'));
        expect(response.headers['Permissions-Policy-Report-Only'], isNotNull);
        expect(response.headers['Document-Policy-Report-Only'], isNotNull);
      },
    );

    test('should NOT add reporting headers to non-HTML responses', () async {
      final handler = reportingHeaders()((request) {
        return Response.ok(
          '{"ok": true}',
          headers: {'Content-Type': 'application/json'},
        );
      });

      final response = await handler(
        Request('GET', Uri.parse('http://localhost/')),
      );

      expect(response.headers['Reporting-Endpoints'], isNull);
      expect(response.headers['NEL'], isNull);
    });
  });
}
