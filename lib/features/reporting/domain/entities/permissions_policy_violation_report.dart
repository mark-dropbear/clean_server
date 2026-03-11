import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Permissions Policy violation report.
@immutable
class PermissionsPolicyViolationReport extends Report {
  /// The ID of the feature that was violated (e.g., 'geolocation', 'camera').
  final String featureId;

  /// Whether the violation was enforced ('enforce') or just reported ('report').
  final String disposition;

  /// The URL of the script that triggered the violation.
  final String? sourceFile;

  /// The line number in the source file where the violation occurred.
  final int? lineNumber;

  /// The column number in the source file where the violation occurred.
  final int? columnNumber;

  /// The value of the 'allow' attribute if the violation occurred in an iframe.
  final String? allowAttribute;

  /// Creates a new [PermissionsPolicyViolationReport] instance.
  const PermissionsPolicyViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    required this.featureId,
    required this.disposition,
    super.userAgent,
    this.sourceFile,
    this.lineNumber,
    this.columnNumber,
    this.allowAttribute,
  }) : super(type: 'permissions-policy-violation');

  /// Creates a [PermissionsPolicyViolationReport] from a browser JSON payload.
  factory PermissionsPolicyViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return PermissionsPolicyViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      featureId: body['featureId'] as String? ?? '',
      disposition: body['disposition'] as String? ?? '',
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
      allowAttribute: body['allowAttribute'] as String?,
    );
  }

  /// Creates a [PermissionsPolicyViolationReport] from a storage [Map].
  factory PermissionsPolicyViolationReport.fromMap(Map<String, dynamic> map) {
    return PermissionsPolicyViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      featureId: map['feature_id'] as String,
      disposition: map['disposition'] as String,
      sourceFile: map['source_file'] as String?,
      lineNumber: map['line_number'] as int?,
      columnNumber: map['column_number'] as int?,
      allowAttribute: map['allow_attribute'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'user_agent': userAgent,
      'age': age,
      'received_at': receivedAt.toIso8601String(),
      'feature_id': featureId,
      'disposition': disposition,
      'source_file': sourceFile,
      'line_number': lineNumber,
      'column_number': columnNumber,
      'allow_attribute': allowAttribute,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionsPolicyViolationReport &&
          super == other &&
          featureId == other.featureId &&
          disposition == other.disposition &&
          sourceFile == other.sourceFile &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber &&
          allowAttribute == other.allowAttribute;

  @override
  int get hashCode =>
      super.hashCode ^
      featureId.hashCode ^
      disposition.hashCode ^
      sourceFile.hashCode ^
      lineNumber.hashCode ^
      columnNumber.hashCode ^
      allowAttribute.hashCode;
}
