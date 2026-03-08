import 'package:get_it/get_it.dart';
import '../domain/repositories/task_repository.dart';
import '../data/repositories/in_memory_task_repository.dart';
import '../domain/use_cases/create_task.dart';
import '../domain/use_cases/get_task.dart';
import '../domain/use_cases/list_tasks.dart';
import '../domain/use_cases/update_task.dart';
import '../domain/use_cases/delete_task.dart';
import '../api/task_handler.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies.
void setupLocator() {
  // Repositories
  getIt.registerLazySingleton<TaskRepository>(() => InMemoryTaskRepository());

  // Use Cases
  getIt.registerLazySingleton(() => CreateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => ListTasks(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => UpdateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => DeleteTask(getIt<TaskRepository>()));

  // Handlers
  getIt.registerLazySingleton(
    () => TaskHandler(
      createTask: getIt<CreateTask>(),
      getTask: getIt<GetTask>(),
      listTasks: getIt<ListTasks>(),
      updateTask: getIt<UpdateTask>(),
      deleteTask: getIt<DeleteTask>(),
    ),
  );
}
