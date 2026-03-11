import 'package:clean_server/features/reporting/domain/entities/intervention_report.dart';
import 'package:test/test.dart';

void main() {
  group('InterventionReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = InterventionReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        interventionId: 'heavy-ad',
        message: 'Ad was removed',
        sourceFile: 'script.js',
        lineNumber: 10,
        columnNumber: 5,
      );

      expect(report.id, '123');
      expect(report.type, 'intervention');
      expect(report.url, 'https://example.com');
      expect(report.age, 100);
      expect(report.receivedAt, now);
      expect(report.interventionId, 'heavy-ad');
      expect(report.message, 'Ad was removed');
      expect(report.sourceFile, 'script.js');
      expect(report.lineNumber, 10);
      expect(report.columnNumber, 5);
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'intervention',
        'url': 'https://example.com',
        'age': 100,
        'body': {
          'id': 'heavy-ad',
          'message': 'Ad was removed',
          'sourceFile': 'script.js',
          'lineNumber': 10,
          'columnNumber': 5,
        },
      };

      final report = InterventionReport.fromJson(json, receivedAt: now);

      expect(report.type, 'intervention');
      expect(report.interventionId, 'heavy-ad');
      expect(report.message, 'Ad was removed');
      expect(report.sourceFile, 'script.js');
      expect(report.lineNumber, 10);
      expect(report.columnNumber, 5);
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = InterventionReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: DateTime.parse(now.toIso8601String()),
        interventionId: 'heavy-ad',
        message: 'Ad was removed',
        sourceFile: 'script.js',
        lineNumber: 10,
        columnNumber: 5,
      );

      final map = original.toMap();
      final fromMap = InterventionReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.interventionId, 'heavy-ad');
    });

    test('should support equality', () {
      final r1 = InterventionReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        interventionId: 'i',
        message: 'm',
      );
      final r2 = InterventionReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        interventionId: 'i',
        message: 'm',
      );
      final r3 = InterventionReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        interventionId: 'i',
        message: 'm',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
