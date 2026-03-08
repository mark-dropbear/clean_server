import 'package:clean_server/data/repositories/in_memory_feedback_repository.dart';
import 'package:clean_server/domain/entities/feedback_form.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryFeedbackRepository repository;

  setUp(() {
    repository = InMemoryFeedbackRepository();
  });

  group('InMemoryFeedbackRepository', () {
    test('save and getById', () async {
      final feedback = FeedbackForm(
        id: '1',
        name: 'John',
        email: 'j@e.com',
        message: 'This is a long enough message.',
        createdAt: DateTime.now(),
      );
      await repository.save(feedback);

      final result = await repository.getById('1');
      expect(result, equals(feedback));
    });

    test('list', () async {
      final f1 = FeedbackForm(
        id: '1',
        name: 'J1',
        email: 'j1@e.com',
        message: 'Message 1 is long enough.',
        createdAt: DateTime.now(),
      );
      final f2 = FeedbackForm(
        id: '2',
        name: 'J2',
        email: 'j2@e.com',
        message: 'Message 2 is long enough.',
        createdAt: DateTime.now(),
      );
      await repository.save(f1);
      await repository.save(f2);

      final result = await repository.list();
      expect(result.length, equals(2));
      expect(result, contains(f1));
      expect(result, contains(f2));
    });

    test('delete', () async {
      final feedback = FeedbackForm(
        id: '1',
        name: 'John',
        email: 'j@e.com',
        message: 'This is a long enough message.',
        createdAt: DateTime.now(),
      );
      await repository.save(feedback);
      await repository.delete('1');

      final result = await repository.getById('1');
      expect(result, isNull);
    });
  });
}
