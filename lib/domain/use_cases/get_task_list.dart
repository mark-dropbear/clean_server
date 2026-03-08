import '../entities/task_list.dart';
import '../repositories/task_list_repository.dart';
import '../repositories/task_repository.dart';
import '../exceptions.dart';

class GetTaskList {
  final TaskListRepository taskListRepository;
  final TaskRepository taskRepository;

  GetTaskList({required this.taskListRepository, required this.taskRepository});

  Future<TaskList> execute(String id) async {
    final taskList = await taskListRepository.get(id);
    if (taskList == null) {
      throw TaskListNotFoundException(id);
    }

    final tasks = await taskRepository.listByTaskListId(id);
    return taskList.copyWith(tasks: tasks);
  }
}
