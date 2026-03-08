import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('DeprecationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
      final report = DeprecationReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'legacy-feature',
        message: 'This feature is deprecated',
      );

      expect(report.id, '123');
      expect(report.type, 'deprecation');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.featureId, 'legacy-feature');
      expect(report.message, 'This feature is deprecated');
    });

    test('should support equality', () {
      final now = DateTime.now();
      final r1 = DeprecationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );
      final r2 = DeprecationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );
      final r3 = DeprecationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
