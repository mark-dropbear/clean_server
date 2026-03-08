import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/create_task.dart';
import '../domain/use_cases/get_task.dart';
import '../domain/use_cases/update_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../domain/repositories/task_repository.dart';
import '../data/mappers/task_mapper.dart';

/// Handles HTTP requests for the Task resource.
/// Now designed to be nested under `/task-lists/<taskListId>/tasks`
class TaskHandler {
  final CreateTask _createTask;
  final GetTask _getTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final TaskRepository _taskRepository;

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

  Future<Response> listByTaskList(Request request, String taskListId) async {
    final tasks = await _taskRepository.listByTaskListId(taskListId);
    final json = tasks.map(TaskMapper.toMap).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> get(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    try {
      final task = await _getTask.execute(taskId);
      return Response.ok(
        jsonEncode(TaskMapper.toMap(task)),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> create(Request request, String taskListId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final task = await _createTask.execute(
        taskListId: taskListId,
        title: data['title'] as String,
        description: (data['description'] as String?) ?? '',
      );

      return Response(
        201,
        body: jsonEncode(TaskMapper.toMap(task)),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> update(
    Request request,
    String taskListId,
    String taskId,
  ) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final task = await _updateTask.execute(
        taskId,
        title: data['title'] as String?,
        description: data['description'] as String?,
        isCompleted: data['is_completed'] as bool?,
      );

      return Response.ok(
        jsonEncode(TaskMapper.toMap(task)),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } on InvalidTaskException catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.message}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

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
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
