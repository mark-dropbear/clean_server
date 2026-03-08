import 'dart:convert';

import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/entities/task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/create_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/delete_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/get_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/list_task_lists.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task_list.dart';
import 'package:clean_server/features/tasks/presentation/handlers/task_list_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryTaskListRepository taskListRepository;
  late InMemoryTaskRepository taskRepository;
  late TaskListHandler handler;

  setUp(() {
    taskListRepository = InMemoryTaskListRepository();
    taskRepository = InMemoryTaskRepository();
    handler = TaskListHandler(
      createTaskList: CreateTaskList(taskListRepository),
      getTaskList: GetTaskList(
        taskListRepository: taskListRepository,
        taskRepository: taskRepository,
      ),
      listTaskLists: ListTaskLists(taskListRepository),
      updateTaskList: UpdateTaskList(taskListRepository),
      deleteTaskList: DeleteTaskList(
        taskListRepository: taskListRepository,
        taskRepository: taskRepository,
      ),
    );
  });

  group('TaskListHandler', () {
    test('list returns 200 and list of task lists', () async {
      await taskListRepository.save(TaskList(id: '1', title: 'L1'));

      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists'),
      );
      final response = await handler.list(request);

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString()) as List;
      expect(body.length, equals(1));
      final firstList = body[0] as Map<String, dynamic>;
      expect(firstList['id'], equals('1'));
    });

    test('get returns 200 and task list data', () async {
      await taskListRepository.save(TaskList(id: '1', title: 'L1'));

      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists/1'),
      );
      final response = await handler.get(request, '1');

      expect(response.statusCode, equals(200));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['id'], equals('1'));
    });

    test('get returns 404 if list not found', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/api/task-lists/99'),
      );
      final response = await handler.get(request, '99');

      expect(response.statusCode, equals(404));
    });

    test('create returns 201 and created task list', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/task-lists'),
        body: jsonEncode({'title': 'New List', 'description': 'Desc'}),
      );

      final response = await handler.create(request);

      expect(response.statusCode, equals(201));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['title'], equals('New List'));
      expect(body['id'], isNotEmpty);
    });

    test('update returns 200 and updated task list', () async {
      await taskListRepository.save(TaskList(id: '1', title: 'Old'));

      final request = Request(
        'PUT',
        Uri.parse('http://localhost/api/task-lists/1'),
        body: jsonEncode({'title': 'New'}),
      );

      final response = await handler.update(request, '1');

      expect(response.statusCode, equals(200));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['title'], equals('New'));
    });

    test('delete returns 204', () async {
      await taskListRepository.save(TaskList(id: '1', title: 'L1'));

      final request = Request(
        'DELETE',
        Uri.parse('http://localhost/api/task-lists/1'),
      );
      final response = await handler.delete(request, '1');

      expect(response.statusCode, equals(204));
      expect(await taskListRepository.getById('1'), isNull);
    });
  });
}
