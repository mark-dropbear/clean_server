import 'package:clean_server/features/reporting/domain/entities/csp_violation_report.dart';
import 'package:test/test.dart';

void main() {
  group('CspViolationReport', () {
    final now = DateTime.now();

    test('should correctly instantiate and preserve fields', () {
      final report = CspViolationReport(
        id: '789',
        url: 'https://example.com/page.html',
        age: 10,
        receivedAt: now,
        blockedUrl: 'https://malicious.com/script.js',
        disposition: 'enforce',
        effectiveDirective: 'script-src-elem',
        originalPolicy: 'default-src self',
        documentUrl: 'https://example.com/page.html',
        referrer: 'https://google.com/',
        statusCode: 200,
        sample: 'alert(1)',
        sourceFile: 'https://example.com/main.js',
        lineNumber: 123,
        columnNumber: 45,
      );

      expect(report.id, '789');
      expect(report.type, 'csp-violation');
      expect(report.url, 'https://example.com/page.html');
      expect(report.age, 10);
      expect(report.receivedAt, now);
      expect(report.blockedUrl, 'https://malicious.com/script.js');
      expect(report.disposition, 'enforce');
      expect(report.effectiveDirective, 'script-src-elem');
      expect(report.originalPolicy, 'default-src self');
      expect(report.documentUrl, 'https://example.com/page.html');
      expect(report.referrer, 'https://google.com/');
      expect(report.statusCode, 200);
      expect(report.sample, 'alert(1)');
      expect(report.sourceFile, 'https://example.com/main.js');
      expect(report.lineNumber, 123);
      expect(report.columnNumber, 45);
    });

    test('should create from browser JSON (fromJson)', () {
      final json = {
        'type': 'csp-violation',
        'url': 'https://example.com/page.html',
        'age': 10,
        'body': {
          'blockedURL': 'https://malicious.com/script.js',
          'disposition': 'enforce',
          'effectiveDirective': 'script-src-elem',
          'originalPolicy': 'default-src self',
          'documentURL': 'https://example.com/page.html',
          'referrer': 'https://google.com/',
          'statusCode': 200,
          'sample': 'alert(1)',
          'sourceFile': 'https://example.com/main.js',
          'lineNumber': 123,
          'columnNumber': 45,
        },
      };

      final report = CspViolationReport.fromJson(json, receivedAt: now);

      expect(report.type, 'csp-violation');
      expect(report.blockedUrl, 'https://malicious.com/script.js');
      expect(report.disposition, 'enforce');
      expect(report.effectiveDirective, 'script-src-elem');
      expect(report.originalPolicy, 'default-src self');
      expect(report.documentUrl, 'https://example.com/page.html');
      expect(report.referrer, 'https://google.com/');
      expect(report.statusCode, 200);
      expect(report.sample, 'alert(1)');
      expect(report.sourceFile, 'https://example.com/main.js');
      expect(report.lineNumber, 123);
      expect(report.columnNumber, 45);
      expect(report.receivedAt, now);
    });

    test('should support serialization (toMap/fromMap)', () {
      final original = CspViolationReport(
        id: '789',
        url: 'https://example.com/page.html',
        age: 10,
        receivedAt: DateTime.parse(now.toIso8601String()),
        blockedUrl: 'https://malicious.com/script.js',
        disposition: 'enforce',
        effectiveDirective: 'script-src-elem',
        originalPolicy: 'default-src self',
        documentUrl: 'https://example.com/page.html',
        referrer: 'https://google.com/',
        statusCode: 200,
        sample: 'alert(1)',
        sourceFile: 'https://example.com/main.js',
        lineNumber: 123,
        columnNumber: 45,
      );

      final map = original.toMap();
      final fromMap = CspViolationReport.fromMap(map);

      expect(fromMap, equals(original));
      expect(fromMap.blockedUrl, 'https://malicious.com/script.js');
    });

    test('should support equality', () {
      final r1 = CspViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );
      final r2 = CspViolationReport(
        id: '1',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );
      final r3 = CspViolationReport(
        id: '2',
        url: 'x',
        age: 1,
        receivedAt: now,
        blockedUrl: 'b',
      );

      expect(r1, equals(r2));
      expect(r1, isNot(equals(r3)));
      expect(r1.hashCode, equals(r2.hashCode));
    });
  });
}
