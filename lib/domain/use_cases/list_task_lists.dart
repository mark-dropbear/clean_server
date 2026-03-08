import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';

class ListTaskLists {
  final TaskListRepository repository;
  ListTaskLists(this.repository);

  Future<List<TaskList>> execute() async {
    return await repository.list();
  }
}
