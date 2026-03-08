import 'dart:convert';
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
        final listData = jsonDecode(listRes.body) as Map<String, dynamic>;
        final listId = listData['id'] as String;

        // 2. Create a Task within that list
        final taskRes = await http.post(
          Uri.parse('$baseUrl$listId/tasks'),
          body: jsonEncode({'title': 'First Task'}),
        );
        expect(taskRes.statusCode, 201);
        final taskData = jsonDecode(taskRes.body) as Map<String, dynamic>;
        final taskId = taskData['id'] as String;
        expect(taskData['task_list_id'], listId);

        // 3. Get the TaskList and verify it contains the task
        final getListRes = await http.get(Uri.parse('$baseUrl$listId'));
        expect(getListRes.statusCode, 200);
        final getListData = jsonDecode(getListRes.body) as Map<String, dynamic>;
        final tasks = getListData['tasks'] as List<dynamic>;
        expect(tasks, isNotEmpty);
        final firstTask = tasks[0] as Map<String, dynamic>;
        expect(firstTask['id'], taskId);

        // 4. Delete the TaskList
        final deleteListRes = await http.delete(Uri.parse('$baseUrl$listId'));
        expect(deleteListRes.statusCode, 204);

        // 5. Verify Task is also gone (cascade delete)
        final getListAgainRes = await http.get(Uri.parse('$baseUrl$listId'));
        expect(getListAgainRes.statusCode, 404);
      },
    );

    test('Listing tasks for a specific list', () async {
      final listRes = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode({'title': 'List A'}),
      );
      final listData = jsonDecode(listRes.body) as Map<String, dynamic>;
      final listId = listData['id'] as String;

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
      final tasks = jsonDecode(tasksRes.body) as List<dynamic>;
      expect(tasks.length, 2);
    });
  });
}
