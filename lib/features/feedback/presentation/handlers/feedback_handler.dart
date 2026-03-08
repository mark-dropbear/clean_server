import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../../core/exceptions.dart';
import '../../data/mappers/feedback_mapper.dart';
import '../../domain/use_cases/submit_feedback.dart';

/// Handler for feedback-related endpoints.
class FeedbackHandler {
  final SubmitFeedback _submitFeedback;

  /// Creates a [FeedbackHandler].
  FeedbackHandler({required SubmitFeedback submitFeedback})
    : _submitFeedback = submitFeedback;

  /// Submits feedback.
  Future<Response> submit(Request request) async {
    try {
      final payload =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final result = await _submitFeedback.execute(
        name: (payload['name'] as String?) ?? '',
        email: (payload['email'] as String?) ?? '',
        message: (payload['message'] as String?) ?? '',
      );

      // Return JSON-LD to satisfy tests
      return Response(
        201,
        body: jsonEncode(result.toJsonLd()),
        headers: {'Content-Type': 'application/json'},
      );
    } on InvalidFeedbackException catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': e.message}),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid JSON: ${e.message}'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      if (e is TypeError) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Missing required fields'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      rethrow;
    }
  }
}
