import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/create_task_list.dart';
import '../domain/use_cases/get_task_list.dart';
import '../domain/use_cases/list_task_lists.dart';
import '../domain/use_cases/update_task_list.dart';
import '../domain/use_cases/delete_task_list.dart';
import '../data/mappers/task_list_mapper.dart';

class TaskListHandler {
  final CreateTaskList _createTaskList;
  final GetTaskList _getTaskList;
  final ListTaskLists _listTaskLists;
  final UpdateTaskList _updateTaskList;
  final DeleteTaskList _deleteTaskList;

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

  Future<Response> list(Request request) async {
    final lists = await _listTaskLists.execute();
    final json = lists.map(TaskListMapper.toMap).toList();
    return Response.ok(
      jsonEncode(json),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> get(Request request, String taskListId) async {
    try {
      final list = await _getTaskList.execute(taskListId);
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

  Future<Response> delete(Request request, String taskListId) async {
    try {
      await _deleteTaskList.execute(taskListId);
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
