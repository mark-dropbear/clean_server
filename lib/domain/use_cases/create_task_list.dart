import 'package:slugid/slugid.dart';
import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';

/// Use case for creating a new task list.
class CreateTaskList {
  /// The repository for task lists.
  final TaskListRepository repository;

  /// Creates a [CreateTaskList] use case.
  CreateTaskList(this.repository);

  /// Executes the use case.
  Future<TaskList> execute({required String title, String description = ''}) {
    final taskList = TaskList(
      id: Slugid.nice().toString(),
      title: title,
      description: description,
    );
    return repository.save(taskList).then((_) => taskList);
  }
}
