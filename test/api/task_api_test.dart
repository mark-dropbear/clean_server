import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:clean_server/app.dart';
import 'package:get_it/get_it.dart';

void main() {
  late HttpServer server;
  late String baseUrl;

  setUp(() async {
    // Reset GetIt between tests to ensure a clean state
    await GetIt.instance.reset();

    final app = App(port: 0); // Use port 0 for an ephemeral port
    server = await app.run();
    baseUrl = 'http://${server.address.host}:${server.port}/tasks';
  });

  tearDown(() async {
    await server.close(force: true);
  });

  group('Task API Integration', () {
    test('POST /tasks should create a task', () async {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({
          'title': 'Integration Task',
          'description': 'Some desc',
        }),
      );

      expect(response.statusCode, 201);
      final data = jsonDecode(response.body);
      expect(data['title'], 'Integration Task');
      expect(data['id'], isNotEmpty);
    });

    test('GET /tasks should list tasks', () async {
      // First create one
      await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'Task 1'}),
      );

      final response = await http.get(Uri.parse(baseUrl));
      expect(response.statusCode, 200);
      final List data = jsonDecode(response.body);
      expect(data.length, 1);
      expect(data[0]['title'], 'Task 1');
    });

    test('GET /tasks/<id> should return a task', () async {
      final createRes = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'Task to get'}),
      );
      final id = jsonDecode(createRes.body)['id'];

      final response = await http.get(Uri.parse('$baseUrl/$id'));
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body)['title'], 'Task to get');
    });

    test('PUT /tasks/<id> should update a task', () async {
      final createRes = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'Old Title'}),
      );
      final id = jsonDecode(createRes.body)['id'];

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        body: jsonEncode({'title': 'New Title', 'is_completed': true}),
      );

      expect(response.statusCode, 200);
      final data = jsonDecode(response.body);
      expect(data['title'], 'New Title');
      expect(data['is_completed'], true);
    });

    test('DELETE /tasks/<id> should remove a task', () async {
      final createRes = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'To delete'}),
      );
      final id = jsonDecode(createRes.body)['id'];

      final deleteRes = await http.delete(Uri.parse('$baseUrl/$id'));
      expect(deleteRes.statusCode, 204);

      final getRes = await http.get(Uri.parse('$baseUrl/$id'));
      expect(getRes.statusCode, 404);
    });
  });
}
