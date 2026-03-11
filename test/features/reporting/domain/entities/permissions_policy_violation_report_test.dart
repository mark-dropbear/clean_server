import 'package:clean_server/features/reporting/domain/entities/permissions_policy_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('PermissionsPolicyViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = PermissionsPolicyViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'geolocation',
        disposition: 'enforce',
        sourceFile: 'https://example.com/main.js',
        lineNumber: 42,
        columnNumber: 10,
        allowAttribute: 'geolocation',
      );

      expect(report.id, '1');
      expect(report.type, 'permissions-policy-violation');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.featureId, 'geolocation');
      expect(report.disposition, 'enforce');
      expect(report.sourceFile, 'https://example.com/main.js');
      expect(report.lineNumber, 42);
      expect(report.columnNumber, 10);
      expect(report.allowAttribute, 'geolocation');
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'permissions-policy-violation',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'featureId': 'geolocation',
          'disposition': 'enforce',
          'sourceFile': 'https://example.com/main.js',
          'lineNumber': 42,
          'columnNumber': 10,
          'allowAttribute': 'geolocation',
        },
      };

      final report = PermissionsPolicyViolationReport.fromJson(
        json,
        receivedAt: now,
      );

      expect(report.type, 'permissions-policy-violation');
      expect(report.featureId, 'geolocation');
      expect(report.disposition, 'enforce');
      expect(report.sourceFile, 'https://example.com/main.js');
      expect(report.lineNumber, 42);
      expect(report.columnNumber, 10);
      expect(report.allowAttribute, 'geolocation');
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = PermissionsPolicyViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        featureId: 'geolocation',
        disposition: 'enforce',
        sourceFile: 'https://example.com/main.js',
        lineNumber: 42,
        columnNumber: 10,
        allowAttribute: 'geolocation',
      );

      final map = original.toMap();
      final fromMap = PermissionsPolicyViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.featureId, 'geolocation');
    });

    test('should support equality', () {
      final r1 = PermissionsPolicyViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        disposition: 'd',
      );
      final r2 = PermissionsPolicyViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        disposition: 'd',
      );
      final r3 = PermissionsPolicyViolationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        disposition: 'd',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
