import 'package:clean_server/features/reporting/domain/entities/permissions_policy_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('PermissionsPolicyViolationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
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
  });
}
