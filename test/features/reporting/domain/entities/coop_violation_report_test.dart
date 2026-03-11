import 'package:clean_server/features/reporting/domain/entities/coop_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('CoopViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = CoopViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        disposition: 'reporting',
        effectivePolicy: 'same-origin',
        violation: 'access-from-coop-page-to-other',
        property: 'postMessage',
        otherDocumentUrl: 'https://other.com',
      );

      expect(report.id, '1');
      expect(report.type, 'coop');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.disposition, 'reporting');
      expect(report.effectivePolicy, 'same-origin');
      expect(report.violation, 'access-from-coop-page-to-other');
      expect(report.property, 'postMessage');
      expect(report.otherDocumentUrl, 'https://other.com');
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'coop',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'disposition': 'reporting',
          'effectivePolicy': 'same-origin',
          'violation': 'access-from-coop-page-to-other',
          'property': 'postMessage',
          'otherDocumentURL': 'https://other.com',
        },
      };

      final report = CoopViolationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'coop');
      expect(report.disposition, 'reporting');
      expect(report.effectivePolicy, 'same-origin');
      expect(report.violation, 'access-from-coop-page-to-other');
      expect(report.property, 'postMessage');
      expect(report.otherDocumentUrl, 'https://other.com');
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = CoopViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        disposition: 'reporting',
        effectivePolicy: 'same-origin',
        violation: 'access-from-coop-page-to-other',
        property: 'postMessage',
        otherDocumentUrl: 'https://other.com',
      );

      final map = original.toMap();
      final fromMap = CoopViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.disposition, 'reporting');
    });

    test('should support equality', () {
      final r1 = CoopViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        disposition: 'd',
      );
      final r2 = CoopViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        disposition: 'd',
      );
      final r3 = CoopViolationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        disposition: 'd',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
