import 'package:clean_server/features/reporting/domain/entities/coep_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('CoepViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = CoepViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        violationType: 'corp',
        blockedUrl: 'https://other.com/img.png',
        destination: 'image',
        disposition: 'enforce',
      );

      expect(report.id, '1');
      expect(report.type, 'coep');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.violationType, 'corp');
      expect(report.blockedUrl, 'https://other.com/img.png');
      expect(report.destination, 'image');
      expect(report.disposition, 'enforce');
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'coep',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'type': 'corp',
          'blockedURL': 'https://other.com/img.png',
          'destination': 'image',
          'disposition': 'enforce',
        },
      };

      final report = CoepViolationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'coep');
      expect(report.url, 'https://example.com');
      expect(report.violationType, 'corp');
      expect(report.blockedUrl, 'https://other.com/img.png');
      expect(report.destination, 'image');
      expect(report.disposition, 'enforce');
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = CoepViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(
          now.toIso8601String(),
        ), // Normalize for ISO comparison
        violationType: 'corp',
        blockedUrl: 'https://other.com/img.png',
        destination: 'image',
        disposition: 'enforce',
      );

      final map = original.toMap();
      final fromMap = CoepViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.violationType, 'corp');
      expect(fromMap.blockedUrl, 'https://other.com/img.png');
    });

    test('should support equality', () {
      final r1 = CoepViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        violationType: 'v',
      );
      final r2 = CoepViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        violationType: 'v',
      );
      final r3 = CoepViolationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        violationType: 'v',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
