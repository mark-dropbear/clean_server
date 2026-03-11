import 'dart:convert';

import 'package:clean_server/features/reporting/domain/entities/report.dart';
import 'package:clean_server/features/reporting/domain/repositories/report_repository.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_reports.dart';
import 'package:clean_server/features/reporting/presentation/handlers/report_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

class MockSubmitReports implements SubmitReports {
  List<Report>? lastReports;

  @override
  ReportRepository get reportRepository => throw UnimplementedError();

  @override
  Future<void> execute(List<Report> reports) async {
    lastReports = reports;
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
      final reports = <Map<String, dynamic>>[
        {
          'type': 'deprecation',
          'age': 0,
          'url': 'x',
          'body': <String, dynamic>{'id': 'feat', 'message': 'msg'},
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
      expect(mockSubmit.lastReports!.first.type, 'deprecation');
    });

    test('should skip unsupported report types and still return 204', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'unsupported',
          'age': 0,
          'url': 'x',
          'body': <String, dynamic>{},
        },
        {
          'type': 'deprecation',
          'age': 0,
          'url': 'x',
          'body': <String, dynamic>{'id': 'feat', 'message': 'msg'},
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
      expect(mockSubmit.lastReports!.first.type, 'deprecation');
    });
    test('should return 204 for valid crash report', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'crash',
          'age': 100,
          'url': 'https://example.com',
          'body': <String, dynamic>{'reason': 'oom'},
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
      expect(mockSubmit.lastReports!.first.type, 'crash');
    });

    test('should return 204 for valid csp-violation report', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'csp-violation',
          'age': 50,
          'url': 'https://example.com',
          'body': <String, dynamic>{'effectiveDirective': 'script-src'},
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
      expect(mockSubmit.lastReports!.first.type, 'csp-violation');
    });

    test('should return 204 for valid integrity-violation report', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'integrity-violation',
          'age': 75,
          'url': 'https://example.com',
          'body': <String, dynamic>{'blockedURL': 'https://example.com/lib.js'},
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
      expect(mockSubmit.lastReports!.first.type, 'integrity-violation');
    });

    test('should return 204 for valid coep report', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'coep',
          'age': 30,
          'url': 'https://example.com',
          'body': <String, dynamic>{
            'type': 'corp',
            'blockedURL': 'https://other.com/i.png',
          },
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
      expect(mockSubmit.lastReports!.first.type, 'coep');
    });

    test('should return 204 for valid coop report', () async {
      final reports = <Map<String, dynamic>>[
        {
          'type': 'coop',
          'age': 40,
          'url': 'https://example.com',
          'body': <String, dynamic>{
            'violation': 'access-from-coop-page-to-other',
          },
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
      expect(mockSubmit.lastReports!.first.type, 'coop');
    });
  });
}
