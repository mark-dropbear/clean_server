import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import '../../../../core/exceptions.dart';
import '../../domain/entities/report.dart';
import '../../domain/use_cases/submit_reports.dart';

/// Handler for browser reporting endpoints.
class ReportHandler {
  static final _logger = Logger('ReportHandler');
  final SubmitReports _submitReports;

  /// Creates a [ReportHandler].
  ReportHandler({required SubmitReports submitReports})
    : _submitReports = submitReports;

  /// Handles reports sent to the 'default' endpoint.
  ///
  /// Expects a POST request with Content-Type: application/reports+json
  /// containing a JSON array of report objects.
  Future<Response> handleDefault(Request request) async {
    // 1. Validate Content-Type
    final contentType = request.headers['content-type'] ?? '';
    if (!contentType.contains('application/reports+json')) {
      _logger.warning('Invalid Content-Type: $contentType');
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

      // 3. Convert JSON to domain entities
      final receivedAt = DateTime.now().toUtc();
      final reports = <Report>[];

      for (final item in json) {
        if (item is Map<String, dynamic>) {
          try {
            reports.add(Report.fromJson(item, receivedAt: receivedAt));
          } on UnsupportedReportException catch (e) {
            _logger.info('Skipping unsupported report type: ${e.message}');
          } on Exception catch (e) {
            _logger.warning('Failed to parse report: $e');
          }
        }
      }

      // 4. Submit to use case
      if (reports.isNotEmpty) {
        await _submitReports.execute(reports);
      }

      // 5. Return success (204 No Content is standard for Reporting API)
      return Response(204);
    } on FormatException catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid JSON: ${e.message}'}),
        headers: {'Content-Type': 'application/json'},
      );
    } on Exception catch (e) {
      _logger.severe('Internal error processing reports: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
        headers: {'Content-Type': 'application/json'},
      );
    } on Object catch (e) {
      _logger.severe('Unknown error processing reports: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'An unknown error occurred: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}
