import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';
import '../repositories/task_repository.dart';

/// Use case for retrieving a specific task list with its tasks.
class GetTaskList {
  /// The repository for task lists.
  final TaskListRepository taskListRepository;

  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [GetTaskList] use case.
  GetTaskList({required this.taskListRepository, required this.taskRepository});

  /// Executes the use case.
  Future<TaskList?> execute(String id) async {
    final list = await taskListRepository.getById(id);
    if (list == null) return null;

    final tasks = await taskRepository.getByTaskListId(id);
    return list.copyWith(tasks: tasks);
  }
}
