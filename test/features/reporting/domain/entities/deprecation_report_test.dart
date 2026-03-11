import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('DeprecationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = DeprecationReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'legacy-feature',
        message: 'This feature is deprecated',
      );

      expect(report.id, '123');
      expect(report.type, 'deprecation');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.featureId, 'legacy-feature');
      expect(report.message, 'This feature is deprecated');
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'deprecation',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'id': 'legacy-feature',
          'message': 'This feature is deprecated',
          'sourceFile': 'https://example.com/main.js',
          'lineNumber': 10,
          'columnNumber': 5,
          'anticipatedRemoval': '2026-12-31',
        },
      };

      final report = DeprecationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'deprecation');
      expect(report.featureId, 'legacy-feature');
      expect(report.message, 'This feature is deprecated');
      expect(report.sourceFile, 'https://example.com/main.js');
      expect(report.lineNumber, 10);
      expect(report.columnNumber, 5);
      expect(report.anticipatedRemoval, DateTime.parse('2026-12-31'));
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = DeprecationReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        featureId: 'legacy-feature',
        message: 'This feature is deprecated',
      );

      final map = original.toMap();
      final fromMap = DeprecationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.featureId, 'legacy-feature');
    });

    test('should support equality', () {
      final r1 = DeprecationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );
      final r2 = DeprecationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );
      final r3 = DeprecationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        featureId: 'f',
        message: 'm',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
