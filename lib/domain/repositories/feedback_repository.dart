import '../entities/feedback_form.dart';

/// Repository interface for managing [FeedbackForm] entities.
abstract class FeedbackRepository {
  /// Persists a new [FeedbackForm].
  Future<void> save(FeedbackForm feedback);

  /// Retrieves a [FeedbackForm] by its [id].
  Future<FeedbackForm?> getById(String id);

  /// Retrieves all feedback submissions.
  Future<List<FeedbackForm>> list();

  /// Deletes a [FeedbackForm] by its [id].
  Future<void> delete(String id);
}
