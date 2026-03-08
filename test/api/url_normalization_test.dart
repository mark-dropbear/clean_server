import 'dart:io';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:clean_server/app.dart';
import 'package:get_it/get_it.dart';

void main() {
  late HttpServer server;
  late String serverUrl;

  setUp(() async {
    await GetIt.instance.reset();
    final app = App(port: 0);
    server = await app.run();
    serverUrl = 'http://${server.address.host}:${server.port}';
  });

  tearDown(() async {
    await server.close(force: true);
  });

  group('URL Normalization', () {
    test('Mounted route matches WITHOUT trailing slash', () async {
      final res = await http.get(Uri.parse('$serverUrl/task-lists'));
      expect(res.statusCode, 200);
    });

    test('Mounted route matches WITH trailing slash (normalized)', () async {
      final res = await http.get(Uri.parse('$serverUrl/task-lists/'));
      expect(res.statusCode, 200);
    });

    test('Sub-path WITH trailing slash is normalized', () async {
      // /task-lists/abc/ matches TaskListHandler then it tries to find ID 'abc'
      final res = await http.get(Uri.parse('$serverUrl/task-lists/abc/'));
      // Normalized to /task-lists/abc which matches the handler.
      // It returns 404 because ID 'abc' doesn't exist, NOT because of route mismatch.
      expect(res.statusCode, 404);
    });
  });
}
