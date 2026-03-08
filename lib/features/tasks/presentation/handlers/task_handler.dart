import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../../core/exceptions.dart';
import '../../data/mappers/task_mapper.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/use_cases/create_task.dart';
import '../../domain/use_cases/delete_task.dart';
import '../../domain/use_cases/get_task.dart';
import '../../domain/use_cases/update_task.dart';

/// Handler for task-related endpoints.
class TaskHandler {
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

  /// Lists all tasks for a given task list.
  Future<Response> listByTaskList(Request request, String taskListId) async {
    final tasks = await _taskRepository.getByTaskListId(taskListId);
    return Response.ok(
      jsonEncode(tasks.map((task) => task.toMap()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  /// Creates a new task.
  Future<Response> create(Request request, String taskListId) async {
    final payload =
        jsonDecode(await request.readAsString()) as Map<String, dynamic>;

    try {
      final task = await _createTask.execute(
        taskListId: taskListId,
        title: payload['title'] as String,
        description: (payload['description'] as String?) ?? '',
      );
      return Response(
        201,
        body: jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  /// Gets a task by ID.
  Future<Response> get(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    try {
      final task = await _getTask.execute(taskId);
      if (task == null) {
        throw TaskNotFoundException(taskId);
      }
      return Response.ok(
        jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    }
  }

  /// Updates a task.
  Future<Response> update(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    final payload =
        jsonDecode(await request.readAsString()) as Map<String, dynamic>;

    try {
      final task = await _updateTask.execute(
        taskId,
        title: payload['title'] as String?,
        description: payload['description'] as String?,
        isCompleted: payload['is_completed'] as bool?,
      );
      return Response.ok(
        jsonEncode(task.toMap()),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    }
  }

  /// Deletes a task.
  Future<Response> delete(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    try {
      await _deleteTask.execute(taskId);
      return Response(204);
    } on TaskNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    }
  }
}
