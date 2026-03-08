import '../entities/task_list.dart';
import '../exceptions.dart';
import '../repositories/task_list_repository.dart';

/// Use case for updating an existing task list.
class UpdateTaskList {
  /// The repository for task lists.
  final TaskListRepository taskListRepository;

  /// Creates an [UpdateTaskList] use case.
  UpdateTaskList(this.taskListRepository);

  /// Executes the use case.
  ///
  /// Throws [TaskListNotFoundException] if the list doesn't exist.
  Future<TaskList> execute(
    String id, {
    String? title,
    String? description,
  }) async {
    final list = await taskListRepository.getById(id);
    if (list == null) {
      throw TaskListNotFoundException(id);
    }

    final updatedList = list.copyWith(title: title, description: description);

    await taskListRepository.update(updatedList);
    return updatedList;
  }
}
