import '../exceptions.dart';

/// Represents a task in our system.
/// This is a pure domain entity, agnostic of any serialization or persistence mechanism.
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
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
    if (title.isEmpty) {
      throw InvalidTaskException('Task title cannot be empty');
    }
  }

  /// Creates a copy of the task with updated fields.
  Task copyWith({String? title, String? description, bool? isCompleted}) {
    return Task(
      id: id,
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
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode;
}
