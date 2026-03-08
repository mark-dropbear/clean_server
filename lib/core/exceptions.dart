/// Base class for all domain-specific exceptions.
abstract class DomainException implements Exception {
  /// The error message.
  final String message;

  /// Creates a new [DomainException] with the given [message].
  DomainException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a task operation is invalid.
class InvalidTaskException extends DomainException {
  /// Creates a new [InvalidTaskException].
  InvalidTaskException(super.message);
}

/// Thrown when feedback form data is invalid.
class InvalidFeedbackException extends DomainException {
  /// Creates a new [InvalidFeedbackException].
  InvalidFeedbackException(super.message);
}

/// Thrown when a task cannot be found.
class TaskNotFoundException extends DomainException {
  /// Creates a new [TaskNotFoundException].
  TaskNotFoundException(String id) : super('Task not found: $id');
}

/// Thrown when a task list cannot be found.
class TaskListNotFoundException extends DomainException {
  /// Creates a new [TaskListNotFoundException].
  TaskListNotFoundException(String id) : super('Task list not found: $id');
}

/// Thrown when feedback cannot be found.
class FeedbackNotFoundException extends DomainException {
  /// Creates a new [FeedbackNotFoundException].
  FeedbackNotFoundException(String id) : super('Feedback not found: $id');
}
