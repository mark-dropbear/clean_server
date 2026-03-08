import 'dart:io';

import 'package:clean_server/app.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  late String baseUrl;

  setUp(() async {
    await GetIt.instance.reset();
    final app = App(port: 0);
    server = await app.run();
    baseUrl = 'http://${server.address.host}:${server.port}';
  });

  tearDown(() async {
    await server.close(force: true);
  });

  group('Web API Integration', () {
    test('GET / renders home page with default name', () async {
      final response = await http.get(Uri.parse('$baseUrl/'));
      expect(response.statusCode, 200);
      expect(response.body, contains('Hello, World!'));
      expect(response.headers['content-type'], contains('text/html'));
    });

    test('GET /?name=Gemini renders home page with custom name', () async {
      final response = await http.get(Uri.parse('$baseUrl/?name=Gemini'));
      expect(response.statusCode, 200);
      expect(response.body, contains('Hello, Gemini!'));
    });

    test('GET /?name=<script>alert(1)</script> escapes name', () async {
      final response = await http.get(
        Uri.parse('$baseUrl/?name=<script>alert(1)</script>'),
      );
      expect(response.statusCode, 200);
      expect(
        response.body,
        contains('Hello, &lt;script&gt;alert(1)&lt;&#x2F;script&gt;!'),
      );
      expect(response.body, isNot(contains('<script>alert(1)</script>!')));
    });

    test('GET /frontend/src/index.js returns frontend asset', () async {
      final response = await http.get(
        Uri.parse('$baseUrl/frontend/src/index.js'),
      );
      expect(response.statusCode, 200);
      expect(response.body, contains("AppContainer"));
      expect(response.headers['content-type'], anyOf(contains('javascript')));
    });

    test('ImportMap is present in HTML', () async {
      final response = await http.get(Uri.parse('$baseUrl/'));
      expect(
        response.body,
        contains('<script src="/frontend/importmap.js"></script>'),
      );
    });

    test('Renders 500 error page on template failure', () async {
      // Temporarily rename a template to cause a failure
      final file = File('web/templates/home.mustache');
      final tempFile = File('web/templates/home.mustache.bak');
      await file.rename(tempFile.path);

      try {
        final response = await http.get(Uri.parse('$baseUrl/'));
        expect(response.statusCode, 500);
        expect(response.headers['content-type'], contains('text/html'));
        expect(response.body, contains('Internal Server Error'));
        expect(response.body, contains('Template not found: home'));
      } finally {
        // Restore the file
        await tempFile.rename(file.path);
      }
    });
  });
}
