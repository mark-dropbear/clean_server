import 'package:slugid/slugid.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for creating a new task.
class CreateTask {
  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates a [CreateTask] use case.
  CreateTask(this.taskRepository);

  /// Executes the use case.
  Future<Task> execute({
    required String taskListId,
    required String title,
    String description = '',
  }) {
    final task = Task(
      id: Slugid.nice().toString(),
      taskListId: taskListId,
      title: title,
      description: description,
    );
    return taskRepository.save(task).then((_) => task);
  }
}
