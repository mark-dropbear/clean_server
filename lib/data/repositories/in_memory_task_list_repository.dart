import '../../domain/entities/task_list.dart';
import '../../domain/repositories/task_list_repository.dart';

/// In-memory implementation of [TaskListRepository].
class InMemoryTaskListRepository implements TaskListRepository {
  final Map<String, TaskList> _taskLists = {};

  @override
  Future<void> save(TaskList taskList) async {
    _taskLists[taskList.id] = taskList;
  }

  @override
  Future<void> delete(String id) async {
    _taskLists.remove(id);
  }

  @override
  Future<TaskList?> getById(String id) async {
    return _taskLists[id];
  }

  @override
  Future<List<TaskList>> list() async {
    return _taskLists.values.toList();
  }

  @override
  Future<void> update(TaskList taskList) async {
    _taskLists[taskList.id] = taskList;
  }
}
