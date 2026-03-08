import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../exceptions.dart';

class GetTask {
  final TaskRepository repository;
  GetTask(this.repository);

  Future<Task> execute(String id) async {
    final task = await repository.get(id);
    if (task == null) {
      throw TaskNotFoundException(id);
    }
    return task;
  }
}
