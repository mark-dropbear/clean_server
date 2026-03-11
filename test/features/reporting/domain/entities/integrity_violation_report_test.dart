import 'package:clean_server/features/reporting/domain/entities/integrity_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('IntegrityViolationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
      final report = IntegrityViolationReport(
        id: '101',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        blockedUrl: 'https://example.com/example-framework.js',
        documentUrl: 'https://example.com',
        destination: 'script',
        reportOnly: false,
      );

      expect(report.id, '101');
      expect(report.type, 'integrity-violation');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.blockedUrl, 'https://example.com/example-framework.js');
      expect(report.documentUrl, 'https://example.com');
      expect(report.destination, 'script');
      expect(report.reportOnly, isFalse);
    });

    test('should support equality', () {
      final now = DateTime.now();
      final r1 = IntegrityViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );
      final r2 = IntegrityViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
