import 'package:clean_server/data/repositories/in_memory_feedback_repository.dart';
import 'package:clean_server/domain/use_cases/submit_feedback.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryFeedbackRepository repository;
  late SubmitFeedback submitUseCase;

  setUp(() {
    repository = InMemoryFeedbackRepository();
    submitUseCase = SubmitFeedback(repository);
  });

  group('SubmitFeedback Use Case', () {
    test('should submit feedback and save it to repository', () async {
      final feedback = await submitUseCase.execute(
        name: 'John Doe',
        email: 'john@example.com',
        message: 'Hello, this is a test message.',
      );

      expect(feedback.name, 'John Doe');
      expect(feedback.email, 'john@example.com');
      expect(feedback.message, 'Hello, this is a test message.');
      expect(feedback.id, isNotEmpty);
      expect(feedback.createdAt, isNotNull);

      final savedFeedback = await repository.getById(feedback.id);

      expect(savedFeedback, equals(feedback));
    });
  });
}
