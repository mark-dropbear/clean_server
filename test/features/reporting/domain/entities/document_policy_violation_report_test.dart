import 'package:clean_server/features/reporting/domain/entities/document_policy_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('DocumentPolicyViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
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

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'document-policy-violation',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'featureId': 'lossy-images-max-bpp',
          'disposition': 'enforce',
          'message': 'Image exceeds bits-per-pixel policy',
          'sourceFile': 'https://example.com/img.jpg',
        },
      };

      final report = DocumentPolicyViolationReport.fromJson(
        json,
        receivedAt: now,
      );

      expect(report.type, 'document-policy-violation');
      expect(report.featureId, 'lossy-images-max-bpp');
      expect(report.disposition, 'enforce');
      expect(report.message, 'Image exceeds bits-per-pixel policy');
      expect(report.sourceFile, 'https://example.com/img.jpg');
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = DocumentPolicyViolationReport(
        id: '1',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        featureId: 'lossy-images-max-bpp',
        disposition: 'enforce',
        message: 'Image exceeds bits-per-pixel policy',
        sourceFile: 'https://example.com/img.jpg',
      );

      final map = original.toMap();
      final fromMap = DocumentPolicyViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.featureId, 'lossy-images-max-bpp');
    });

    test('should support equality', () {
      final r1 = DocumentPolicyViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        disposition: 'd',
      );
      final r2 = DocumentPolicyViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        disposition: 'd',
      );
      final r3 = DocumentPolicyViolationReport(
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
