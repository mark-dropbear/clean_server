import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for retrieving a specific task.
class GetTask {
  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [GetTask] use case.
  GetTask(this.taskRepository);

  /// Executes the use case.
  Future<Task?> execute(String id) {
    return taskRepository.getById(id);
  }
}
