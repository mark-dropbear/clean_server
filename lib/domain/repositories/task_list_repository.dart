import '../entities/task_list.dart';

abstract class TaskListRepository {
  Future<TaskList> create(TaskList taskList);
  Future<TaskList?> get(String id);
  Future<List<TaskList>> list();
  Future<TaskList> update(TaskList taskList);
  Future<void> delete(String id);
}
