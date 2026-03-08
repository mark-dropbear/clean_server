import 'package:slugid/slugid.dart';
import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';

class CreateTaskList {
  final TaskListRepository repository;
  CreateTaskList(this.repository);

  Future<TaskList> execute({
    required String title,
    String description = '',
  }) async {
    final taskList = TaskList(
      id: Slugid.nice().toString(),
      title: title,
      description: description,
    );

    return await repository.create(taskList);
  }
}
