import 'package:clean_server/features/reporting/data/repositories/in_memory_report_repository.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:clean_server/features/reporting/domain/use_cases/submit_reports.dart';
import 'package:test/test.dart';

void main() {
  group('SubmitReports', () {
    late InMemoryReportRepository repository;
    late SubmitReports useCase;

    setUp(() {
      repository = InMemoryReportRepository();
      useCase = SubmitReports(repository);
    });

    test('should save reports to repository', () async {
      final now = DateTime.now().toUtc();
      final report = DeprecationReport(
        id: '1',
        url: 'http://localhost/demo',
        age: 0,
        receivedAt: now,
        featureId: 'TestFeature',
        message: 'Test message',
      );

      await useCase.execute([report]);

      final saved = await repository.listAll();
      expect(saved.length, 1);
      expect(saved.first, equals(report));
    });
  });
}
