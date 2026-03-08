import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import '../data/mappers/feedback_mapper.dart';
import '../domain/exceptions.dart';
import '../domain/use_cases/submit_feedback.dart';

/// Handles HTTP requests for the Feedback resource.
class FeedbackHandler {
  static final _logger = Logger('FeedbackHandler');
  final SubmitFeedback _submitFeedback;

  /// Creates a [FeedbackHandler].
  FeedbackHandler({required SubmitFeedback submitFeedback})
    : _submitFeedback = submitFeedback;

  /// Submits new feedback.
  Future<Response> submit(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Request body is empty'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final data = jsonDecode(body) as Map<String, dynamic>;

      final name = data['name'] as String?;
      final email = data['email'] as String?;
      final message = data['message'] as String?;

      if (name == null || email == null || message == null) {
        return Response.badRequest(
          body: jsonEncode({
            'error': 'Missing required fields: name, email, message',
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      _logger.info('Submitting feedback from $name ($email)');
      final feedback = await _submitFeedback.execute(
        name: name,
        email: email,
        message: message,
      );

      return Response(
        201,
        body: jsonEncode(feedback.toJsonLd()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidFeedbackException catch (e) {
      _logger.warning('Invalid feedback data', e);
      return Response.badRequest(
        body: jsonEncode({'error': e.message}),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e) {
      _logger.warning('Invalid JSON format', e);
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid JSON format'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e, st) {
      _logger.severe('Error submitting feedback', e, st);
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
