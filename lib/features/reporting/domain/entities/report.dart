import 'package:meta/meta.dart';
import '../../../../core/exceptions.dart';
import 'coep_violation_report.dart';
import 'coop_violation_report.dart';
import 'crash_report.dart';
import 'csp_violation_report.dart';
import 'deprecation_report.dart';
import 'document_policy_violation_report.dart';
import 'integrity_violation_report.dart';
import 'intervention_report.dart';
import 'network_error_report.dart';
import 'permissions_policy_violation_report.dart';

/// Base class for all browser reports.
@immutable
abstract class Report {
  /// The unique identifier for this report instance.
  final String id;

  /// The report type (e.g., 'deprecation', 'csp-violation').
  final String type;

  /// The URL of the document that generated the report.
  final String url;

  /// The User-Agent of the browser that generated the report.
  final String? userAgent;

  /// The number of milliseconds between report generation and delivery.
  final int age;

  /// The timestamp when the report was received by the server.
  final DateTime receivedAt;

  /// Creates a new [Report] instance.
  const Report({
    required this.id,
    required this.type,
    required this.url,
    required this.age,
    required this.receivedAt,
    this.userAgent,
  });

  /// Polymorphic factory to create a [Report] from a browser JSON payload.
  factory Report.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final type = json['type'] as String?;
    return switch (type) {
      'deprecation' => DeprecationReport.fromJson(json, receivedAt: receivedAt),
      'intervention' => InterventionReport.fromJson(
        json,
        receivedAt: receivedAt,
      ),
      'crash' => CrashReport.fromJson(json, receivedAt: receivedAt),
      'csp-violation' => CspViolationReport.fromJson(
        json,
        receivedAt: receivedAt,
      ),
      'integrity-violation' => IntegrityViolationReport.fromJson(
        json,
        receivedAt: receivedAt,
      ),
      'coep' => CoepViolationReport.fromJson(json, receivedAt: receivedAt),
      'coop' => CoopViolationReport.fromJson(json, receivedAt: receivedAt),
      'document-policy-violation' => DocumentPolicyViolationReport.fromJson(
        json,
        receivedAt: receivedAt,
      ),
      'permissions-policy-violation' =>
        PermissionsPolicyViolationReport.fromJson(json, receivedAt: receivedAt),
      'network-error' => NetworkErrorReport.fromJson(
        json,
        receivedAt: receivedAt,
      ),
      _ => throw UnsupportedReportException(type ?? 'unknown'),
    };
  }

  /// Converts this [Report] to a [Map].
  Map<String, dynamic> toMap();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Report &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          url == other.url &&
          userAgent == other.userAgent &&
          age == other.age &&
          receivedAt == other.receivedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      url.hashCode ^
      userAgent.hashCode ^
      age.hashCode ^
      receivedAt.hashCode;
}
