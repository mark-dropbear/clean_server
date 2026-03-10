import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('DeprecationReport Serialization', () {
    test('should map DeprecationReport to map and back', () {
      final now = DateTime.now().toUtc();
      final report = DeprecationReport(
        id: '123',
        url: 'http://localhost:8080/',
        age: 100,
        receivedAt: now,
        featureId: 'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
        message:
            "Synchronous `XMLHttpRequest` on the main thread is deprecated because of its detrimental effects to the end user's experience. For more help, check https://xhr.spec.whatwg.org/.",
        sourceFile: 'http://localhost:8080/frontend/src/index.js',
        lineNumber: 1,
        columnNumber: 976,
      );

      final map = report.toMap();
      final fromMap = DeprecationReport.fromMap(map);

      expect(fromMap, equals(report));
      expect(fromMap.id, '123');
      expect(fromMap.receivedAt, now);
      expect(
        fromMap.featureId,
        'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
      );
      expect(fromMap.columnNumber, 976);
    });

    test('should handle nullable fields in mapping', () {
      final now = DateTime.now().toUtc();
      final report = DeprecationReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'legacy-feature',
        message: 'This feature is deprecated',
      );

      final map = report.toMap();
      final fromMap = DeprecationReport.fromMap(map);

      expect(fromMap, equals(report));
      expect(fromMap.sourceFile, isNull);
      expect(fromMap.lineNumber, isNull);
      expect(fromMap.anticipatedRemoval, isNull);
    });

    test('should map from browser JSON (Reporting API)', () {
      final now = DateTime.now().toUtc();
      final json = {
        'type': 'deprecation',
        'age': 420,
        'url': 'http://localhost:8080/',
        'user_agent': 'Mozilla/5.0...',
        'body': {
          'columnNumber': 976,
          'id': 'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
          'lineNumber': 1,
          'message': 'Some message',
          'sourceFile': 'http://localhost:8080/frontend/src/index.js',
        },
      };

      final report = DeprecationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'deprecation');
      expect(report.age, 420);
      expect(report.url, 'http://localhost:8080/');
      expect(report.userAgent, 'Mozilla/5.0...');
      expect(
        report.featureId,
        'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
      );
      expect(report.receivedAt, now);
      expect(report.id, isNotEmpty);
    });
  });
}
