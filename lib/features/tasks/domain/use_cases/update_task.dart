import 'package:clean_server/core/exceptions.dart' show TaskNotFoundException;

import '../../../../core/exceptions.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case for updating an existing task.
class UpdateTask {
  /// The repository for tasks.
  final TaskRepository taskRepository;

  /// Creates an [UpdateTask] use case.
  UpdateTask(this.taskRepository);

  /// Executes the use case.
  ///
  /// Throws [TaskNotFoundException] if the task doesn't exist.
  Future<Task> execute(
    String id, {
    String? title,
    String? description,
    bool? isCompleted,
    String? taskListId,
  }) async {
    final task = await taskRepository.getById(id);
    if (task == null) {
      throw TaskNotFoundException(id);
    }

    final updatedTask = task.copyWith(
      title: title,
      description: description,
      isCompleted: isCompleted,
      taskListId: taskListId,
    );

    await taskRepository.update(updatedTask);
    return updatedTask;
  }
}
