import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// An in-memory implementation of the TaskRepository.
/// This is perfect for development and unit testing.
class InMemoryTaskRepository implements TaskRepository {
  final Map<String, Task> _tasks = {};

  @override
  Future<Task> create(Task task) async {
    _tasks[task.id] = task;
    return task;
  }

  @override
  Future<void> delete(String id) async {
    _tasks.remove(id);
  }

  @override
  Future<Task?> get(String id) async {
    return _tasks[id];
  }

  @override
  Future<List<Task>> list() async {
    return _tasks.values.toList();
  }

  @override
  Future<Task> update(Task task) async {
    _tasks[task.id] = task;
    return task;
  }
}
