import '../entities/task_list.dart';

/// Repository interface for managing [TaskList] entities.
abstract class TaskListRepository {
  /// Persists a new [TaskList].
  Future<void> save(TaskList taskList);

  /// Retrieves a [TaskList] by its [id].
  Future<TaskList?> getById(String id);

  /// Retrieves all task lists.
  Future<List<TaskList>> list();

  /// Updates an existing [TaskList].
  Future<void> update(TaskList taskList);

  /// Deletes a [TaskList] by its [id].
  Future<void> delete(String id);
}
