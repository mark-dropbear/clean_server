import 'package:clean_server/app_router.dart';
import 'package:clean_server/core/view_renderer.dart';
import 'package:clean_server/features/feedback/data/repositories/in_memory_feedback_repository.dart';
import 'package:clean_server/features/feedback/domain/use_cases/submit_feedback.dart';
import 'package:clean_server/features/feedback/presentation/handlers/feedback_handler.dart';
import 'package:clean_server/features/pages/presentation/handlers/web_handler.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/features/tasks/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/features/tasks/domain/use_cases/create_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/create_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/delete_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/delete_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/get_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/get_task_list.dart';
import 'package:clean_server/features/tasks/domain/use_cases/list_task_lists.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task.dart';
import 'package:clean_server/features/tasks/domain/use_cases/update_task_list.dart';
import 'package:clean_server/features/tasks/presentation/handlers/task_handler.dart';
import 'package:clean_server/features/tasks/presentation/handlers/task_list_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late AppRouter appRouter;

  setUp(() {
    final taskListRepo = InMemoryTaskListRepository();
    final taskRepo = InMemoryTaskRepository();
    final feedbackRepo = InMemoryFeedbackRepository();
    final renderer =
        ViewRenderer(); // We won't test rendering here, just routing

    final taskListHandler = TaskListHandler(
      createTaskList: CreateTaskList(taskListRepo),
      getTaskList: GetTaskList(
        taskListRepository: taskListRepo,
        taskRepository: taskRepo,
      ),
      listTaskLists: ListTaskLists(taskListRepo),
      updateTaskList: UpdateTaskList(taskListRepo),
      deleteTaskList: DeleteTaskList(
        taskListRepository: taskListRepo,
        taskRepository: taskRepo,
      ),
    );

    final taskHandler = TaskHandler(
      createTask: CreateTask(taskRepo),
      getTask: GetTask(taskRepo),
      updateTask: UpdateTask(taskRepo),
      deleteTask: DeleteTask(taskRepo),
      taskRepository: taskRepo,
    );

    final webHandler = WebHandler(renderer);

    final feedbackHandler = FeedbackHandler(
      submitFeedback: SubmitFeedback(feedbackRepo),
    );

    appRouter = AppRouter(
      taskListHandler: taskListHandler,
      taskHandler: taskHandler,
      webHandler: webHandler,
      feedbackHandler: feedbackHandler,
    );
  });

  group('AppRouter', () {
    test('GET /task-lists should be routed to TaskListHandler.list', () async {
      final request = Request('GET', Uri.parse('http://localhost/task-lists'));
      final response = await appRouter.call(request);
      expect(response.statusCode, equals(200));
    });

    test('GET /non-existent should return 404', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/non-existent'),
      );
      final response = await appRouter.call(request);
      expect(response.statusCode, equals(404));
    });

    test('POST /api/feedback should be routed to FeedbackHandler.submit', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/feedback'),
        body:
            '{"name": "a", "email": "b", "message": "c"}', // invalid data but routed
      );
      final response = await appRouter.call(request);
      // It will return 400 because data is invalid, but it means it reached the handler
      expect(response.statusCode, equals(400));
    });
  });
}
