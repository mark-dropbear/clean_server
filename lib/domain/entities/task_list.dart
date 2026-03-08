import '../exceptions.dart';
import 'task.dart';

/// Represents a list of tasks.
class TaskList {
  final String id;
  final String title;
  final String description;
  final List<Task> tasks;

  TaskList({
    required this.id,
    required this.title,
    this.description = '',
    this.tasks = const [],
  }) {
    _validate();
  }

  void _validate() {
    if (id.isEmpty) {
      throw InvalidTaskException('TaskList ID cannot be empty');
    }
    if (title.isEmpty) {
      throw InvalidTaskException('TaskList title cannot be empty');
    }
  }

  TaskList copyWith({String? title, String? description, List<Task>? tasks}) {
    return TaskList(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          tasks == other.tasks;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ^ tasks.hashCode;
}
