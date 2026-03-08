import 'package:clean_server/features/reporting/data/mappers/report_mapper.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:test/test.dart';

void main() {
  group('ReportMapper', () {
    test('should map DeprecationReport to map and back', () {
      final now = DateTime.now().toUtc();
      final report = DeprecationReport(
        id: '123',
        url: 'https://example.com',
        age: 100,
        receivedAt: now,
        featureId: 'legacy-feature',
        message: 'This feature is deprecated',
        sourceFile: 'app.js',
        lineNumber: 10,
        columnNumber: 5,
        anticipatedRemoval: now.add(const Duration(days: 30)),
      );

      final map = report.toMap();
      final fromMap = deprecationReportFromMap(map);

      expect(fromMap, equals(report));
      expect(fromMap.id, '123');
      expect(fromMap.receivedAt, now);
      expect(fromMap.anticipatedRemoval, isNotNull);
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
