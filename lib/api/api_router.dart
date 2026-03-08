import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'task_handler.dart';
import 'task_list_handler.dart';
import 'web_handler.dart';

/// Centralized router for the application.
class ApiRouter {
  final Router _router = Router();

  /// Creates an [ApiRouter] and configures all routes.
  ApiRouter({
    required TaskListHandler taskListHandler,
    required TaskHandler taskHandler,
    required WebHandler webHandler,
  }) {
    // Web Routes
    _router.get('/', webHandler.home);
    _router.get('/demo', webHandler.demo);

    // Static Assets
    _router.mount('/frontend/', createStaticHandler('web/frontend/dist'));

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

  /// Dispatches a request to the appropriate handler.
  Future<Response> call(Request request) => _router.call(request);
}
