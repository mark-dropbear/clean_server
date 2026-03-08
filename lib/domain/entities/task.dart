import 'package:meta/meta.dart';
import '../exceptions.dart';

/// Represents a task in our system.
/// This is a pure domain entity, agnostic of any serialization or persistence mechanism.
@immutable
class Task {
  /// The unique identifier for the task.
  final String id;

  /// The unique identifier for the task list this task belongs to.
  final String taskListId;

  /// The title of the task.
  final String title;

  /// A detailed description of the task.
  final String description;

  /// Whether the task is completed.
  final bool isCompleted;

  /// Creates a new [Task] instance.
  Task({
    required this.id,
    required this.taskListId,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  }) {
    _validate();
  }

  /// Internal validation logic to ensure intrinsic validity.
  void _validate() {
    if (id.isEmpty) {
      throw InvalidTaskException('Task ID cannot be empty');
    }
    if (taskListId.isEmpty) {
      throw InvalidTaskException('Task List ID cannot be empty');
    }
    if (title.isEmpty) {
      throw InvalidTaskException('Task title cannot be empty');
    }
  }

  /// Creates a copy of the task with updated fields.
  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    String? taskListId,
  }) {
    return Task(
      id: id,
      taskListId: taskListId ?? this.taskListId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskListId == other.taskListId &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      taskListId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode;
}
