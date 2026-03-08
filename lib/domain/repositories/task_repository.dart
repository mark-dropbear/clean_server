import '../entities/task.dart';

/// Define how we can interact with tasks in storage.
/// This interface lives in the domain layer.
abstract class TaskRepository {
  Future<Task> create(Task task);
  Future<Task?> get(String id);
  Future<List<Task>> list();
  Future<Task> update(Task task);
  Future<void> delete(String id);
}
