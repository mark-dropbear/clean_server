import 'package:clean_server/features/reporting/domain/entities/coep_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('CoepViolationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
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
  });
}
