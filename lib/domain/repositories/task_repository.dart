import '../entities/task.dart';

/// Repository interface for managing [Task] entities.
abstract class TaskRepository {
  /// Persists a new [Task].
  Future<void> save(Task task);

  /// Retrieves a [Task] by its [id].
  Future<Task?> getById(String id);

  /// Retrieves all tasks belonging to a specific [taskListId].
  Future<List<Task>> getByTaskListId(String taskListId);

  /// Retrieves all tasks.
  Future<List<Task>> list();

  /// Updates an existing [Task].
  Future<void> update(Task task);

  /// Deletes a [Task] by its [id].
  Future<void> delete(String id);

  /// Deletes all tasks belonging to a specific [taskListId].
  Future<void> deleteByTaskListId(String taskListId);
}
