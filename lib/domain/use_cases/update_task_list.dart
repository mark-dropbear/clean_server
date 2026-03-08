import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';
import '../exceptions.dart';

class UpdateTaskList {
  final TaskListRepository repository;
  UpdateTaskList(this.repository);

  Future<TaskList> execute(
    String id, {
    String? title,
    String? description,
  }) async {
    final existing = await repository.get(id);
    if (existing == null) {
      throw TaskListNotFoundException(id);
    }

    final updated = existing.copyWith(title: title, description: description);

    return await repository.update(updated);
  }
}
