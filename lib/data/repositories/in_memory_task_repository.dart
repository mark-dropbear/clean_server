import 'package:logging/logging.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// An in-memory implementation of the [TaskRepository].
class InMemoryTaskRepository implements TaskRepository {
  static final _logger = Logger('InMemoryTaskRepository');
  final Map<String, Task> _tasks = {};

  @override
  Future<void> save(Task task) async {
    _logger.fine('Saving task: ${task.id} (list: ${task.taskListId})');
    _tasks[task.id] = task;
  }

  @override
  Future<void> delete(String id) async {
    _logger.fine('Deleting task: $id');
    _tasks.remove(id);
  }

  @override
  Future<void> deleteByTaskListId(String taskListId) async {
    _logger.fine('Deleting all tasks for list: $taskListId');
    _tasks.removeWhere((id, task) => task.taskListId == taskListId);
  }

  @override
  Future<Task?> getById(String id) async {
    _logger.fine('Getting task: $id');
    return _tasks[id];
  }

  @override
  Future<List<Task>> list() async {
    _logger.fine('Listing all tasks');
    return _tasks.values.toList();
  }

  @override
  Future<List<Task>> getByTaskListId(String taskListId) async {
    _logger.fine('Getting tasks for list: $taskListId');
    return _tasks.values
        .where((task) => task.taskListId == taskListId)
        .toList();
  }

  @override
  Future<void> update(Task task) async {
    _logger.fine('Updating task: ${task.id}');
    _tasks[task.id] = task;
  }
}
