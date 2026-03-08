import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for listing all tasks.
class ListTasks {
  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [ListTasks] use case.
  ListTasks(this.taskRepository);

  /// Executes the use case.
  Future<List<Task>> execute() {
    return taskRepository.list();
  }
}
