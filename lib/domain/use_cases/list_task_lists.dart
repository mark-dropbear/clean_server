import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';

/// Use case for listing all task lists.
class ListTaskLists {
  /// The repository for task lists.
  final TaskListRepository repository;

  /// Creates a [ListTaskLists] use case.
  ListTaskLists(this.repository);

  /// Executes the use case.
  Future<List<TaskList>> execute() {
    return repository.list();
  }
}
