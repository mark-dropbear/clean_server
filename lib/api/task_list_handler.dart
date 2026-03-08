import 'dart:convert';
import 'package:logging/logging.dart';
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
  static final _logger = Logger('TaskListHandler');
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
    _logger.fine('Listing all task lists');
    final lists = await _listTaskLists.execute();
    final json = lists.map((l) => l.toMap()).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Gets a specific task list by ID.
  Future<Response> get(Request request, String taskListId) async {
    _logger.fine('Getting task list: $taskListId');
    try {
      final list = await _getTaskList.execute(taskListId);
      if (list == null) {
        _logger.warning('Task list not found: $taskListId');
        return Response.notFound(
          jsonEncode({'error': 'Task list not found: $taskListId'}),
        );
      }
      return Response.ok(
        jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
      _logger.warning('Task list not found: $taskListId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error getting task list: $taskListId', e, st);
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
      final title = data['title'] as String;

      _logger.info('Creating task list: $title');
      final list = await _createTaskList.execute(
        title: title,
        description: (data['description'] as String?) ?? '',
      );

      return Response(
        201,
        body: jsonEncode(list.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      _logger.warning('Invalid task list data', e);
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error creating task list', e, st);
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

      _logger.info('Updating task list: $taskListId');
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
      _logger.warning('Task list not found for update: $taskListId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      _logger.warning('Invalid update data for task list: $taskListId', e);
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error updating task list: $taskListId', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Deletes a task list.
  Future<Response> delete(Request request, String taskListId) async {
    _logger.info('Deleting task list: $taskListId');
    try {
      await _deleteTaskList.execute(taskListId);
      return Response(204);
    } on TaskListNotFoundException catch (e) {
      _logger.warning('Task list not found for deletion: $taskListId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error deleting task list: $taskListId', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
