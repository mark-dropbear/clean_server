import 'package:clean_server/data/mappers/feedback_mapper.dart';
import 'package:clean_server/domain/entities/feedback_form.dart';
import 'package:test/test.dart';

void main() {
  group('FeedbackMapper', () {
    final now = DateTime.now().toUtc();
    final feedback = FeedbackForm(
      id: 'fb-1',
      name: 'John Doe',
      email: 'john@example.com',
      message: 'Hello World',
      createdAt: now,
    );

    test('toMap should convert FeedbackForm to Map correctly', () {
      final map = feedback.toMap();

      expect(map['id'], equals('fb-1'));
      expect(map['name'], equals('John Doe'));
      expect(map['email'], equals('john@example.com'));
      expect(map['message'], equals('Hello World'));
      expect(map['created_at'], equals(now.toIso8601String()));
    });

    test('feedbackFromMap should convert Map to FeedbackForm correctly', () {
      final map = {
        'id': 'fb-1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'message': 'Hello World',
        'created_at': now.toIso8601String(),
      };

      final result = feedbackFromMap(map);

      expect(result.id, equals('fb-1'));
      expect(result.name, equals('John Doe'));
      expect(result.email, equals('john@example.com'));
      expect(result.message, equals('Hello World'));
      // Compare ISO strings to avoid millisecond precision issues if any
      expect(result.createdAt.toIso8601String(), equals(now.toIso8601String()));
    });

    test('toJsonLd should convert FeedbackForm to Message correctly', () {
      final jsonLd = feedback.toJsonLd();

      expect(jsonLd['@context'], equals('https://schema.org'));
      expect(jsonLd['@type'], equals('Message'));
      expect(jsonLd['@id'], equals('fb-1'));
      expect(jsonLd['datePublished'], equals(now.toIso8601String()));
      expect(jsonLd['text'], equals('Hello World'));

      final sender = jsonLd['sender'] as Map<String, dynamic>;
      expect(sender['@type'], equals('Person'));
      expect(sender['name'], equals('John Doe'));
      expect(sender['email'], equals('john@example.com'));
    });
  });
}
