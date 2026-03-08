import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// An in-memory implementation of the [TaskRepository].
class InMemoryTaskRepository implements TaskRepository {
  final Map<String, Task> _tasks = {};

  @override
  Future<void> save(Task task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<void> delete(String id) async {
    _tasks.remove(id);
  }

  @override
  Future<void> deleteByTaskListId(String taskListId) async {
    _tasks.removeWhere((id, task) => task.taskListId == taskListId);
  }

  @override
  Future<Task?> getById(String id) async {
    return _tasks[id];
  }

  @override
  Future<List<Task>> list() async {
    return _tasks.values.toList();
  }

  @override
  Future<List<Task>> getByTaskListId(String taskListId) async {
    return _tasks.values
        .where((task) => task.taskListId == taskListId)
        .toList();
  }

  @override
  Future<void> update(Task task) async {
    _tasks[task.id] = task;
  }
}
