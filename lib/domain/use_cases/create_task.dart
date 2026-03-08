import 'package:slugid/slugid.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// The use case for creating a new task.
class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  /// Executes the use case.
  /// This can take raw values and turn them into a Domain Entity for validation.
  Future<Task> execute({required String title, String description = ''}) async {
    final task = Task(
      id: Slugid.nice().toString(),
      title: title,
      description: description,
    );

    return await repository.create(task);
  }
}
