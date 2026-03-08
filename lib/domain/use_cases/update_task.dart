import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../exceptions.dart';

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<Task> execute(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    final existing = await repository.get(id);
    if (existing == null) {
      throw TaskNotFoundException(id);
    }

    final updated = existing.copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );

    return await repository.update(updated);
  }
}
