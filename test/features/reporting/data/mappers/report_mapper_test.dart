import 'package:clean_server/features/reporting/data/mappers/report_mapper.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('ReportMapper', () {
    test('should map DeprecationReport to map and back', () {
      final now = DateTime.now().toUtc();
      final report = DeprecationReport(
        id: '123',
        url: 'http://localhost:8080/',
        age: 100,
        receivedAt: now,
        featureId: 'XMLHttpRequestSynchronousInNonWorkerOutsideBeforeUnload',
        message:
            'Synchronous `XMLHttpRequest` on the main thread is deprecated because of its detrimental effects to the end user\'s experience. For more help, check https://xhr.spec.whatwg.org/.',
        sourceFile: 'http://localhost:8080/frontend/src/index.js',
        lineNumber: 1,
        columnNumber: 976,
      );

      final map = report.toMap();
      final fromMap = deprecationReportFromMap(map);

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
      final fromMap = deprecationReportFromMap(map);

      expect(fromMap, equals(report));
      expect(fromMap.sourceFile, isNull);
      expect(fromMap.lineNumber, isNull);
      expect(fromMap.anticipatedRemoval, isNull);
    });
  });
}
