import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/create_task.dart';
import '../domain/use_cases/get_task.dart';
import '../domain/use_cases/list_tasks.dart';
import '../domain/use_cases/update_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../data/mappers/task_mapper.dart';

/// Handles HTTP requests for the Task resource.
/// This is an interface adapter that connects the web to our use cases.
class TaskHandler {
  final CreateTask _createTask;
  final GetTask _getTask;
  final ListTasks _listTasks;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  TaskHandler({
    required CreateTask createTask,
    required GetTask getTask,
    required ListTasks listTasks,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
  }) : _createTask = createTask,
       _getTask = getTask,
       _listTasks = listTasks,
       _updateTask = updateTask,
       _deleteTask = deleteTask;

  Router get router {
    final router = Router();

    router.get('/', _list);
    router.post('/', _create);
    router.get('/<id>', _get);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);

    return router;
  }

  Future<Response> _list(Request request) async {
    final tasks = await _listTasks.execute();
    final json = tasks.map(TaskMapper.toMap).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _get(Request request, String id) async {
    try {
      final task = await _getTask.execute(id);
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

  Future<Response> _create(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final task = await _createTask.execute(
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

  Future<Response> _update(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final task = await _updateTask.execute(
        id,
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

  Future<Response> _delete(Request request, String id) async {
    try {
      await _deleteTask.execute(id);
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
