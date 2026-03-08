import '../../domain/entities/task_list.dart';
import '../../domain/repositories/task_list_repository.dart';

class InMemoryTaskListRepository implements TaskListRepository {
  final Map<String, TaskList> _taskLists = {};

  @override
  Future<TaskList> create(TaskList taskList) async {
    _taskLists[taskList.id] = taskList;
    return taskList;
  }

  @override
  Future<void> delete(String id) async {
    _taskLists.remove(id);
  }

  @override
  Future<TaskList?> get(String id) async {
    return _taskLists[id];
  }

  @override
  Future<List<TaskList>> list() async {
    return _taskLists.values.toList();
  }

  @override
  Future<TaskList> update(TaskList taskList) async {
    _taskLists[taskList.id] = taskList;
    return taskList;
  }
}
