import 'dart:convert';

import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/create_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/delete_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/get_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task.dart';
import 'package:clean_server/features/tasks/presentation/handlers/task_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskRepository repository;
  late TaskHandler handler;

  setUp(() {
    repository = InMemoryTaskRepository();
    handler = TaskHandler(
      createTask: CreateTask(repository),
      getTask: GetTask(repository),
      updateTask: UpdateTask(repository),
      deleteTask: DeleteTask(repository),
      taskRepository: repository,
    );
  });

  group('TaskHandler', () {
    test('listByTaskList returns 200 and list of tasks', () async {
      await repository.save(Task(id: '1', taskListId: 'list-1', title: 'T1'));

      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks'),
      );
      final response = await handler.listByTaskList(request, 'list-1');

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString()) as List;
      expect(body.length, equals(1));
      final firstTask = body[0] as Map<String, dynamic>;
      expect(firstTask['id'], equals('1'));
    });

    test('get returns 200 and task data', () async {
      await repository.save(Task(id: '1', taskListId: 'list-1', title: 'T1'));

      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks/1'),
      );
      final response = await handler.get(request, 'list-1', '1');

      expect(response.statusCode, equals(200));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['id'], equals('1'));
    });

    test('get returns 404 if task not found', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks/99'),
      );
      final response = await handler.get(request, 'list-1', '99');

      expect(response.statusCode, equals(404));
    });

    test('create returns 201 and created task', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks'),
        body: jsonEncode({'title': 'New Task', 'description': 'Desc'}),
      );

      final response = await handler.create(request, 'list-1');

      expect(response.statusCode, equals(201));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['title'], equals('New Task'));
      expect(body['id'], isNotEmpty);

      expect((await repository.list()).length, equals(1));
    });

    test('update returns 200 and updated task', () async {
      await repository.save(Task(id: '1', taskListId: 'list-1', title: 'Old'));

      final request = Request(
        'PUT',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks/1'),
        body: jsonEncode({'title': 'New', 'is_completed': true}),
      );

      final response = await handler.update(request, 'list-1', '1');

      expect(response.statusCode, equals(200));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['title'], equals('New'));
      expect(body['is_completed'], isTrue);
    });

    test('delete returns 204', () async {
      await repository.save(Task(id: '1', taskListId: 'list-1', title: 'T1'));

      final request = Request(
        'DELETE',
        Uri.parse('http://localhost/api/task-lists/list-1/tasks/1'),
      );
      final response = await handler.delete(request, 'list-1', '1');

      expect(response.statusCode, equals(204));
      expect(await repository.getById('1'), isNull);
    });
  });
}
