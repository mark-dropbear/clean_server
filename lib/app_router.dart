import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'features/feedback/presentation/handlers/feedback_handler.dart';
import 'features/pages/presentation/handlers/web_handler.dart';
import 'features/reporting/presentation/handlers/report_handler.dart';
import 'features/tasks/presentation/handlers/task_handler.dart';
import 'features/tasks/presentation/handlers/task_list_handler.dart';

/// Centralized router for the application.
class AppRouter {
  final Router _router = Router();

  /// Creates an [AppRouter] and configures all routes.
  AppRouter({
    required TaskListHandler taskListHandler,
    required TaskHandler taskHandler,
    required WebHandler webHandler,
    required FeedbackHandler feedbackHandler,
    required ReportHandler reportHandler,
  }) {
    // Web Routes
    _router.get('/', webHandler.home);
    _router.get('/contact', webHandler.contact);
    _router.get('/demo', webHandler.demo);

    // Static Assets
    _router.mount('/frontend/', createStaticHandler('web/frontend/dist'));

    // Feedback API
    _router.post('/api/feedback', feedbackHandler.submit);

    // Reporting API
    _router.post('/_reports/default', reportHandler.handleDefault);

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
