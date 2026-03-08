import 'package:clean_server/features/reporting/data/repositories/in_memory_report_repository.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_deprecation_reports.dart';
import 'package:test/test.dart';

void main() {
  group('SubmitDeprecationReports', () {
    late InMemoryReportRepository repository;
    late SubmitDeprecationReports useCase;

    setUp(() {
      repository = InMemoryReportRepository();
      useCase = SubmitDeprecationReports(repository);
    });

    test('should process and save deprecation reports', () async {
      final reports = [
        {
          'type': 'deprecation',
          'age': 420,
          'url': 'http://localhost:8080/',
          'user_agent': 'Mozilla/5.0...',
          'body': {
            'columnNumber': 976,
            'id': 'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
            'lineNumber': 1,
            'message':
                'Synchronous `XMLHttpRequest` on the main thread is deprecated because of its detrimental effects to the end user\'s experience. For more help, check https://xhr.spec.whatwg.org/.',
            'sourceFile': 'http://localhost:8080/frontend/src/index.js',
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
      expect(
        results.first.featureId,
        'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
      );
      expect(
        results.first.sourceFile,
        'http://localhost:8080/frontend/src/index.js',
      );
      expect(results.first.columnNumber, 976);
      expect(results.first.lineNumber, 1);

      final saved = await repository.listAll();
      expect(saved.length, 1);
      expect(saved.first, equals(results.first));
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
