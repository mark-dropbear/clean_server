import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import '../data/mappers/task_mapper.dart';
import '../domain/exceptions.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/use_cases/create_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../domain/use_cases/get_task.dart';
import '../domain/use_cases/update_task.dart';

/// Handles HTTP requests for the Task resource.
class TaskHandler {
  static final _logger = Logger('TaskHandler');
  final CreateTask _createTask;
  final GetTask _getTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final TaskRepository _taskRepository;

  /// Creates a [TaskHandler].
  TaskHandler({
    required CreateTask createTask,
    required GetTask getTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required TaskRepository taskRepository,
  }) : _createTask = createTask,
       _getTask = getTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       _taskRepository = taskRepository;

  /// Lists all tasks for a specific task list.
  Future<Response> listByTaskList(Request request, String taskListId) async {
    _logger.fine('Listing tasks for task list: $taskListId');
    final tasks = await _taskRepository.getByTaskListId(taskListId);
    final json = tasks.map((t) => t.toMap()).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Gets a specific task by ID.
  Future<Response> get(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    _logger.fine('Getting task: $taskId (list: $taskListId)');
    try {
      final task = await _getTask.execute(taskId);
      if (task == null) {
        _logger.warning('Task not found: $taskId');
        return Response.notFound(
          jsonEncode({'error': 'Task not found: $taskId'}),
        );
      }
      return Response.ok(
        jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      _logger.warning('Task not found: $taskId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error getting task: $taskId', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Creates a new task within a task list.
  Future<Response> create(Request request, String taskListId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final title = data['title'] as String;

      _logger.info('Creating task "$title" in list: $taskListId');
      final task = await _createTask.execute(
        taskListId: taskListId,
        title: title,
        description: (data['description'] as String?) ?? '',
      );

      return Response(
        201,
        body: jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      _logger.warning('Invalid task data', e);
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error creating task', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Updates an existing task.
  Future<Response> update(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      _logger.info('Updating task: $taskId');
      final task = await _updateTask.execute(
        taskId,
        title: data['title'] as String?,
        description: data['description'] as String?,
        isCompleted: data['is_completed'] as bool?,
      );

      return Response.ok(
        jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      _logger.warning('Task not found for update: $taskId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      _logger.warning('Invalid update data for task: $taskId', e);
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error updating task: $taskId', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  /// Deletes a task.
  Future<Response> delete(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    _logger.info('Deleting task: $taskId');
    try {
      await _deleteTask.execute(taskId);
      return Response(204);
    } on TaskNotFoundException catch (e) {
      _logger.warning('Task not found for deletion: $taskId');
      return Response.notFound(jsonEncode({'error': e.message}));
    } on Exception catch (e, st) {
      _logger.severe('Error deleting task: $taskId', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
