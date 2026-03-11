import 'package:meta/meta.dart';
import 'package:slugid/slugid.dart';
import 'report.dart';

/// Represents a Document Policy violation report.
@immutable
class DocumentPolicyViolationReport extends Report {
  /// The ID of the policy-controlled feature (e.g., 'lossy-images-max-bpp').
  final String featureId;

  /// Whether the violation was enforced ('enforce') or just reported ('report').
  final String disposition;

  /// A human-readable description of the violation.
  final String? message;

  /// The URL of the script or resource that caused the violation.
  final String? sourceFile;

  /// The line number in the source file where the violation occurred.
  final int? lineNumber;

  /// The column number in the source file where the violation occurred.
  final int? columnNumber;

  /// Creates a new [DocumentPolicyViolationReport] instance.
  const DocumentPolicyViolationReport({
    required super.id,
    required super.url,
    required super.age,
    required super.receivedAt,
    required this.featureId,
    required this.disposition,
    super.userAgent,
    this.message,
    this.sourceFile,
    this.lineNumber,
    this.columnNumber,
  }) : super(type: 'document-policy-violation');

  /// Creates a [DocumentPolicyViolationReport] from a browser JSON payload.
  factory DocumentPolicyViolationReport.fromJson(
    Map<String, dynamic> json, {
    required DateTime receivedAt,
  }) {
    final body = json['body'] as Map<String, dynamic>? ?? {};

    return DocumentPolicyViolationReport(
      id: Slugid.nice().toString(),
      url: json['url'] as String? ?? '',
      userAgent: json['user_agent'] as String?,
      age: json['age'] as int? ?? 0,
      receivedAt: receivedAt,
      featureId: body['featureId'] as String? ?? '',
      disposition: body['disposition'] as String? ?? '',
      message: body['message'] as String?,
      sourceFile: body['sourceFile'] as String?,
      lineNumber: body['lineNumber'] as int?,
      columnNumber: body['columnNumber'] as int?,
    );
  }

  /// Creates a [DocumentPolicyViolationReport] from a storage [Map].
  factory DocumentPolicyViolationReport.fromMap(Map<String, dynamic> map) {
    return DocumentPolicyViolationReport(
      id: map['id'] as String,
      url: map['url'] as String,
      userAgent: map['user_agent'] as String?,
      age: map['age'] as int,
      receivedAt: DateTime.parse(map['received_at'] as String),
      featureId: map['feature_id'] as String,
      disposition: map['disposition'] as String,
      message: map['message'] as String?,
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
      'feature_id': featureId,
      'disposition': disposition,
      'message': message,
      'source_file': sourceFile,
      'line_number': lineNumber,
      'column_number': columnNumber,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentPolicyViolationReport &&
          super == other &&
          featureId == other.featureId &&
          disposition == other.disposition &&
          message == other.message &&
          sourceFile == other.sourceFile &&
          lineNumber == other.lineNumber &&
          columnNumber == other.columnNumber;

  @override
  int get hashCode =>
      super.hashCode ^
      featureId.hashCode ^
      disposition.hashCode ^
      message.hashCode ^
      sourceFile.hashCode ^
      lineNumber.hashCode ^
      columnNumber.hashCode;
}
