import 'dart:convert';

import 'package:clean_server/features/reporting/domain/entities/report.dart';
import 'package:clean_server/features/reporting/domain/repositories/report_repository.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_reports.dart';
import 'package:clean_server/features/reporting/presentation/handlers/report_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class MockSubmitReports implements SubmitReports {
  List<Map<String, dynamic>>? lastReports;

  @override
  ReportRepository get reportRepository => throw UnimplementedError();

  @override
  Future<List<Report>> execute(
    List<Map<String, dynamic>> reportMaps,
  ) async {
    lastReports = reportMaps;
    return [];
  }
}

void main() {
  group('ReportHandler', () {
    late MockSubmitReports mockSubmit;
    late ReportHandler handler;

    setUp(() {
      mockSubmit = MockSubmitReports();
      handler = ReportHandler(submitReports: mockSubmit);
    });

    test('should return 204 for valid reports', () async {
      final reports = [
        {
          'type': 'deprecation',
          'age': 0,
          'url': 'x',
          'body': <String, dynamic>{},
        },
      ];
      final request = Request(
        'POST',
        Uri.parse('http://localhost/_reports/default'),
        headers: {'Content-Type': 'application/reports+json'},
        body: jsonEncode(reports),
      );

      final response = await handler.handleDefault(request);

      expect(response.statusCode, 204);
      expect(mockSubmit.lastReports, isNotNull);
      expect(mockSubmit.lastReports!.length, 1);
    });

    test('should return 400 for missing content-type', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/_reports/default'),
        body: '[]',
      );

      final response = await handler.handleDefault(request);

      expect(response.statusCode, 400);
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['error'], contains('Expected application/reports+json'));
    });

    test('should return 400 for non-array body', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/_reports/default'),
        headers: {'Content-Type': 'application/reports+json'},
        body: '{}',
      );

      final response = await handler.handleDefault(request);

      expect(response.statusCode, 400);
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['error'], contains('Expected a JSON array'));
    });
  });
}
