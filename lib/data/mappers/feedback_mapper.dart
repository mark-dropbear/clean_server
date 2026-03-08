import '../../domain/entities/feedback_form.dart';

/// Extension on [FeedbackForm] to provide mapping logic.
extension FeedbackMapper on FeedbackForm {
  /// Converts this [FeedbackForm] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Converts this [FeedbackForm] to a JSON-LD Map compatible with Schema.org Message.
  Map<String, dynamic> toJsonLd() {
    return {
      '@context': 'https://schema.org',
      '@type': 'Message',
      '@id': id,
      'datePublished': createdAt.toIso8601String(),
      'text': message,
      'sender': {'@type': 'Person', 'name': name, 'email': email},
    };
  }
}

/// Creates a [FeedbackForm] from a [Map].
FeedbackForm feedbackFromMap(Map<String, dynamic> map) {
  return FeedbackForm(
    id: map['id'] as String,
    name: map['name'] as String,
    email: map['email'] as String,
    message: map['message'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
