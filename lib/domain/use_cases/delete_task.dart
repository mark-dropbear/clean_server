import '../repositories/task_repository.dart';

/// Use case for deleting a task.
class DeleteTask {
  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [DeleteTask] use case.
  DeleteTask(this.taskRepository);

  /// Executes the use case.
  Future<void> execute(String id) {
    return taskRepository.delete(id);
  }
}
