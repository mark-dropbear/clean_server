import 'package:meta/meta.dart';
import '../exceptions.dart';
import 'task.dart';

/// Represents a list of tasks.
@immutable
class TaskList {
  /// The unique identifier for the task list.
  final String id;

  /// The title of the task list.
  final String title;

  /// A detailed description of the task list.
  final String description;

  /// The collection of tasks within this list.
  final List<Task> tasks;

  /// Creates a new [TaskList] instance.
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

  /// Creates a copy of the task list with updated fields.
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
