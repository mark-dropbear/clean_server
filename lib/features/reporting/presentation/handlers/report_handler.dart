import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/use_cases/submit_deprecation_reports.dart';

/// Handler for browser reporting endpoints.
class ReportHandler {
  final SubmitDeprecationReports _submitDeprecationReports;

  /// Creates a [ReportHandler].
  ReportHandler({required SubmitDeprecationReports submitDeprecationReports})
    : _submitDeprecationReports = submitDeprecationReports;

  /// Handles deprecation reports.
  ///
  /// Expects a POST request with Content-Type: application/reports+json
  /// containing a JSON array of report objects.
  Future<Response> handleDeprecation(Request request) async {
    // 1. Validate Content-Type
    final contentType = request.headers['content-type'] ?? '';
    if (!contentType.contains('application/reports+json')) {
      return Response.badRequest(
        body: jsonEncode({
          'error':
              'Unsupported Content-Type. Expected application/reports+json',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    try {
      // 2. Read and parse body
      final body = await request.readAsString();
      final json = jsonDecode(body);

      if (json is! List) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Expected a JSON array of reports'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 3. Process reports
      final reportMaps = json.cast<Map<String, dynamic>>();
      await _submitDeprecationReports.execute(reportMaps);

      // 4. Return success (204 No Content is standard for Reporting API)
      return Response(204);
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
      return Response.internalServerError(
        body: jsonEncode({'error': 'An unknown error occurred'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
