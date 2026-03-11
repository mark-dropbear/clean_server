import 'package:clean_server/features/reporting/domain/entities/coop_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('CoopViolationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
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
  });
}
