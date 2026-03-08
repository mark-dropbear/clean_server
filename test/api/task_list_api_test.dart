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
    await GetIt.instance.reset();
    final app = App(port: 0);
    server = await app.run();
    baseUrl = 'http://${server.address.host}:${server.port}/task-lists/';
  });

  tearDown(() async {
    await server.close(force: true);
  });

  group('TaskList & Task Relationship Integration', () {
    test(
      'Full lifecycle: Create List -> Create Task -> Get List with Task -> Delete List',
      () async {
        // 1. Create a TaskList
        final listRes = await http.post(
          Uri.parse(baseUrl),
          body: jsonEncode({'title': 'My Projects'}),
        );
        expect(listRes.statusCode, 201);
        final listId = jsonDecode(listRes.body)['id'];

        // 2. Create a Task within that list
        final taskRes = await http.post(
          Uri.parse('$baseUrl$listId/tasks'),
          body: jsonEncode({'title': 'First Task'}),
        );
        expect(taskRes.statusCode, 201);
        final taskId = jsonDecode(taskRes.body)['id'];
        expect(jsonDecode(taskRes.body)['task_list_id'], listId);

        // 3. Get the TaskList and verify it contains the task
        final getListRes = await http.get(Uri.parse('$baseUrl$listId'));
        expect(getListRes.statusCode, 200);
        final listData = jsonDecode(getListRes.body);
        expect(listData['tasks'], isNotEmpty);
        expect(listData['tasks'][0]['id'], taskId);

        // 4. Delete the TaskList
        final deleteListRes = await http.delete(Uri.parse('$baseUrl$listId'));
        expect(deleteListRes.statusCode, 204);

        // 5. Verify Task is also gone (cascade delete)
        // Since it's nested, getting it via the list path should fail anyway because the list is gone.
        // But we can check if the list itself is gone first.
        final getListAgainRes = await http.get(Uri.parse('$baseUrl$listId'));
        expect(getListAgainRes.statusCode, 404);

        // Verification of task absence can also be done via a direct fetch if TaskHandler supported it,
        // but in our nested design, tasks are scoped to lists.
      },
    );

    test('Listing tasks for a specific list', () async {
      final listRes = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'List A'}),
      );
      final listId = jsonDecode(listRes.body)['id'];

      await http.post(
        Uri.parse('$baseUrl$listId/tasks'),
        body: jsonEncode({'title': 'T1'}),
      );
      await http.post(
        Uri.parse('$baseUrl$listId/tasks'),
        body: jsonEncode({'title': 'T2'}),
      );

      final tasksRes = await http.get(Uri.parse('$baseUrl$listId/tasks'));
      expect(tasksRes.statusCode, 200);
      final List tasks = jsonDecode(tasksRes.body);
      expect(tasks.length, 2);
    });
  });
}
