import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/reporting/domain/entities/crash_report.dart';
import 'package:clean_server/features/reporting/domain/entities/csp_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/intervention_report.dart';
import 'package:clean_server/features/reporting/domain/entities/report.dart';
import 'package:test/test.dart';

void main() {
  group('Report.fromJson', () {
    final now = DateTime.now();

    test('should create DeprecationReport', () {
      final json = {
        'type': 'deprecation',
        'url': 'http://test.com',
        'age': 0,
        'body': {'id': 'feat', 'message': 'msg'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<DeprecationReport>());
      expect(report.type, 'deprecation');
    });

    test('should create InterventionReport', () {
      final json = {
        'type': 'intervention',
        'url': 'http://test.com',
        'age': 0,
        'body': {'id': 'int', 'message': 'msg'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<InterventionReport>());
      expect(report.type, 'intervention');
    });

    test('should create CrashReport', () {
      final json = {
        'type': 'crash',
        'url': 'http://test.com',
        'age': 0,
        'body': {'reason': 'oom'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<CrashReport>());
      expect(report.type, 'crash');
    });

    test('should create CspViolationReport', () {
      final json = {
        'type': 'csp-violation',
        'url': 'http://test.com',
        'age': 0,
        'body': {'effectiveDirective': 'img-src'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<CspViolationReport>());
      expect(report.type, 'csp-violation');
    });

    test('should throw UnsupportedReportException for unknown type', () {
      final json = {
        'type': 'unknown-type',
        'url': 'http://test.com',
        'age': 0,
        'body': <String, dynamic>{},
      };
      expect(
        () => Report.fromJson(json, receivedAt: now),
        throwsA(isA<UnsupportedReportException>()),
      );
    });
  });
}
