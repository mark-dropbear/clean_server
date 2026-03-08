import 'package:clean_server/domain/entities/feedback_form.dart';
import 'package:clean_server/domain/repositories/feedback_repository.dart';

/// In-memory implementation of [FeedbackRepository].
class InMemoryFeedbackRepository implements FeedbackRepository {
  final Map<String, FeedbackForm> _feedback = {};

  @override
  Future<void> save(FeedbackForm feedback) async {
    _feedback[feedback.id] = feedback;
  }

  @override
  Future<FeedbackForm?> getById(String id) async {
    return _feedback[id];
  }

  @override
  Future<List<FeedbackForm>> list() async {
    return _feedback.values.toList();
  }

  @override
  Future<void> delete(String id) async {
    _feedback.remove(id);
  }
}
