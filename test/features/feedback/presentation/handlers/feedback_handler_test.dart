import 'dart:convert';

import 'package:clean_server/features/feedback/data/repositories/in_memory_feedback_repository.dart';
import 'package:clean_server/features/feedback/domain/use_cases/submit_feedback.dart';
import 'package:clean_server/features/feedback/presentation/handlers/feedback_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryFeedbackRepository repository;
  late FeedbackHandler handler;

  setUp(() {
    repository = InMemoryFeedbackRepository();
    handler = FeedbackHandler(submitFeedback: SubmitFeedback(repository));
  });

  group('FeedbackHandler', () {
    test('submit returns 201 and JSON-LD data', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/feedback'),
        body: jsonEncode({
          'name': 'John Doe',
          'email': 'john@example.com',
          'message': 'This is a test message that is long enough.',
        }),
      );

      final response = await handler.submit(request);

      expect(response.statusCode, equals(201));
      expect(response.headers['Content-Type'], equals('application/json'));

      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['@type'], equals('Message'));
      expect(
        body['text'],
        equals('This is a test message that is long enough.'),
      );
      final sender = body['sender'] as Map<String, dynamic>;
      expect(sender['name'], equals('John Doe'));
      expect(sender['email'], equals('john@example.com'));

      final allFeedback = await repository.list();
      expect(allFeedback.length, equals(1));
    });

    test('submit returns 400 for invalid data', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/feedback'),
        body: jsonEncode({
          'name': 'J', // Too short
          'email': 'john@example.com',
          'message': 'Message',
        }),
      );

      final response = await handler.submit(request);

      expect(response.statusCode, equals(400));
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body, contains('error'));
    });

    test('submit returns 400 for missing fields', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/feedback'),
        body: jsonEncode({
          'name': 'John Doe',
          // email and message missing
        }),
      );

      final response = await handler.submit(request);

      expect(response.statusCode, equals(400));
    });

    test('submit returns 400 for empty body', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/api/feedback'),
        body: '',
      );

      final response = await handler.submit(request);

      expect(response.statusCode, equals(400));
    });
  });
}
