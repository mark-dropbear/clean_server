import '../repositories/task_list_repository.dart';
import '../repositories/task_repository.dart';
import '../exceptions.dart';

class DeleteTaskList {
  final TaskListRepository taskListRepository;
  final TaskRepository taskRepository;

  DeleteTaskList({
    required this.taskListRepository,
    required this.taskRepository,
  });

  Future<void> execute(String id) async {
    final existing = await taskListRepository.get(id);
    if (existing == null) {
      throw TaskListNotFoundException(id);
    }

    // Cascade delete
    await taskRepository.deleteByTaskListId(id);
    await taskListRepository.delete(id);
  }
}
