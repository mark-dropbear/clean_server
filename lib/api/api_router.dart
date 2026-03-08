import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'task_list_handler.dart';
import 'task_handler.dart';

class ApiRouter {
  final Router _router = Router();

  ApiRouter({
    required TaskListHandler taskListHandler,
    required TaskHandler taskHandler,
  }) {
    // Task List Routes
    _router.get('/task-lists', taskListHandler.list);
    _router.post('/task-lists', taskListHandler.create);
    _router.get('/task-lists/<taskListId>', taskListHandler.get);
    _router.put('/task-lists/<taskListId>', taskListHandler.update);
    _router.delete('/task-lists/<taskListId>', taskListHandler.delete);

    // Nested Task Routes (Flat)
    _router.get('/task-lists/<taskListId>/tasks', taskHandler.listByTaskList);
    _router.post('/task-lists/<taskListId>/tasks', taskHandler.create);
    _router.get('/task-lists/<taskListId>/tasks/<taskId>', taskHandler.get);
    _router.put('/task-lists/<taskListId>/tasks/<taskId>', taskHandler.update);
    _router.delete(
      '/task-lists/<taskListId>/tasks/<taskId>',
      taskHandler.delete,
    );
  }

  Future<Response> call(Request request) => _router.call(request);
}
