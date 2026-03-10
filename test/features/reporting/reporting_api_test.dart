import 'dart:convert';
import 'dart:io';

import 'package:clean_server/app.dart';
import 'package:clean_server/di/service_locator.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('Reporting API Integration', () {
    late HttpServer server;
    late String baseUrl;

    setUp(() async {
      await getIt.reset();
      final app = App(port: 0); // Use random port
      server = await app.run();
      baseUrl = 'http://localhost:${server.port}';
    });

    tearDown(() async {
      await server.close(force: true);
    });

    test('POST /_reports/default should succeed without CSRF token', () async {
      final reports = [
        {
          'type': 'deprecation',
          'age': 0,
          'url': 'http://localhost/demo',
          'user_agent': 'Dart-Test',
          'body': {'id': 'TestFeature', 'message': 'Test deprecation message'},
        },
      ];

      final response = await http.post(
        Uri.parse('$baseUrl/_reports/default'),
        headers: {'Content-Type': 'application/reports+json'},
        body: jsonEncode(reports),
      );

      expect(response.statusCode, 204);
    });

    test(
      'POST /_reports/default should fail with wrong Content-Type',
      () async {
        final response = await http.post(
          Uri.parse('$baseUrl/_reports/default'),
          headers: {'Content-Type': 'application/json'},
          body: '[]',
        );

        expect(response.statusCode, 400);
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        expect(body['error'], contains('Unsupported Content-Type'));
      },
    );
  });
}
