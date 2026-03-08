import 'package:logging/logging.dart';
import '../../domain/entities/task_list.dart';
import '../../domain/repositories/task_list_repository.dart';

/// In-memory implementation of [TaskListRepository].
class InMemoryTaskListRepository implements TaskListRepository {
  static final _logger = Logger('InMemoryTaskListRepository');
  final Map<String, TaskList> _taskLists = {};

  @override
  Future<void> save(TaskList taskList) async {
    _logger.fine('Saving task list: ${taskList.id}');
    _taskLists[taskList.id] = taskList;
  }

  @override
  Future<void> delete(String id) async {
    _logger.fine('Deleting task list: $id');
    _taskLists.remove(id);
  }

  @override
  Future<TaskList?> getById(String id) async {
    _logger.fine('Getting task list: $id');
    return _taskLists[id];
  }

  @override
  Future<List<TaskList>> list() async {
    _logger.fine('Listing all task lists');
    return _taskLists.values.toList();
  }

  @override
  Future<void> update(TaskList taskList) async {
    _logger.fine('Updating task list: ${taskList.id}');
    _taskLists[taskList.id] = taskList;
  }
}
