import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/feedback/domain/entities/feedback_form.dart';
import 'package:test/test.dart';

void main() {
  group('FeedbackForm Entity', () {
    test('should create a valid feedback form', () {
      final now = DateTime.now();
      final feedback = FeedbackForm(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        message: 'This is a test message.',
        createdAt: now,
      );
      expect(feedback.id, '1');
      expect(feedback.name, 'John Doe');
      expect(feedback.email, 'john@example.com');
      expect(feedback.message, 'This is a test message.');
      expect(feedback.createdAt, now);
    });

    test('should throw InvalidFeedbackException if id is empty', () {
      expect(
        () => FeedbackForm(
          id: '',
          name: 'John',
          email: 'j@e.com',
          message: 'Message 123',
          createdAt: DateTime.now(),
        ),
        throwsA(isA<InvalidFeedbackException>()),
      );
    });

    test('should throw InvalidFeedbackException if name is too short', () {
      expect(
        () => FeedbackForm(
          id: '1',
          name: 'A',
          email: 'j@e.com',
          message: 'Message 123',
          createdAt: DateTime.now(),
        ),
        throwsA(isA<InvalidFeedbackException>()),
      );
    });

    test('should throw InvalidFeedbackException if email is invalid', () {
      expect(
        () => FeedbackForm(
          id: '1',
          name: 'John',
          email: 'invalid-email',
          message: 'Message 123',
          createdAt: DateTime.now(),
        ),
        throwsA(isA<InvalidFeedbackException>()),
      );
    });

    test('should throw InvalidFeedbackException if message is too short', () {
      expect(
        () => FeedbackForm(
          id: '1',
          name: 'John',
          email: 'j@e.com',
          message: 'Short',
          createdAt: DateTime.now(),
        ),
        throwsA(isA<InvalidFeedbackException>()),
      );
    });

    test('copyWith should return a new instance with updated values', () {
      final feedback = FeedbackForm(
        id: '1',
        name: 'John',
        email: 'j@e.com',
        message: 'Original message',
        createdAt: DateTime.now(),
      );
      final updated = feedback.copyWith(
        name: 'Jane',
        message: 'New message 123',
      );

      expect(updated.id, '1');
      expect(updated.name, 'Jane');
      expect(updated.email, 'j@e.com');
      expect(updated.message, 'New message 123');
      expect(updated.createdAt, feedback.createdAt);
    });
  });
}
