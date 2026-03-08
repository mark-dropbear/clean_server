import 'package:clean_server/features/reporting/domain/entities/report.dart';
import 'package:clean_server/features/reporting/domain/repositories/report_repository.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_deprecation_reports.dart';
import 'package:test/test.dart';

class FakeReportRepository implements ReportRepository {
  final List<Report> savedReports = [];

  @override
  Future<void> save(Report report) async {
    savedReports.add(report);
  }

  @override
  Future<List<T>> listByType<T extends Report>(String type) async {
    return savedReports.whereType<T>().toList();
  }

  @override
  Future<List<Report>> listAll() async {
    return savedReports;
  }
}

void main() {
  group('SubmitDeprecationReports', () {
    late FakeReportRepository repository;
    late SubmitDeprecationReports useCase;

    setUp(() {
      repository = FakeReportRepository();
      useCase = SubmitDeprecationReports(repository);
    });

    test('should process and save deprecation reports', () async {
      final reports = [
        {
          'type': 'deprecation',
          'age': 420,
          'url': 'https://example.com/',
          'user_agent': 'Mozilla/5.0...',
          'body': {
            'id': 'NavigatorGetUserMedia',
            'anticipatedRemoval': '2023-12-31T23:59:59Z',
            'message': 'Use MediaDevices.getUserMedia instead',
            'sourceFile': 'app.js',
            'lineNumber': 10,
            'columnNumber': 40,
          },
        },
        {
          'type': 'other-report',
          'age': 10,
          'url': 'x',
          'body': <String, dynamic>{},
        },
      ];

      final results = await useCase.execute(reports);

      expect(results.length, 1);
      expect(results.first.featureId, 'NavigatorGetUserMedia');
      expect(results.first.sourceFile, 'app.js');
      expect(results.first.anticipatedRemoval, isNotNull);
      expect(repository.savedReports.length, 1);
      expect(repository.savedReports.first, equals(results.first));
    });

    test('should handle empty or missing body fields gracefully', () async {
      final reports = [
        {
          'type': 'deprecation',
          'age': 0,
          'url': 'https://example.com/',
          'body': <String, dynamic>{},
        },
      ];

      final results = await useCase.execute(reports);

      expect(results.length, 1);
      expect(results.first.featureId, '');
      expect(results.first.message, '');
      expect(results.first.sourceFile, isNull);
    });
  });
}
