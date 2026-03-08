import 'package:meta/meta.dart';
import '../exceptions.dart';

/// Represents a feedback form submission.
@immutable
class FeedbackForm {
  /// The unique identifier for the feedback.
  final String id;

  /// The name of the person submitting the feedback.
  final String name;

  /// The email address of the person submitting the feedback.
  final String email;

  /// The feedback message.
  final String message;

  /// The date and time when the feedback was submitted.
  final DateTime createdAt;

  /// Creates a new [FeedbackForm] instance.
  FeedbackForm({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
  }) {
    _validate();
  }

  /// Internal validation logic to ensure intrinsic validity.
  void _validate() {
    if (id.isEmpty) {
      throw InvalidFeedbackException('Feedback ID cannot be empty');
    }
    if (name.isEmpty) {
      throw InvalidFeedbackException('Name cannot be empty');
    }
    if (name.length < 2 || name.length > 100) {
      throw InvalidFeedbackException(
        'Name must be between 2 and 100 characters',
      );
    }
    if (email.isEmpty) {
      throw InvalidFeedbackException('Email cannot be empty');
    }
    if (!email.contains('@')) {
      throw InvalidFeedbackException('Invalid email format');
    }
    if (message.isEmpty) {
      throw InvalidFeedbackException('Message cannot be empty');
    }
    if (message.length < 10 || message.length > 2000) {
      throw InvalidFeedbackException(
        'Message must be between 10 and 2000 characters',
      );
    }
  }

  /// Creates a copy of the feedback form with updated fields.
  FeedbackForm copyWith({String? name, String? email, String? message}) {
    return FeedbackForm(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackForm &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          message == other.message &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      message.hashCode ^
      createdAt.hashCode;
}
