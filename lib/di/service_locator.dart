import 'package:get_it/get_it.dart';

import '../core/view_renderer.dart';
import '../features/feedback/data/repositories/in_memory_feedback_repository.dart';
import '../features/feedback/domain/repositories/feedback_repository.dart';
import '../features/feedback/domain/use_cases/submit_feedback.dart';
import '../features/feedback/presentation/handlers/feedback_handler.dart';
import '../features/pages/presentation/handlers/web_handler.dart';
import '../features/reporting/data/repositories/in_memory_report_repository.dart';
import '../features/reporting/domain/repositories/report_repository.dart';
import '../features/reporting/domain/use_cases/submit_reports.dart';
import '../features/reporting/presentation/handlers/report_handler.dart';
import '../features/tasks/data/repositories/in_memory_task_list_repository.dart';
import '../features/tasks/data/repositories/in_memory_task_repository.dart';
import '../features/tasks/domain/repositories/task_list_repository.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/domain/use_cases/create_task.dart';
import '../features/tasks/domain/use_cases/create_task_list.dart';
import '../features/tasks/domain/use_cases/delete_task.dart';
import '../features/tasks/domain/use_cases/delete_task_list.dart';
import '../features/tasks/domain/use_cases/get_task.dart';
import '../features/tasks/domain/use_cases/get_task_list.dart';
import '../features/tasks/domain/use_cases/list_task_lists.dart';
import '../features/tasks/domain/use_cases/list_tasks.dart';
import '../features/tasks/domain/use_cases/update_task.dart';
import '../features/tasks/domain/use_cases/update_task_list.dart';
import '../features/tasks/presentation/handlers/task_handler.dart';
import '../features/tasks/presentation/handlers/task_list_handler.dart';

/// The global service locator instance.
final getIt = GetIt.instance;

/// Configures the service locator with all dependencies.
void setupLocator() {
  // Services
  getIt.registerLazySingleton(ViewRenderer.new);

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(InMemoryTaskRepository.new);
  getIt.registerLazySingleton<TaskListRepository>(
    InMemoryTaskListRepository.new,
  );
  getIt.registerLazySingleton<FeedbackRepository>(
    InMemoryFeedbackRepository.new,
  );
  getIt.registerLazySingleton<ReportRepository>(InMemoryReportRepository.new);

  // Task Use Cases
  getIt.registerLazySingleton(() => CreateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => ListTasks(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => UpdateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => DeleteTask(getIt<TaskRepository>()));

  // TaskList Use Cases
  getIt.registerLazySingleton(
    () => CreateTaskList(getIt<TaskListRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetTaskList(
      taskListRepository: getIt<TaskListRepository>(),
      taskRepository: getIt<TaskRepository>(),
    ),
  );
  getIt.registerLazySingleton(() => ListTaskLists(getIt<TaskListRepository>()));
  getIt.registerLazySingleton(
    () => UpdateTaskList(getIt<TaskListRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteTaskList(
      taskListRepository: getIt<TaskListRepository>(),
      taskRepository: getIt<TaskRepository>(),
    ),
  );

  // Feedback Use Cases
  getIt.registerLazySingleton(
    () => SubmitFeedback(getIt<FeedbackRepository>()),
  );

  // Reporting Use Cases
  getIt.registerLazySingleton(
    () => SubmitReports(getIt<ReportRepository>()),
  );

  // Handlers
  getIt.registerLazySingleton(
    () => TaskHandler(
      createTask: getIt<CreateTask>(),
      getTask: getIt<GetTask>(),
      updateTask: getIt<UpdateTask>(),
      deleteTask: getIt<DeleteTask>(),
      taskRepository: getIt<TaskRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => TaskListHandler(
      createTaskList: getIt<CreateTaskList>(),
      getTaskList: getIt<GetTaskList>(),
      listTaskLists: getIt<ListTaskLists>(),
      updateTaskList: UpdateTaskList(getIt<TaskListRepository>()),
      deleteTaskList: DeleteTaskList(
        taskListRepository: getIt<TaskListRepository>(),
        taskRepository: getIt<TaskRepository>(),
      ),
    ),
  );

  getIt.registerLazySingleton(() => WebHandler(getIt<ViewRenderer>()));

  getIt.registerLazySingleton(
    () => FeedbackHandler(submitFeedback: getIt<SubmitFeedback>()),
  );

  getIt.registerLazySingleton(
    () => ReportHandler(
      submitReports: getIt<SubmitReports>(),
    ),
  );
}
