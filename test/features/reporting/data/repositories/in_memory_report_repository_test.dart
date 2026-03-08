import 'package:clean_server/features/reporting/data/repositories/in_memory_report_repository.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryReportRepository', () {
    late InMemoryReportRepository repository;

    setUp(() {
      repository = InMemoryReportRepository();
    });

    test('should save and list reports', () async {
      final report = DeprecationReport(
        id: '1',
        url: 'url',
        age: 1,
        receivedAt: DateTime.now(),
        featureId: 'f',
        message: 'm',
      );

      await repository.save(report);
      final all = await repository.listAll();
      final byType = await repository.listByType<DeprecationReport>(
        'deprecation',
      );

      expect(all.length, 1);
      expect(all.first, equals(report));
      expect(byType.length, 1);
      expect(byType.first, equals(report));
    });

    test('should return empty list when no reports match type', () async {
      final byType = await repository.listByType<DeprecationReport>('other');
      expect(byType, isEmpty);
    });
  });
}
