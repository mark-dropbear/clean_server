import 'package:clean_server/api/api_router.dart';
import 'package:clean_server/api/task_handler.dart';
import 'package:clean_server/api/task_list_handler.dart';
import 'package:clean_server/api/view_renderer.dart';
import 'package:clean_server/api/web_handler.dart';
import 'package:clean_server/data/repositories/in_memory_task_list_repository.dart';
import 'package:clean_server/data/repositories/in_memory_task_repository.dart';
import 'package:clean_server/domain/use_cases/create_task.dart';
import 'package:clean_server/domain/use_cases/create_task_list.dart';
import 'package:clean_server/domain/use_cases/delete_task.dart';
import 'package:clean_server/domain/use_cases/delete_task_list.dart';
import 'package:clean_server/domain/use_cases/get_task.dart';
import 'package:clean_server/domain/use_cases/get_task_list.dart';
import 'package:clean_server/domain/use_cases/list_task_lists.dart';
import 'package:clean_server/domain/use_cases/update_task.dart';
import 'package:clean_server/domain/use_cases/update_task_list.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late ApiRouter apiRouter;

  setUp(() {
    final taskListRepo = InMemoryTaskListRepository();
    final taskRepo = InMemoryTaskRepository();
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

    apiRouter = ApiRouter(
      taskListHandler: taskListHandler,
      taskHandler: taskHandler,
      webHandler: webHandler,
    );
  });

  group('ApiRouter', () {
    test('GET /task-lists should be routed to TaskListHandler.list', () async {
      final request = Request('GET', Uri.parse('http://localhost/task-lists'));
      final response = await apiRouter.call(request);
      expect(response.statusCode, equals(200));
    });

    test('GET /non-existent should return 404', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost/non-existent'),
      );
      final response = await apiRouter.call(request);
      expect(response.statusCode, equals(404));
    });
  });
}
