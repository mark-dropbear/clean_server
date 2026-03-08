import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../data/mappers/task_list_mapper.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/create_task_list.dart';
import '../domain/use_cases/delete_task_list.dart';
import '../domain/use_cases/get_task_list.dart';
import '../domain/use_cases/list_task_lists.dart';
import '../domain/use_cases/update_task_list.dart';

/// Handler for task list related endpoints.
class TaskListHandler {
  final CreateTaskList _createTaskList;
  final GetTaskList _getTaskList;
  final ListTaskLists _listTaskLists;
  final UpdateTaskList _updateTaskList;
  final DeleteTaskList _deleteTaskList;

  /// Creates a [TaskListHandler].
  TaskListHandler({
    required CreateTaskList createTaskList,
    required GetTaskList getTaskList,
    required ListTaskLists listTaskLists,
    required UpdateTaskList updateTaskList,
    required DeleteTaskList deleteTaskList,
  }) : _createTaskList = createTaskList,
       _getTaskList = getTaskList,
       _listTaskLists = listTaskLists,
       _updateTaskList = updateTaskList,
       _deleteTaskList = deleteTaskList;

  /// Lists all task lists.
  Future<Response> list(Request request) async {
    final lists = await _listTaskLists.execute();
    final json = lists.map((l) => l.toMap()).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Gets a specific task list by ID.
  Future<Response> get(Request request, String taskListId) async {
    try {
      final list = await _getTaskList.execute(taskListId);
      if (list == null) {
        return Response.notFound(
          jsonEncode({'error': 'Task list not found: $taskListId'}),
        );
      }
      return Response.ok(
        jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Creates a new task list.
  Future<Response> create(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final list = await _createTaskList.execute(
        title: data['title'] as String,
        description: (data['description'] as String?) ?? '',
      );

      return Response(
        201,
        body: jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Updates an existing task list.
  Future<Response> update(Request request, String taskListId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final list = await _updateTaskList.execute(
        taskListId,
        title: data['title'] as String?,
        description: data['description'] as String?,
      );

      return Response.ok(
        jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Deletes a task list.
  Future<Response> delete(Request request, String taskListId) async {
    try {
      await _deleteTaskList.execute(taskListId);
      return Response(204);
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
