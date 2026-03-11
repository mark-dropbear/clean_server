import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Content Security Policy (CSP) violation report.
@immutable
class CspViolationReport extends Report {
  /// The URL of the resource that was blocked.
  final String? blockedUrl;

  /// How the policy was treated ('enforce' or 'report').
  final String? disposition;

  /// The specific directive that was violated.
  final String? effectiveDirective;

  /// The full CSP policy string that triggered the violation.
  final String? originalPolicy;

  /// The URL of the document where the violation occurred.
  final String? documentUrl;

  /// The referrer of the document in which the violation occurred.
  final String? referrer;

  /// The HTTP status code of the document in which the violation occurred.
  final int? statusCode;

  /// A sample of the resource that caused the violation (if 'report-sample' is used).
  final String? sample;

  /// The URL of the script that caused the violation.
  final String? sourceFile;

  /// The line number in the source file where the violation occurred.
  final int? lineNumber;

  /// The column number in the source file where the violation occurred.
  final int? columnNumber;

  /// Creates a new [CspViolationReport] instance.
  const CspViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    super.userAgent,
    this.blockedUrl,
    this.disposition,
    this.effectiveDirective,
    this.originalPolicy,
    this.documentUrl,
    this.referrer,
    this.statusCode,
    this.sample,
    this.sourceFile,
    this.lineNumber,
    this.columnNumber,
  }) : super(type: 'csp-violation');

  /// Creates a [CspViolationReport] from a browser JSON payload.
  factory CspViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return CspViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      blockedUrl: body['blockedURL'] as String?,
      disposition: body['disposition'] as String?,
      effectiveDirective: body['effectiveDirective'] as String?,
      originalPolicy: body['originalPolicy'] as String?,
      documentUrl: body['documentURL'] as String?,
      referrer: body['referrer'] as String?,
      statusCode: body['statusCode'] as int?,
      sample: body['sample'] as String?,
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
    );
  }

  /// Creates a [CspViolationReport] from a storage [Map].
  factory CspViolationReport.fromMap(Map<String, dynamic> map) {
    return CspViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      blockedUrl: map['blocked_url'] as String?,
      disposition: map['disposition'] as String?,
      effectiveDirective: map['effective_directive'] as String?,
      originalPolicy: map['original_policy'] as String?,
      documentUrl: map['document_url'] as String?,
      referrer: map['referrer'] as String?,
      statusCode: map['status_code'] as int?,
      sample: map['sample'] as String?,
      sourceFile: map['source_file'] as String?,
      lineNumber: map['line_number'] as int?,
      columnNumber: map['column_number'] as int?,
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
      'blocked_url': blockedUrl,
      'disposition': disposition,
      'effective_directive': effectiveDirective,
      'original_policy': originalPolicy,
      'document_url': documentUrl,
      'referrer': referrer,
      'status_code': statusCode,
      'sample': sample,
      'source_file': sourceFile,
      'line_number': lineNumber,
      'column_number': columnNumber,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CspViolationReport &&
          super == other &&
          blockedUrl == other.blockedUrl &&
          disposition == other.disposition &&
          effectiveDirective == other.effectiveDirective &&
          originalPolicy == other.originalPolicy &&
          documentUrl == other.documentUrl &&
          referrer == other.referrer &&
          statusCode == other.statusCode &&
          sample == other.sample &&
          sourceFile == other.sourceFile &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber;

  @override
  int get hashCode =>
      super.hashCode ^
      blockedUrl.hashCode ^
      disposition.hashCode ^
      effectiveDirective.hashCode ^
      originalPolicy.hashCode ^
      documentUrl.hashCode ^
      referrer.hashCode ^
      statusCode.hashCode ^
      sample.hashCode ^
      sourceFile.hashCode ^
      lineNumber.hashCode ^
      columnNumber.hashCode;
}
