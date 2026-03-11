import 'package:clean_server/features/reporting/domain/entities/intervention_report.dart';
import 'package:test/test.dart';

void main() {
  group('InterventionReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
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

    test('should support equality', () {
      final now = DateTime.now();
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

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
