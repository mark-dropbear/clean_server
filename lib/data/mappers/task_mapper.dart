import '../../domain/entities/task.dart';

/// Extension on [Task] to provide mapping logic.
extension TaskMapper on Task {
  /// Converts this [Task] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_list_id': taskListId,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }
}

/// Creates a [Task] from a [Map].
Task taskFromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] as String,
    taskListId: map['task_list_id'] as String,
    title: map['title'] as String,
    description: (map['description'] as String?) ?? '',
    isCompleted: (map['is_completed'] as bool?) ?? false,
  );
}
