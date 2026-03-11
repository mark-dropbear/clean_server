import 'package:clean_server/features/reporting/domain/entities/crash_report.dart';
import 'package:test/test.dart';

void main() {
  group('CrashReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
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

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'crash',
        'url': 'https://example.com/app',
        'age': 2000,
        'body': {
          'reason': 'oom',
          'stack': 'Error stack...',
          'is_top_level': true,
        },
      };

      final report = CrashReport.fromJson(json, receivedAt: now);

      expect(report.type, 'crash');
      expect(report.url, 'https://example.com/app');
      expect(report.reason, 'oom');
      expect(report.stack, 'Error stack...');
      expect(report.isTopLevel, isTrue);
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = CrashReport(
        id: '456',
        url: 'https://example.com/app',
        age: 2000,
        receivedAt: DateTime.parse(now.toIso8601String()),
        reason: 'oom',
        stack: 'Error stack...',
        isTopLevel: true,
      );

      final map = original.toMap();
      final fromMap = CrashReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.reason, 'oom');
    });

    test('should support equality', () {
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
      final r3 = CrashReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        reason: 'r',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
