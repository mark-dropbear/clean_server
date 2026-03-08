import '../entities/task.dart';
import '../repositories/task_repository.dart';

class ListTasks {
  final TaskRepository repository;
  ListTasks(this.repository);

  Future<List<Task>> execute() async {
    return await repository.list();
  }
}
