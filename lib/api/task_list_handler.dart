import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/create_task_list.dart';
import '../domain/use_cases/get_task_list.dart';
import '../domain/use_cases/list_task_lists.dart';
import '../domain/use_cases/update_task_list.dart';
import '../domain/use_cases/delete_task_list.dart';
import '../data/mappers/task_list_mapper.dart';
import 'task_handler.dart';

class TaskListHandler {
  final CreateTaskList _createTaskList;
  final GetTaskList _getTaskList;
  final ListTaskLists _listTaskLists;
  final UpdateTaskList _updateTaskList;
  final DeleteTaskList _deleteTaskList;
  final TaskHandler _taskHandler;

  TaskListHandler({
    required CreateTaskList createTaskList,
    required GetTaskList getTaskList,
    required ListTaskLists listTaskLists,
    required UpdateTaskList updateTaskList,
    required DeleteTaskList deleteTaskList,
    required TaskHandler taskHandler,
  }) : _createTaskList = createTaskList,
       _getTaskList = getTaskList,
       _listTaskLists = listTaskLists,
       _updateTaskList = updateTaskList,
       _deleteTaskList = deleteTaskList,
       _taskHandler = taskHandler;

  Router get router {
    final router = Router();

    router.get('/', _list);
    router.post('/', _create);
    router.get('/<id>', _get);
    router.put('/<id>', _update);
    router.delete('/<id>', _delete);

    // Route all sub-paths to a dispatcher that handles parameters
    router.all('/<id>/tasks', _handleTasks);
    router.all('/<id>/tasks/<any|.*>', _handleTasks);

    return router;
  }

  Future<Response> _handleTasks(Request request) async {
    final id = request.params['id']!;

    // request.change(path: '...') consumes segments from the START of url.path.
    // In our case, requested path is /task-lists/<id>/tasks/...
    // Since we are inside TaskListHandler (mounted at /task-lists/),
    // url.path starts with '<id>/tasks/...'.
    // We want to consume '<id>/tasks' so the next router sees the rest.

    final newRequest = request.change(
      path: '$id/tasks',
      context: {'taskListId': id},
    );

    return _taskHandler.router.call(newRequest);
  }

  Future<Response> _list(Request request) async {
    final lists = await _listTaskLists.execute();
    final json = lists.map(TaskListMapper.toMap).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _get(Request request, String id) async {
    try {
      final list = await _getTaskList.execute(id);
      return Response.ok(
        jsonEncode(TaskListMapper.toMap(list)),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
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

      final list = await _createTaskList.execute(
        title: data['title'] as String,
        description: (data['description'] as String?) ?? '',
      );

      return Response(
        201,
        body: jsonEncode(TaskListMapper.toMap(list)),
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

      final list = await _updateTaskList.execute(
        id,
        title: data['title'] as String?,
        description: data['description'] as String?,
      );

      return Response.ok(
        jsonEncode(TaskListMapper.toMap(list)),
        headers: {'Content-Type': 'application/json'},
      );
    } on TaskListNotFoundException catch (e) {
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
      await _deleteTaskList.execute(id);
      return Response(204);
    } on TaskListNotFoundException catch (e) {
      return Response.notFound(jsonEncode({'error': e.message}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
