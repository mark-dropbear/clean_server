import 'package:slugid/slugid.dart';
import '../entities/feedback_form.dart';
import '../repositories/feedback_repository.dart';

/// Use case for submitting feedback.
class SubmitFeedback {
  /// The repository for feedback.
  final FeedbackRepository feedbackRepository;

  /// Creates a [SubmitFeedback] use case.
  SubmitFeedback(this.feedbackRepository);

  /// Executes the use case.
  Future<FeedbackForm> execute({
    required String name,
    required String email,
    required String message,
  }) async {
    final feedback = FeedbackForm(
      id: Slugid.nice().toString(),
      name: name,
      email: email,
      message: message,
      createdAt: DateTime.now().toUtc(),
    );

    await feedbackRepository.save(feedback);
    return feedback;
  }
}
