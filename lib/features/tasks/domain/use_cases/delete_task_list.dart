import '../repositories/task_list_repository.dart';
import '../repositories/task_repository.dart';

/// Use case for deleting a task list and its associated tasks.
class DeleteTaskList {
  /// The repository for task lists.
  final TaskListRepository taskListRepository;

  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [DeleteTaskList] use case.
  DeleteTaskList({
    required this.taskListRepository,
    required this.taskRepository,
  });

  /// Executes the use case.
  Future<void> execute(String id) async {
    // Cascade delete: first delete all tasks in the list
    await taskRepository.deleteByTaskListId(id);
    // Then delete the list itself
    return taskListRepository.delete(id);
  }
}
