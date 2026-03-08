import '../repositories/task_repository.dart';
import '../exceptions.dart';

class DeleteTask {
  final TaskRepository repository;
  DeleteTask(this.repository);

  Future<void> execute(String id) async {
    final existing = await repository.get(id);
    if (existing == null) {
      throw TaskNotFoundException(id);
    }
    await repository.delete(id);
  }
}
