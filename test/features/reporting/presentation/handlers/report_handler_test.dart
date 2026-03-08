import 'dart:convert';

import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:clean_server/features/reporting/domain/repositories/report_repository.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_deprecation_reports.dart';
import 'package:clean_server/features/reporting/presentation/handlers/report_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class MockSubmitDeprecationReports implements SubmitDeprecationReports {
  List<Map<String, dynamic>>? lastReports;

  @override
  ReportRepository get reportRepository => throw UnimplementedError();

  @override
  Future<List<DeprecationReport>> execute(
    List<Map<String, dynamic>> reportMaps,
  ) async {
    lastReports = reportMaps;
    return [];
  }
}

void main() {
  group('ReportHandler', () {
    late MockSubmitDeprecationReports mockSubmit;
    late ReportHandler handler;

    setUp(() {
      mockSubmit = MockSubmitDeprecationReports();
      handler = ReportHandler(submitDeprecationReports: mockSubmit);
    });

    test('should return 204 for valid deprecation reports', () async {
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
        Uri.parse('http://localhost/_reports/deprecation'),
        headers: {'Content-Type': 'application/reports+json'},
        body: jsonEncode(reports),
      );

      final response = await handler.handleDeprecation(request);

      expect(response.statusCode, 204);
      expect(mockSubmit.lastReports, isNotNull);
      expect(mockSubmit.lastReports!.length, 1);
    });

    test('should return 400 for missing content-type', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/_reports/deprecation'),
        body: '[]',
      );

      final response = await handler.handleDeprecation(request);

      expect(response.statusCode, 400);
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['error'], contains('Expected application/reports+json'));
    });

    test('should return 400 for non-array body', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/_reports/deprecation'),
        headers: {'Content-Type': 'application/reports+json'},
        body: '{}',
      );

      final response = await handler.handleDeprecation(request);

      expect(response.statusCode, 400);
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['error'], contains('Expected a JSON array'));
    });
  });
}
