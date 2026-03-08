import '../../domain/entities/task_list.dart';
import 'task_mapper.dart';

class TaskListMapper {
  static Map<String, dynamic> toMap(TaskList taskList) {
    return {
      'id': taskList.id,
      'title': taskList.title,
      'description': taskList.description,
      'tasks': taskList.tasks.map(TaskMapper.toMap).toList(),
    };
  }

  static TaskList fromMap(Map<String, dynamic> map) {
    return TaskList(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      tasks:
          (map['tasks'] as List?)
              ?.map((t) => TaskMapper.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
