import 'package:clean_server/features/reporting/domain/entities/integrity_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('IntegrityViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
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

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'integrity-violation',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'blockedURL': 'https://example.com/example-framework.js',
          'documentURL': 'https://example.com',
          'destination': 'script',
          'reportOnly': false,
        },
      };

      final report = IntegrityViolationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'integrity-violation');
      expect(report.blockedUrl, 'https://example.com/example-framework.js');
      expect(report.documentUrl, 'https://example.com');
      expect(report.destination, 'script');
      expect(report.reportOnly, isFalse);
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = IntegrityViolationReport(
        id: '101',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        blockedUrl: 'https://example.com/example-framework.js',
        documentUrl: 'https://example.com',
        destination: 'script',
        reportOnly: false,
      );

      final map = original.toMap();
      final fromMap = IntegrityViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.blockedUrl, 'https://example.com/example-framework.js');
    });

    test('should support equality', () {
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
      final r3 = IntegrityViolationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
