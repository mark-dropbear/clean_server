import 'package:clean_server/features/reporting/domain/entities/crash_report.dart';
import 'package:test/test.dart';

void main() {
  group('CrashReport', () {
    test('should correctly instantiate and preserve fields', () {
      final now = DateTime.now();
      final report = CrashReport(
        id: '456',
        url: 'https://example.com/app',
        age: 2000,
        receivedAt: now,
        reason: 'oom',
        stack: 'Error stack...',
        isTopLevel: true,
      );

      expect(report.id, '456');
      expect(report.type, 'crash');
      expect(report.url, 'https://example.com/app');
      expect(report.age, 2000);
      expect(report.receivedAt, now);
      expect(report.reason, 'oom');
      expect(report.stack, 'Error stack...');
      expect(report.isTopLevel, isTrue);
    });

    test('should support equality', () {
      final now = DateTime.now();
      final r1 = CrashReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        reason: 'r',
      );
      final r2 = CrashReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        reason: 'r',
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
