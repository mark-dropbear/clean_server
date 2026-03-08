import '../../domain/entities/task_list.dart';
import 'task_mapper.dart';

/// Extension on [TaskList] to provide mapping logic.
extension TaskListMapper on TaskList {
  /// Converts this [TaskList] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tasks': tasks.map((t) => t.toMap()).toList(),
    };
  }
}

/// Creates a [TaskList] from a [Map].
TaskList taskListFromMap(Map<String, dynamic> map) {
  return TaskList(
    id: map['id'] as String,
    title: map['title'] as String,
    description: (map['description'] as String?) ?? '',
    tasks:
        (map['tasks'] as List?)
            ?.map((t) => taskFromMap(t as Map<String, dynamic>))
            .toList() ??
        [],
  );
}
