import 'package:get_it/get_it.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/repositories/task_list_repository.dart';
import '../data/repositories/in_memory_task_repository.dart';
import '../data/repositories/in_memory_task_list_repository.dart';
import '../domain/use_cases/create_task.dart';
import '../domain/use_cases/get_task.dart';
import '../domain/use_cases/list_tasks.dart';
import '../domain/use_cases/update_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../domain/use_cases/create_task_list.dart';
import '../domain/use_cases/get_task_list.dart';
import '../domain/use_cases/list_task_lists.dart';
import '../domain/use_cases/update_task_list.dart';
import '../domain/use_cases/delete_task_list.dart';
import '../api/task_handler.dart';
import '../api/task_list_handler.dart';
import '../api/web_handler.dart';
import '../api/view_renderer.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton(() => ViewRenderer());

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(() => InMemoryTaskRepository());
  getIt.registerLazySingleton<TaskListRepository>(
    () => InMemoryTaskListRepository(),
  );

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
      updateTaskList: getIt<UpdateTaskList>(),
      deleteTaskList: getIt<DeleteTaskList>(),
    ),
  );

  getIt.registerLazySingleton(() => WebHandler(getIt<ViewRenderer>()));
}
