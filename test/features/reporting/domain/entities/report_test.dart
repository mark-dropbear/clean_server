import 'package:clean_server/core/exceptions.dart';
import 'package:clean_server/features/reporting/domain/entities/coep_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/coop_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/crash_report.dart';
import 'package:clean_server/features/reporting/domain/entities/csp_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/deprecation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/document_policy_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/integrity_violation_report.dart';
import 'package:clean_server/features/reporting/domain/entities/intervention_report.dart';
import 'package:clean_server/features/reporting/domain/entities/permissions_policy_violation_report.dart';
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

    test('should create IntegrityViolationReport', () {
      final json = {
        'type': 'integrity-violation',
        'url': 'http://test.com',
        'age': 0,
        'body': {'blockedURL': 'http://test.com/script.js'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<IntegrityViolationReport>());
      expect(report.type, 'integrity-violation');
    });

    test('should create CoepViolationReport', () {
      final json = {
        'type': 'coep',
        'url': 'http://test.com',
        'age': 0,
        'body': {'type': 'corp', 'blockedURL': 'http://test.com/img.png'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<CoepViolationReport>());
      expect(report.type, 'coep');
    });

    test('should create CoopViolationReport', () {
      final json = {
        'type': 'coop',
        'url': 'http://test.com',
        'age': 0,
        'body': {'violation': 'access-to-coop-page-from-other'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<CoopViolationReport>());
      expect(report.type, 'coop');
    });

    test('should create DocumentPolicyViolationReport', () {
      final json = {
        'type': 'document-policy-violation',
        'url': 'http://test.com',
        'age': 0,
        'body': {'featureId': 'no-sync-xhr', 'disposition': 'enforce'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<DocumentPolicyViolationReport>());
      expect(report.type, 'document-policy-violation');
    });

    test('should create PermissionsPolicyViolationReport', () {
      final json = {
        'type': 'permissions-policy-violation',
        'url': 'http://test.com',
        'age': 0,
        'body': {'featureId': 'camera', 'disposition': 'enforce'},
      };
      final report = Report.fromJson(json, receivedAt: now);
      expect(report, isA<PermissionsPolicyViolationReport>());
      expect(report.type, 'permissions-policy-violation');
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
