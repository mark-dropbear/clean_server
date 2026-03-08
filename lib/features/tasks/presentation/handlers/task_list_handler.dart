import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../../core/exceptions.dart';
import '../../data/mappers/task_list_mapper.dart';
import '../../domain/use_cases/create_task_list.dart';
import '../../domain/use_cases/delete_task_list.dart';
import '../../domain/use_cases/get_task_list.dart';
import '../../domain/use_cases/list_task_lists.dart';
import '../../domain/use_cases/update_task_list.dart';

/// Handler for task list endpoints.
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
    return Response.ok(
      jsonEncode(lists.map((list) => list.toMap()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Creates a new task list.
  Future<Response> create(Request request) async {
    final payload =
        jsonDecode(await request.readAsString()) as Map<String, dynamic>;

    try {
      final list = await _createTaskList.execute(
        title: payload['title'] as String,
        description: (payload['description'] as String?) ?? '',
      );
      return Response(
        201,
        body: jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    }
  }

  /// Gets a task list by ID.
  Future<Response> get(Request request, String taskListId) async {
    try {
      final list = await _getTaskList.execute(taskListId);
      if (list == null) {
        throw TaskListNotFoundException(taskListId);
      }
      return Response.ok(
        jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    }
  }

  /// Updates a task list.
  Future<Response> update(Request request, String taskListId) async {
    final payload =
        jsonDecode(await request.readAsString()) as Map<String, dynamic>;

    try {
      final list = await _updateTaskList.execute(
        taskListId,
        title: payload['title'] as String?,
        description: payload['description'] as String?,
      );
      return Response.ok(
        jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    }
  }

  /// Deletes a task list.
  Future<Response> delete(Request request, String taskListId) async {
    try {
      await _deleteTaskList.execute(taskListId);
      return Response(204);
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    }
  }
}
