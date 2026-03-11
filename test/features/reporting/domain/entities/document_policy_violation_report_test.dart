import 'package:clean_server/features/reporting/domain/entities/document_policy_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('DocumentPolicyViolationReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
      final report = DocumentPolicyViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'lossy-images-max-bpp',
        disposition: 'enforce',
        message: 'Image exceeds bits-per-pixel policy',
        sourceFile: 'https://example.com/img.jpg',
      );

      expect(report.id, '1');
      expect(report.type, 'document-policy-violation');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.featureId, 'lossy-images-max-bpp');
      expect(report.disposition, 'enforce');
      expect(report.message, 'Image exceeds bits-per-pixel policy');
      expect(report.sourceFile, 'https://example.com/img.jpg');
    });
  });
}
