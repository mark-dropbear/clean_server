import '../../domain/entities/task.dart';

/// Handles conversion between Task entities and plain Map objects.
/// This exists in the data layer to keep the domain layer pure.
class TaskMapper {
  /// Converts a Task entity to a Map.
  static Map<String, dynamic> toMap(Task task) {
    return {
      'id': task.id,
      'task_list_id': task.taskListId,
      'title': task.title,
      'description': task.description,
      'is_completed': task.isCompleted,
    };
  }

  /// Creates a Task entity from a Map.
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      taskListId: map['task_list_id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      isCompleted: (map['is_completed'] as bool?) ?? false,
    );
  }
}
