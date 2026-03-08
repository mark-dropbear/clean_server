/// Base class for all domain exceptions.
abstract class DomainException implements Exception {
  final String message;
  DomainException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a task is invalid.
class InvalidTaskException extends DomainException {
  InvalidTaskException(super.message);
}

/// Thrown when a task is not found.
class TaskNotFoundException extends DomainException {
  final String id;
  TaskNotFoundException(this.id) : super('Task with ID $id not found');
}
